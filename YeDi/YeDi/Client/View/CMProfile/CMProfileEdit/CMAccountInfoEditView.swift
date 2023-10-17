//
//  CMAccountInfoEditView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/26.
//

import SwiftUI

/// 계정 정보 수정 뷰
struct CMAccountInfoEditView: View {
    // MARK: - Properties
    @Binding var accountPhoneNumber: String
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                Text("휴대폰")
                    .padding(.trailing, 30)
                TextField("휴대폰 번호", text: $accountPhoneNumber)
                    .textFieldStyle(CMCustomTextFieldStyle())
            }
        }
        .padding()
    }
}

#Preview {
    CMAccountInfoEditView(
        accountPhoneNumber: .constant("")
    )
}
