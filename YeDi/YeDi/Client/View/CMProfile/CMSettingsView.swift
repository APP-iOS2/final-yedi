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
    
    var body: some View {
        VStack {
            Button {
                userAuth.signOut()
            } label: {
                Text("로그아웃")
            }
        }
    }
}

#Preview {
    CMSettingsView()
}
