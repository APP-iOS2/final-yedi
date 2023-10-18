//
//  UpdatePasswordView.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/15.
//

import SwiftUI

struct UpdatePasswordView: View {
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.dismiss) private var dismiss
    
    private let authRegex = AuthRegex.shared
    
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var doubleCheckPassword: String = ""
    
    @State private var cautionCorrectPassword: String = ""
    @State private var cautionNewPassword: String = ""
    @State private var cautionDoubleCheckPassword: String = ""
    
    @State private var isCorrectPassword: Bool = true
    @State private var isNewPasswordValid: Bool = true
    @State private var isDoubleCheckPasswordValid: Bool = true
    
    private var userEmail: String {
        guard let email = userAuth.userSession?.email else { return "" }
        return email
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("현재 패스워드")
                TextField("현재 패스워드", text: $currentPassword)
                    .signInTextFieldStyle(isTextFieldValid: $isCorrectPassword)
                    .onChange(of: currentPassword) { newValue in
                        currentPassword = newValue.trimmingCharacters(in: .whitespaces)
                    }
                
                Text(cautionCorrectPassword)
                    .cautionTextStyle()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("새로운 패스워드")
                TextField("새로운 패스워드", text: $newPassword)
                    .signInTextFieldStyle(isTextFieldValid: $isNewPasswordValid)
                    .onChange(of: newPassword) { newValue in
                        if !checkPassword() {
                            newPassword = newValue.trimmingCharacters(in: .whitespaces)
                        }
                    }
                
                Text(cautionNewPassword)
                    .cautionTextStyle()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("패스워드 체크")
                TextField("패스워드 체크", text: $doubleCheckPassword)
                    .signInTextFieldStyle(isTextFieldValid: $isDoubleCheckPasswordValid)
                    .onChange(of: doubleCheckPassword) { newValue in
                        if !doubleCheckPasswordValid() {
                            doubleCheckPassword = newValue.trimmingCharacters(in: .whitespaces)
                        }
                    }
                
                Text(cautionDoubleCheckPassword)
                    .cautionTextStyle()
            }
            
            Button {
                if checkPassword() && doubleCheckPasswordValid() {
                    userAuth.updatePassword(userEmail, currentPassword, newPassword) { success in
                        if success {
                            dismiss()
                        } else {
                            cautionCorrectPassword = "현재 비밀번호를 정확하게 입력해 주세요."
                            isCorrectPassword = false
                        }
                    }
                }
            } label: {
                Text("변경하기")
                    .buttonModifier(.mainColor)
            }
            .padding(.top)
        }
        .padding(.horizontal)
        .navigationTitle("비밀번호 변경")
    }
    
    private func checkPassword() -> Bool {
        if authRegex.checkPasswordValid(newPassword) {
            cautionNewPassword = ""
            isNewPasswordValid = true
        } else {
            cautionNewPassword = "알파벳, 숫자를 이용하여 6자 이상의 비밀번호를 입력해주세요."
            isNewPasswordValid = false
        }
        return isNewPasswordValid
    }
    
    private func doubleCheckPasswordValid() -> Bool {
        if newPassword == doubleCheckPassword {
            cautionDoubleCheckPassword = ""
            isDoubleCheckPasswordValid = true
        } else {
            cautionDoubleCheckPassword = "패스워드가 일치하지 않습니다."
            isDoubleCheckPasswordValid = false
        }
        return isDoubleCheckPasswordValid
    }
}

#Preview {
    UpdatePasswordView()
}
