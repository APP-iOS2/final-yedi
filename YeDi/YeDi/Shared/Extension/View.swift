//
//  View.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/16.
//

import SwiftUI

extension View {
    /// 키보드 내리는 함수
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Auth Modifier 정의 함수
    /// Text Field 관련
    func signInTextFieldStyle(isTextFieldValid: Binding<Bool>) -> some View {
        return modifier(
            SignInTextFieldStyle(isTextFieldValid: isTextFieldValid)
        )
    }
    
    /// Auth Modifier 정의 함수
    /// 주의 메시지 관련
    func cautionTextStyle() -> some View {
        return modifier(CautionTextStyle())
    }
    
    /// Chatting Bubble Modifier 정의 함수
    func chatBubbleModifier(_ isMyChat: Bool) -> some View {
        return modifier(ChatBubbleModifier(isMyChat: isMyChat))
    }
    
    /// button Modifier 정의 함수
    func buttonModifier(_ color: Color) -> some View {
        return modifier(ButtonModifier(color: color))
    }
}
