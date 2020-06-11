//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Felix Lin on 6/10/20.
//  Copyright © 2020 Felix Lin. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
