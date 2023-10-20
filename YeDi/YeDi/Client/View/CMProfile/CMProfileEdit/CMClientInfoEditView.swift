//
//  CMClientInfoEditView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/26.
//

import SwiftUI

/// 회원 정보 수정 뷰
struct CMClientInfoEditView: View {
    // MARK: - Properties
    @Binding var clientName: String
    @Binding var clientGender: String
    @Binding var clientBirthDate: String
    
    @State private var selectedGender: String = "여성"
    @State private var selectedBirthDate: Date = Date()
    
    @State private var isShowingDatePicker: Bool = false
    
    let genders: [String] = ["여성", "남성"]
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - 이름 수정 섹션
            HStack {
                Text("이름")
                    .padding(.trailing, 40)
                TextField("고객 이름", text: $clientName)
                    .textFieldStyle(CMCustomTextFieldStyle())
            }
            .padding(.bottom, 15)
            
            // MARK: - 성별 수정 섹션
            HStack {
                Text("성별")
                    .padding(.trailing, 40)
                HStack(spacing: 0) {
                    ForEach(genders, id: \.self) { gender in
                        Button(action: {
                            selectedGender = gender
                        }, label: {
                            Text(gender)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .foregroundStyle(Color.primaryLabel)
                                .background(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.systemFill, lineWidth: 1)
                                )
                        })
                        .background(selectedGender == gender ? Color.systemFill : .myColor)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 15)
            
            // MARK: - 생년월일 수정 섹션
            HStack {
                Text("생년월일")
                    .padding(.trailing, 12)
                HStack {
                    Text("\(clientBirthDate)")
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
        }
        .padding()
        .onAppear {
            selectedGender = clientGender
            selectedBirthDate = DateFormatter().date(from: clientBirthDate) ?? Date()
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
                    clientBirthDate = dateFormatter.string(from: selectedBirthDate)
                    
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

#Preview {
    CMClientInfoEditView(
        clientName: .constant(""),
        clientGender: .constant(""),
        clientBirthDate: .constant("")
    )
}
