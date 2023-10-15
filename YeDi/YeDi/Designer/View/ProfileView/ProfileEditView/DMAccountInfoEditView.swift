//
//  DMAccountInfoEditView.swift
//  YeDi
//
//  Created by 박찬호 on 10/13/23.
//

import SwiftUI

struct DMAccountInfoEditView: View {
    @Binding var accountEmail: String
    @Binding var accountPhoneNumber: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("이메일")
                    .padding(.trailing, 40)
                TextField("이메일", text: $accountEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.bottom, 15)
            
            HStack {
                Text("휴대폰 번호")
                    .padding(.trailing, 20)
                TextField("휴대폰 번호", text: $accountPhoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.bottom, 15)
        }
        .padding()
    }
}
