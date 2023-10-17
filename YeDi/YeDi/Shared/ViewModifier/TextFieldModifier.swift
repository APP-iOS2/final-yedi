//
//  TextFieldModifier.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/18.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding(12)
            .foregroundStyle(Color.primary)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.quaternarySystemFill)
            }
    }
}
