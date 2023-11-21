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
    @Binding var clientEmail: String
    @Binding var clientPhoneNumber: String
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - 이메일 수정
            HStack {
                Text("이메일")
                    .padding(.trailing, 30)
                Spacer()
                Text("\(clientEmail)")
            }
            .padding(.bottom, 15)
            
            // MARK: - 휴대폰 번호 수정
            HStack {
                Text("휴대폰 번호")
                TextField("휴대폰 번호", text: $clientPhoneNumber)
                    .textFieldStyle(CMCustomTextFieldStyle())
            }
        }
        .padding()
    }
}

#Preview {
    CMAccountInfoEditView(
        clientEmail: .constant(""),
        clientPhoneNumber: .constant("")
    )
}
