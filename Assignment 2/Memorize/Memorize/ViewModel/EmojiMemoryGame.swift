//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Felix Lin on 5/23/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private(set) var model: MemoryGame<String>
    
    private(set) var chosenTheme: Theme
    
    private var themes = [
        Theme(name: "Halloween", emojiSets: ["👻", "🎃", "🕷", "👾", "🧟‍♂️", "😈"], numOfCards: 6, color: .orange),
        Theme(name: "Christmas", emojiSets: ["🎄", "🎅🏻", "🤶🏽"], numOfCards: 3, color: .red),
        Theme(name: "Sports", emojiSets: ["🏀", "⚽️", "⚾️", "🏈", "🎾"], numOfCards: 5, color: .blue),
        Theme(name: "Animals", emojiSets: ["🐤", "🐯", "🐧", "🐨", "🐭", "🐸", "🐱", "🐳", "🐷"], numOfCards: 9, color: .purple),
        Theme(name: "Flags", emojiSets: ["🇺🇸", "🇬🇧", "🏴󠁧󠁢󠁳󠁣󠁴󠁿", "🇨🇭", "🇨🇮", "🇹🇩"], numOfCards: 6, color: .green),
        Theme(name: "Tools", emojiSets: ["🛠", "🔨", "🔧", "🔬", "🔭", "🍼"], numOfCards: 6, color: .yellow)
    ]
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojiSets.shuffled()
        let randomNumber = Int.random(in: 2...theme.emojiSets.count)
        return MemoryGame<String>(numberOfPairsOfCards: randomNumber) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    init() {
        chosenTheme = themes[Int.random(in: 0..<themes.count)]
        model = EmojiMemoryGame.createMemoryGame(theme: chosenTheme)
    }
    
    // MARK: - Access to the Model
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func newGame() {
        chosenTheme = themes[Int.random(in: 0..<themes.count)]
        model = EmojiMemoryGame.createMemoryGame(theme: chosenTheme)
    }
}
