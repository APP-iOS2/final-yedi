//
//  ButtonModifier.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/16.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    let color: Color?
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(color ?? .primary)
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}
