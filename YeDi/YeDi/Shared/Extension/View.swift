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
    
    /// Text Field 관련 Auth Modifier
    func signInTextFieldStyle(isTextFieldValid: Binding<Bool>) -> some View {
        return modifier(
            SignInTextFieldStyle(isTextFieldValid: isTextFieldValid)
        )
    }
    
    /// 주의 메시지 관련 Auth Modifier
    func cautionTextStyle() -> some View {
        return modifier(CautionTextStyle())
    }
    
    /// Chatting Bubble Modifier 정의 함수
    func chatBubbleModifier(_ isMyChat: Bool) -> some View {
        return modifier(ChatBubbleModifier(isMyChat: isMyChat))
    }
    
    /// 모든 버튼 형태 통일을 위한 button Modifier
    /// - 커스텀 버튼이 아닌 ViewModifier을 사용한 이유는 NavigationLink도 Button과 동일한 형태를 취하고 있는 것들이 있기 때문입니다.
    /// - Button(label:) / NavigationLink(label:)에 들어가는 Text에게 사용해주세요.
    /// - .buttonModifier(.mainColor)
    func buttonModifier(_ color: Color) -> some View {
        return modifier(ButtonModifier(color: color))
    }
    
    /// text field Modifier
    func textFieldModifier() -> some View {
        return modifier(TextFieldModifier())
    }
}
