//
//  ResetPasswordView.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/15.
//

import SwiftUI

struct ResetPasswordView: View {
    let userType: UserType
    
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.dismiss) private var dismiss
    
    @State private var email: String = ""
    @State private var cautionEmail: String = ""
    
    @State private var isShowingEmailSentSuccessAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("""
                비밀번호를 잃어버리셨나요? 걱정마세요.
                비밀번호를 재설정할 수 있는 링크를 이메일로 보내드립니다.
                
                가입하신 이메일을 입력해주세요.
                """)
            
            TextField("이메일", text: $email)
                .keyboardType(.emailAddress)
                .signInTextFieldStyle(isTextFieldValid: .constant(true))
                .onChange(of: email) { newValue in
                    email = newValue.trimmingCharacters(in: .whitespaces)
                }
            
            Text(cautionEmail)
                .cautionTextStyle()
            
            Button {
                if !email.isEmpty {
                    userAuth.resetPassword(forEmail: email, userType: userType) { success in
                        if success {
                            cautionEmail = ""
                            isShowingEmailSentSuccessAlert.toggle()
                        } else {
                            cautionEmail = "올바르지 않은 이메일 주소입니다."
                        }
                    }
                }
            } label: {
                Text("보내기")
                    .buttonModifier(.mainColor)
            }
            .padding(.top)
        }
        .padding(.horizontal)
        .navigationTitle("비밀번호 재설정")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                DismissButton(color: nil) { }
            }
        }
        .alert("재설정 메일을 성공적으로 전송했습니다.", isPresented: $isShowingEmailSentSuccessAlert) {
            Button(role: .none) {
                isShowingEmailSentSuccessAlert.toggle()
                dismiss()
            } label: {
                Text("확인")
            }
        }
    }
}

#Preview {
    ResetPasswordView(userType: .client)
}
