//
//  DMDesignerInfoEditView.swift
//  YeDi
//
//  Created by 박찬호 on 10/13/23.
//

import SwiftUI

struct DMDesignerInfoEditView: View {
    // MARK: - Properties
    @Binding var designerName: String
    @Binding var designerRank: Rank
    @Binding var designerGender: String
    @Binding var designerBirthDate: String
    @Binding var isShowingDatePicker: Bool
    @Binding var designerDescription: String  // 디자이너 소개글
    
    @State private var designerShopName: String = ""  // 디자이너의 샵 이름
    @State private var designerShopAddress: String = ""  // 디자이너의 샵 주소
    
    @State private var selectedBirthDate: Date = Date()
    @State private var selectedGender: String = "여성"  // 선택된 성별
    @State private var selectedRank: Rank = .Designer  // 선택된 직급

    let genders = ["여성", "남성"]  // 성별 옵션
    let ranks = Rank.allCases  // 모든 Rank enum 값
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            // MARK: - 이름 섹션
            HStack {
                Text("이름")
                    .padding(.trailing, 40)
                TextField("디자이너 이름", text: $designerName)
                    .textFieldStyle(CMCustomTextFieldStyle())
            }

            // MARK: - 직급 섹션
            HStack {
                Text("직급")
                    .padding(.trailing, 34)
                Picker("직급 선택", selection: $designerRank) {
                    ForEach(ranks, id: \.self) { rank in
                        Text(rank.rawValue).tag(rank)
                    }
                }
                .accentColor(Color.primaryLabel)
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 10))
            }

            // MARK: - 성별 섹션
            HStack {
                Text("성별")
                    .padding(.trailing, 40)
                HStack(spacing: 0) {
                    ForEach(genders, id: \.self) { gender in
                        Button(action: {
                            designerGender = gender
                        }, label: {
                            Text(gender)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .foregroundStyle(Color.primaryLabel)
                                .background(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.gray6, lineWidth: 2)
                                )
                        })
                        .background(designerGender == gender ? Color.gray4 : Color.gray6)
                    }
                }
                
                Spacer()
            }

            // MARK: - 생년월일 섹션
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
                            .foregroundStyle(Color.primaryLabel)
                    })
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.systemFill, lineWidth: 1)
                )
            }
            .padding(.bottom, 10)

            // MARK: - 소개글 섹션
            VStack(alignment: .leading) {
                Text("소개글")
                    .padding(.bottom, 8)
                TextField("\(designerDescription)", text: $designerDescription, axis: .vertical)
                    .textFieldStyle(DMCustomTextFieldStyle())
            }
        }
        .padding([.top, .leading, .trailing], 20) // 전체 섹션의 상단, 좌측, 우측에 패딩을 추가
        .onAppear {
            selectedBirthDate = DateFormatter().date(from: designerBirthDate) ?? Date()
        }
        .sheet(isPresented: $isShowingDatePicker, content: {
            VStack {
                // MARK: - 생년월일 데이트 피커
                DatePicker("생년월일", selection: $selectedBirthDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                
                // MARK: - 생년월일 선택 버튼
                Button(action: {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                    designerBirthDate = dateFormatter.string(from: selectedBirthDate)
                    
                    isShowingDatePicker.toggle()
                }, label: {
                    Text("선택 완료")
                        .frame(width: 330, height: 30)
                })
                .buttonStyle(.borderedProminent)
                .tint(.mainColor)
            }
            .presentationDetents([.fraction(0.4)])
        })
    }
}
