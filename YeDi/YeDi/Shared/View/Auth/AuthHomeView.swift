//
//  AuthHomeView.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/06.
//

import SwiftUI

struct AuthHomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("로그인")
                    .font(.title.bold())
                    .padding(.bottom, 5)
                
                LoginView()
                .padding(.bottom, 20)
                
                Text("회원가입")
                    .font(.title.bold())
                    .padding(.bottom, 5)
                
                RegisterView()
            }
        }
    }
}

#Preview {
    AuthHomeView()
}
