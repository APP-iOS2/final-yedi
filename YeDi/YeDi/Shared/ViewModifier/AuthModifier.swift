//
//  AuthModifier.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/06.
//

import SwiftUI

struct SignInTextFieldStyle: ViewModifier {
    @Binding var isTextFieldValid: Bool
    
    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding(12)
            .foregroundStyle(Color.primary)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(isTextFieldValid ? Color.quaternarySystemFill : .red.opacity(0.2))
            }
    }
}

struct CautionTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.red)
    }
}
