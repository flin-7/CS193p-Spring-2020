//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Felix Lin on 5/20/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        NavigationView {
            VStack {
                Grid(viewModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.75)) {
                                self.viewModel.choose(card: card)
                            }
                    }
                    .padding(5)
                }
                .padding()
                .foregroundColor(viewModel.chosenTheme.color)
                .font(viewModel.cards.count < 5 ? Font.largeTitle : Font.body)
                .layoutPriority(10)
                
                Text("Score: \(viewModel.score)")
                    .font(Font.title)
            }
            .navigationBarTitle(Text(viewModel.chosenTheme.name))
            .navigationBarItems(trailing:
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.75)) {
                        self.viewModel.newGame()
                    }
                }) {
                    Text("New Game")
                }
            )
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90), clockWise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                        }
                    } else {
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90), clockWise: true)
                    }
                }
                .padding(5)
                .opacity(0.4)
                .transition(.identity)
                
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
    }
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
