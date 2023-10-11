//
//  CMSettingsView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

struct CMSettingsView: View {
    // TODO: 임시 로그아웃 버튼
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var isShowingSignOutAlert: Bool = false
    @State private var isShowingDeleteClientAccountAlert: Bool = false
    
    var body: some View {
        VStack {
            List {
                Text("오픈소스 라이브러리")
                Button {
                    isShowingSignOutAlert.toggle()
                } label: {
                    Text("로그아웃")
                }
                
                Button(action: {
                    isShowingDeleteClientAccountAlert.toggle()
                }, label: {
                    Text("계정 삭제")
                })
            }
        }
        .navigationTitle("설정")
        .alert("로그아웃하시겠습니까?", isPresented: $isShowingSignOutAlert) {
            Button(role: .cancel) {
                isShowingSignOutAlert.toggle()
            } label: {
                Text("취소")
            }
            Button(role: .destructive) {
                userAuth.signOut()
                isShowingSignOutAlert.toggle()
            } label: {
                Text("로그아웃")
            }
        }
        .alert("계정을 삭제하시겠습니까?", isPresented: $isShowingDeleteClientAccountAlert) {
            Button(role: .cancel) {
                isShowingDeleteClientAccountAlert.toggle()
            } label: {
                Text("취소")
            }
            Button(role: .destructive) {
                userAuth.deleteClientAccount()
                isShowingDeleteClientAccountAlert.toggle()
            } label: {
                Text("삭제")
            }
        }
    }
}

#Preview {
    NavigationStack {
        CMSettingsView()
    }
}
