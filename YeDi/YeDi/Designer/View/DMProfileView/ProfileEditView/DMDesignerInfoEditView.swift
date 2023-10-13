//
//  DMDesignerInfoEditView.swift
//  YeDi
//
//  Created by 박찬호 on 10/13/23.
//

import SwiftUI

struct DMDesignerInfoEditView: View {
    @Binding var designerName: String
    @Binding var designerRank: Rank
    @Binding var designerGender: String
    @Binding var designerBirthDate: String
    @Binding var isShowingDatePicker: Bool
    
    @State private var designerDescription: String = ""
    @State private var designerShopName: String = ""
    @State private var designerShopAddress: String = ""
    
    let genders = ["남성", "여성"]
    let ranks = Rank.allCases // 모든 Rank enum 값
    
    @State private var selectedGender: String = ""
    @State private var selectedRank: Rank = .Designer
    
    var body: some View {
        VStack(spacing: 20) {  // 섹션 간의 간격을 20으로 설정
            HStack {
                Text("이름")
                    .padding(.trailing, 40)
                TextField("designerName", text: $designerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Text("직급")
                    .padding(.trailing, 40)
                
                Picker("직급 선택", selection: $designerRank) {
                    ForEach(ranks, id: \.self) { rank in
                        Text(rank.rawValue).tag(rank)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            }
            
            HStack {
                Text("성별")
                    .padding(.trailing, 40)
                
                HStack(spacing: 0) {
                    ForEach(genders, id: \.self) { gender in
                        Button(action: {
                            selectedGender = gender
                            designerGender = selectedGender
                        }, label: {
                            Text(gender)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .foregroundStyle(.black)
                                .background(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color(white: 0.9), lineWidth: 1)
                                )
                        })
                        .background(selectedGender == gender ? Color(white: 0.9) : .white)
                        
                    }
                    Spacer()
                }
            }
            
            // 생년월일 섹션
            HStack {
                Text("생년월일")
                    .padding(.trailing, 12)
                HStack {
                    Text("\(designerBirthDate)")
                    Spacer()
                    Button(action: {
                        isShowingDatePicker.toggle()
                    }, label: {
                        Image(systemName: "calendar")
                            .foregroundStyle(.black)
                    })
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color(white: 0.9), lineWidth: 1)
                )
            }
            
            VStack(alignment: .leading) {
                Text("샵 정보")
                    .padding(.bottom, 8)
                TextField("샵 이름", text: $designerShopName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 8)
                TextField("샵 주소", text: $designerShopAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading) {
                Text("소개글")
                    .padding(.bottom, 8)
                TextEditor(text: $designerDescription)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            }
        }
        .padding([.top, .leading, .trailing], 20) // 전체 섹션의 상단, 좌측, 우측에 간격을 추가
    }
}
