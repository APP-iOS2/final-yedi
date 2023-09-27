//
//  ReservationView.swift
//  YeDi
//
//  Created by 송성욱 on 2023/09/26.
//

import SwiftUI

struct ReservationView: View {
    
    @State var isClicked: Bool = false
    let times: [String] = ["10:00", ""]
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink {
                    
                } label: {
                    Text("휴무일 설정")
                        .frame(width: 150, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1))
                }
                Spacer().frame(width: 25)
                NavigationLink {
                    
                } label: {
                    Text("브레이크 타임 설정")
                        .frame(width: 150, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1))
                }
            }
            .padding(.top)
            .padding(.bottom)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<30) { index in
                        Button(action: {
                            isClicked.toggle()
                        }, label: {
                            if isClicked {
                                //오늘 날짜부터 한달 간격으로 보이게 만들 예정
                                Text("6월20일")
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(Color.gray)
                                    .background(Color.black)
                                    .cornerRadius(6)
                            } else {
                                Text("6월20일")
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(Color.black)
                                    .background(Color.gray)
                                    .cornerRadius(6)
                            }
                        })
                    }
                }
            }
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
                            ForEach(0..<10, id: \.self) { index  in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: .infinity, height: 100)
                                        .foregroundStyle(.gray)
                                    
                                    HStack {
                                        VStack {
                                            VStack(alignment: .leading) {
                                                Text("10:00")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        VStack {
                            ForEach(0..<10, id: \.self) { index  in
                                ReservationCellView()
                            }
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
