//
//  LoginView.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/06.
//

import SwiftUI

struct LoginView: View {
    let userType: UserType
    
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var cautionLoginFailed: String = ""
    
    @State private var isEmailValid: Bool = true
    @State private var isPasswordValid: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            switch userType {
            case .client:
                loginForClient
            case .designer:
                loginForDesigner
            }
        }
        .task {
            initTextField()
            initCautionText()
            initValidation()
        }
    }
    
    private var loginForClient: some View {
        VStack(alignment: .leading, spacing: 10) {
            inputEmailTextField
            inputPasswordTextField
            
            Text(cautionLoginFailed)
                .cautionTextStyle()
            
            LoginButton(.client)
        }
        .padding(.horizontal)
    }
    
    private var loginForDesigner: some View {
        VStack(alignment: .leading, spacing: 10) {
            inputEmailTextField
            inputPasswordTextField
            
            Text(cautionLoginFailed)
                .cautionTextStyle()
            
            LoginButton(.designer)
        }
        .padding(.horizontal)
    }
    
    private var inputEmailTextField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("이메일")
            TextField("이메일", text: $email)
                .keyboardType(.emailAddress)
                .signInTextFieldStyle(isTextFieldValid: $isEmailValid)
                .onChange(of: email) { newValue in
                    email = newValue.trimmingCharacters(in: .whitespaces)
                }
        }
    }
    
    private var inputPasswordTextField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("패스워드")
            TextField("패스워드", text: $password)
                .keyboardType(.emailAddress)
                .signInTextFieldStyle(isTextFieldValid: $isPasswordValid)
                .onChange(of: email) { newValue in
                    email = newValue.trimmingCharacters(in: .whitespaces)
                }
        }
    }
    
    private func LoginButton(_ userType: UserType) -> some View {
        VStack {
            Button {
                userAuth.signIn(email, password, userType) { success in
                    if !success {
                        cautionLoginFailed = "이메일 및 패스워드가 일치하지 않습니다."
                    }
                }
            } label: {
                Text("로그인")
                    .buttonModifier(.mainColor)
            }
        }
    }
    
    private func initTextField() {
        email = ""
        password = ""
    }
    
    private func initCautionText() {
        cautionLoginFailed = ""
    }
    
    private func initValidation() {
        isEmailValid = true
        isPasswordValid = true
    }
}
