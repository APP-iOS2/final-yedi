//
//  AuthModifier.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/06.
//

import SwiftUI

extension View {
    func signInTextFieldStyle(isTextFieldValid: Binding<Bool>) -> some View {
        return modifier(
            SignInTextFieldStyle(isTextFieldValid: isTextFieldValid)
        )
    }
    
    func cautionTextStyle() -> some View {
        return modifier(CautionTextStyle())
    }
}

struct SignInTextFieldStyle: ViewModifier {
    @Binding var isTextFieldValid: Bool
    
    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(isTextFieldValid ? .gray.opacity(0.1) : .red.opacity(0.1))
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
