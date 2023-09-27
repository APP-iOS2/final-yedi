//
//  CMProfileEditView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/26.
//

import SwiftUI
import PhotosUI

struct CMProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    
    @State private var clientName: String = "김고객"
    @State private var clientGender: String = "여성"
    @State private var clientBirthDate: String = "2000.07.11."
    
    @State private var accountEmail: String = "yedi1234@gmail.com"
    @State private var accountPhoneNumber: String = "010-1234-5678"
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .padding([.top, .bottom])
                    .overlay {
                        ZStack {
                            Circle()
                                .trim(from: 0.07, to: 0.43)
                                .fill(Color(white: 0.2))
                                .frame(width: 80)
                            Text("편집")
                                .font(.system(size: 13))
                                .foregroundStyle(.white)
                                .offset(y: 27)
                        }
                    }
            }
            
            Section {
                CMClientInfoEditView(
                    clientName: $clientName,
                    clientGender: $clientGender,
                    clientBirthDate: $clientBirthDate
                )
                .padding(.bottom, 40)
            } header: {
                HStack {
                    Text("회원 정보")
                        .fontWeight(.semibold)
                        .padding(.leading)
                    Spacer()
                }
                Divider()
                    .frame(width: 360)
            }
            
            Section {
                CMAccountInfoEditView(
                    accountEmail: $accountEmail,
                    accountPhoneNumber: $accountPhoneNumber
                )
            } header: {
                HStack {
                    Text("계정 정보")
                        .fontWeight(.semibold)
                        .padding(.leading)
                    Spacer()
                }
                Divider()
                    .frame(width: 360)
            }
            
            Spacer()
            Button(action: {
                // TODO: 이메일, 휴대폰 형식 확인 > 변경 내용 저장
                dismiss()
            }, label: {
                Text("저장")
                    .frame(width: 330, height: 30)
            })
            .buttonStyle(.borderedProminent)
            .tint(.black)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    CMProfileEditView()
}
