//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Felix Lin on 6/16/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    @Binding var chosenPalette: String
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                self.chosenPalette = self.document.palette(after: self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before: self.chosenPalette)
            }, label: { EmptyView() })
            
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
            
            Image(systemName: "keyboard")
                .imageScale(.large)
                .onTapGesture {
                    self.showPaletteEditor = true
            }
            .popover(isPresented: $showPaletteEditor) {
                PaletteEditor(chosenPalette: self.$chosenPalette, isShowing: self.$showPaletteEditor)
                    .environmentObject(self.document)
                    .frame(minWidth: 300, minHeight: 500)
            }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument
    @Binding var chosenPalette: String
    @Binding var isShowing: Bool
    @State private var paletteName: String = ""
    @State private var emojiToAdd: String = ""
    
    var height: CGFloat {
        CGFloat((chosenPalette.count - 1) / 6) * 70 + 70
    }
    let fontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor")
                    .font(.headline)
                    .padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowing = false
                    }) {
                        Text("Done")
                    }
                    .padding()
                }
            }
            
            Divider()
            Form {
                Section {
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                        if !began {
                            self.document.renamePalette(self.chosenPalette, to: self.paletteName)
                        }
                    })
                        .padding()
                    
                    
                    TextField("Add Emoji", text: $emojiToAdd, onEditingChanged: { began in
                        if !began {
                            self.chosenPalette = self.document.addEmoji(self.emojiToAdd, toPalette: self.chosenPalette)
                            self.emojiToAdd = ""
                        }
                    })
                        .padding()
                }
                Section(header: Text("Remove Emoji")) {
                    VStack {
                        Grid(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: self.fontSize))
                                .onTapGesture {
                                    self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette)
                            }
                        }
                        .frame(height: self.height)
                    }
                }
                
            }
            Spacer()
        }
        .onAppear { self.paletteName = self.document.paletteNames[self.chosenPalette] ?? ""}
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant(""))
    }
}
