//
//  CMSettingsView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

/// 고객 설정 뷰
struct CMSettingsView: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var isShowingSignOutAlert: Bool = false
    @State private var isShowingDeleteClientAccountAlert: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            List {
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
