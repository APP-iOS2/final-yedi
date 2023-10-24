//
//  TimeSettingDetail.swift
//  YeDi
//
//  Created by 송성욱 on 10/5/23.
//

import SwiftUI

struct TimeSettingDetail: View {
    
    @Binding var showingBreakTimeSetting: Bool
    
    var body: some View {
        TimeHome(showingBreakTimeSetting: $showingBreakTimeSetting)
    }
}

/// 고정된 휴게시간을 보내준다.
struct TimeHome: View {
    
    @StateObject var timeModel = BreakTimeSetting()
    @State var selectedTime: Set<Int> = []
    @State var hour: Int = 1
    @Binding var showingBreakTimeSetting: Bool
    @State var isContent: Bool = false
    @State var showingAlert2: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("휴게시간 설정")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                    Spacer().frame(width: 200)
                    Button {
                        showingBreakTimeSetting = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 20)
                Divider().padding(.bottom)
                
                Picker("시간", selection: $hour) {
                    ForEach(9..<21, id: \.self) { hour in
                        Text("\(hour)시")
                    }
                }
                .pickerStyle(.wheel)
                
                HStack {
                    Button(action: {
                        selectedTime.insert(hour)
                        isContent = true
                    }, label: {
                        Text("추가")
                    })
                    .buttonStyle(.bordered)
                    .padding(.leading, 3)
                    
                    Button(action: {
                        selectedTime = []
                        isContent = false
                    }, label: {
                        Text("초기화")
                    })
                    .buttonStyle(.bordered)
                    .padding(.leading, 3)
                    Button(action: {
                        showingAlert2.toggle()
                    }, label: {
                        Text("설정하기")
                    })
                    .disabled(isContent ? false : true)
                    .buttonStyle(.bordered)
                    .padding(.leading, 3)
                    
                    .alert(isPresented: $showingAlert2) {
                        Alert(
                            title: Text("휴게시간 설정"),
                            message: Text("설정하시겠습니까?"),
                            primaryButton: .destructive(Text("취소")) {
                                showingAlert2 = false
                            },
                            secondaryButton: .default(Text("설정하기"), action: {
                                // 선택된 시간 파이어베이스에 저장
                                timeModel.addTimes( intSetToDateStrings(intSet: selectedTime, dateFormat: "HH:mm"))
                                
                                selectedTime = []
                                // toast messege 추후 구현
                            }))
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 21)
                        .foregroundStyle(Color.gray4)
                        .frame(width: .infinity, height: 370)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    
                    ScrollView {
                        if isContent {
                            ForEach(intSetToDateStrings(intSet: selectedTime, dateFormat: "HH:mm"), id: \.self) { time in
                                Text("\(time)")
                            }
                        } else {
                            Text("휴게시간을 추가해주세요.")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                                .padding(.top, 10)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
    
    func intSetToDateStrings(intSet: Set<Int>, dateFormat: String) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let dateStrings = intSet.map { intValue in
            if let date = Calendar.current.date(bySettingHour: intValue, minute: 0, second: 0, of: Date()) {
                return dateFormatter.string(from: date)
            }
            return ""
        }
        return dateStrings
    }
}

extension View {
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

#Preview {
    TimeSettingDetail(showingBreakTimeSetting: .constant(true))
}
