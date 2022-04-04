//
//  TextField.swift
//  Keep Time
//
//  Created by Justin Bane on 3/11/22.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    let color: Color
    let padding: CGFloat // <- space between text and border
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .overlay(RoundedRectangle(cornerRadius: padding)
            .stroke(color, lineWidth: lineWidth)
        )
    }
}

// None of this wors well in MacOS - need to learn more on styling the textField
extension View {
    func customTextField(color: Color = .secondary, padding: CGFloat = 0, lineWidth: CGFloat = 0.0) -> some View { // <- Default settings
        self.modifier(TextFieldModifier(color: color, padding: padding, lineWidth: lineWidth))
    }
}
