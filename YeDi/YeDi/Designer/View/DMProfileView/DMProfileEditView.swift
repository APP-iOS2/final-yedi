//
//  DMProfileEditView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/10/05.
//

import SwiftUI
import PhotosUI

struct DMProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var profileVM: DMProfileViewModel
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedPhotoData: Data = Data()
    
    @State private var designerName: String = "루디"
    @State private var designerRank: String = "원장"
    @State private var designerGender: String = "여성"
    @State private var designerBirthDate: String = "2000.01.01"
    
    @State private var shopName: String = "킹덤헤어 지축점"
    @State private var introduction: String = "본인만의 아름다움을 만들어드립니다."
    
    @State private var accountEmail: String = "yedi1234@gmail.com"
    @State private var accountPhoneNumber: String = "010-1234-5678"
    
    var body: some View {
        NavigationStack {
            Form {
                // 회원 정보
                Section(header: Text("회원 정보").font(.headline)) {
                    // 프로필 사진
                    HStack {
                        Spacer()
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .padding()
                        Spacer()
                    }
                    // 디자이너 정보
                    DMDesignerInfoEditView(
                        designerName: $designerName,
                        designerRank: $designerRank,
                        designerGender: $designerGender,
                        designerBirthDate: $designerBirthDate
                    )
                }
                
                // 샵 정보
                Section(header: Text("샵 지점").font(.headline)) {
                    DMShopInfoEditView(
                        shopName: $shopName,
                        introduction: $introduction
                    )
                }
                
                // 계정 정보
                Section(header: Text("계정 정보").font(.headline)) {
                    DMAccountInfoEditView(
                        accountEmail: $accountEmail,
                        accountPhoneNumber: $accountPhoneNumber
                    )
                }
                
                // 저장 버튼
                Section {
                    Button("저장", action: {
                        // 저장 로직
                        dismiss()
                    })
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("프로필 편집")
        }
    }
}

// 디자이너 정보 서브뷰
struct DMDesignerInfoEditView: View {
    @Binding var designerName: String
    @Binding var designerRank: String
    @Binding var designerGender: String
    @Binding var designerBirthDate: String
    
    var body: some View {
        TextField("디자이너 이름", text: $designerName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        Picker("직급", selection: $designerRank) {
            Text("원장").tag("원장")
            Text("실장").tag("실장")
            Text("디자이너").tag("디자이너")
            Text("인턴").tag("인턴")
        }
        .pickerStyle(MenuPickerStyle())
        Picker("성별", selection: $designerGender) {
            Text("남성").tag("남성")
            Text("여성").tag("여성")
        }
        .pickerStyle(MenuPickerStyle())
        TextField("생년월일", text: $designerBirthDate)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

// 샵 정보 서브뷰
struct DMShopInfoEditView: View {
    @Binding var shopName: String
    @Binding var introduction: String
    
    var body: some View {
        TextField("샵 이름", text: $shopName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        TextEditor(text: $introduction)
            .frame(height: 100)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
    }
}

// 계정 정보 서브뷰
struct DMAccountInfoEditView: View {
    @Binding var accountEmail: String
    @Binding var accountPhoneNumber: String
    
    var body: some View {
        TextField("이메일", text: $accountEmail)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("휴대폰 번호", text: $accountPhoneNumber)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}


#Preview {
    DMProfileEditView()
}
