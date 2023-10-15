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
    
    @State private var password: String = ""
    @State private var doubleCheckPassword: String = ""
    
    @State private var cautionPassword: String = ""
    @State private var cautionDoubleCheckPassword: String = ""
    
    @State private var isPasswordValid: Bool = true
    @State private var isDoubleCheckPasswordValid: Bool = true
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("새로운 패스워드")
                TextField("새로운 패스워드", text: $password)
                    .signInTextFieldStyle(isTextFieldValid: $isPasswordValid)
                    .onChange(of: password) { newValue in
                        if !checkPassword() {
                            password = newValue.trimmingCharacters(in: .whitespaces)
                        }
                    }
                
                Text(cautionPassword)
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
                    userAuth.updatePassword(password) { success in
                        if success {
                            dismiss()
                        } else {
                            print("비밀번호 변경 실패")
                        }
                    }
                }
            } label: {
                Text("변경하기")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.black)
                    }
            }
            .padding(.top)
        }
        .padding(.horizontal)
        .navigationTitle("비밀번호 변경")
    }
    
    private func checkPassword() -> Bool {
        if checkPasswordValid(password) {
            cautionPassword = ""
            isPasswordValid = true
        } else {
            cautionPassword = "알파벳, 숫자를 이용하여 6자 이상의 비밀번호를 입력해주세요."
            isPasswordValid = false
        }
        return isPasswordValid
    }
    
    private func doubleCheckPasswordValid() -> Bool {
        if password == doubleCheckPassword {
            cautionDoubleCheckPassword = ""
            isDoubleCheckPasswordValid = true
        } else {
            cautionDoubleCheckPassword = "패스워드가 일치하지 않습니다."
            isDoubleCheckPasswordValid = false
        }
        return isDoubleCheckPasswordValid
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9]).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}

#Preview {
    UpdatePasswordView()
}
