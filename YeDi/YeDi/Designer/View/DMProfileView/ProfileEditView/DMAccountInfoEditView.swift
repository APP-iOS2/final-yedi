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
                    .padding(.trailing, 55)
                Text("\(accountEmail)")
                Spacer()
            }
            .padding(.bottom, 15)
            
            HStack {
                Text("휴대폰 번호")
                    .padding(.trailing, 20)
                TextField("휴대폰 번호", text: $accountPhoneNumber)
                    .textFieldStyle(CMCustomTextFieldStyle())
            }
            .padding(.bottom, 15)
        }
        .padding()
    }
}
