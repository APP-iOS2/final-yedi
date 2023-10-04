//
//  CMAccountInfoEditView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/26.
//

import SwiftUI

struct CMAccountInfoEditView: View {
    @Binding var accountEmail: String
    @Binding var accountPhoneNumber: String
    
    var body: some View {
        VStack {
            HStack {
                Text("이메일")
                    .padding(.trailing, 30)
                TextField("accountEmail", text: $accountEmail)
                    .textFieldStyle(CMCustomTextFieldStyle())
            }
            .padding(.bottom, 15)
            
            HStack {
                Text("휴대폰")
                    .padding(.trailing, 30)
                TextField("accountPhoneNumber", text: $accountPhoneNumber)
                    .textFieldStyle(CMCustomTextFieldStyle())
            }
        }
        .padding()
    }
}

#Preview {
    CMAccountInfoEditView(
        accountEmail: .constant(""),
        accountPhoneNumber: .constant("")
    )
}
