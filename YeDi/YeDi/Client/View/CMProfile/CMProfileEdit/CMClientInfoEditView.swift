//
//  CMClientInfoEditView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/26.
//

import SwiftUI

struct CMClientInfoEditView: View {
    @Binding var clientName: String
    @Binding var clientGender: String
    @Binding var clientBirthDate: String
    
    @State private var selectedGender: String = "여성"
    @State private var selectedBirthDate: Date = Date()
    
    @State private var isShowingDatePicker: Bool = false
    
    let genders: [String] = ["여성", "남성"]
    
    var body: some View {
        VStack {
            HStack {
                Text("이름")
                    .padding(.trailing, 40)
                TextField("clientName", text: $clientName)
                    .textFieldStyle(CMCustomTextFieldStyle())
            }
            .padding(.bottom, 15)
            
            HStack {
                Text("성별")
                    .padding(.trailing, 40)
                HStack(spacing: 0) {
                    ForEach(genders, id: \.self) { gender in
                        Button(action: {
                            selectedGender = gender
                            clientGender = selectedGender
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
                }
                Spacer()
            }
            .padding(.bottom, 15)
            
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
                            .foregroundStyle(.black)
                    })
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color(white: 0.9), lineWidth: 1)
                )
            }
        }
        .padding()
        .sheet(isPresented: $isShowingDatePicker, content: {
            VStack {
                DatePicker("clientBirthDate", selection: $selectedBirthDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                
                Button(action: {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "YYYY.MM.dd."
                    clientBirthDate = formatter.string(from: selectedBirthDate)
                    
                    isShowingDatePicker.toggle()
                }, label: {
                    Text("선택 완료")
                        .frame(width: 330, height: 30)
                })
                .buttonStyle(.borderedProminent)
                .tint(.black)
            }
            .presentationDetents([.fraction(0.4)])
        })
        .onAppear {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd."
            
            selectedGender = clientGender
            selectedBirthDate = dateFormatter.date(from: clientBirthDate) ?? Date()
        }
    }
}

#Preview {
    CMClientInfoEditView(
        clientName: .constant(""),
        clientGender: .constant(""),
        clientBirthDate: .constant("")
    )
}
