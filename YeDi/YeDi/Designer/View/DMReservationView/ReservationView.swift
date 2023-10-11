//
//  ReservationView.swift
//  YeDi
//
//  Created by 송성욱 on 2023/09/26.
//

import SwiftUI

struct ReservationView: View {
    
    @State var isClicked: Bool = false
    @State var isShowing: Bool = false
    let times: [String] = ["10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00"]
    
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink {
                    WkDaySettingDetail()
                } label: {
                    Text("휴무일 설정")
                        .frame(width: 150, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1))
                }
                Spacer().frame(width: 25)
                NavigationLink {
                   // MARK: Dev머지 후 해당파일 경로수정 필요
                    TimeSettingDetail()
                } label: {
                    Text("브레이크 타임 설정")
                        .frame(width: 150, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1))
                }
            }
            .padding(.top)
            .padding(.bottom)
            
            HCustomCalendar()
            .padding()
            .scrollIndicators(.hidden)
            
            HStack {
                VStack {
                    Divider().padding(.leading)
                }
                Text("영업시작")
                    .font(.caption)
                    .foregroundStyle(.gray)
                VStack {
                    Divider().padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            HStack {
                ScrollView {
                    HStack {
                        VStack {
                            ForEach(times, id: \.self) { time  in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: .infinity, height: 100)

                                        .foregroundColor(.clear)
                                    
                                    HStack {
                                        VStack {
                                            HStack(alignment: .top ) {
                                                Text("\(time)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack {
                            ForEach(0..<15, id: \.self) { index  in
                                Button {
                                    isShowing.toggle()
                                } label: {
                                    ReservationCellView()
                                }
                            }
                            .sheet(isPresented: $isShowing, content: {
                                ReservationDetail(isShowing: $isShowing)
                                    .presentationDetents([.height(630)])
                            })
                            
                        }
                    }
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
            }
            
        }
    }
}

#Preview {
    ReservationView()
}
