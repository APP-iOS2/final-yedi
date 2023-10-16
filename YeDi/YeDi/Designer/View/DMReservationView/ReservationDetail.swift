//
//  ReservationDetail.swift
//  YeDi
//
//  Created by 송성욱 on 2023/09/27.
//

import SwiftUI

struct ReservationDetail: View {
    
    @Binding var isShowing: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    HStack {
                        Text("예약정보")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                        Spacer()
                        Text("다가오는 예약")
                            .frame(width: 120, height: 40)
                            .background(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 1))
                    }
                    
                    HStack {
                        Text("고객 성함")
                            .fontWeight(.bold)
                        Spacer()
                        Text("김고객 님")
                    }
                    
                    HStack {
                        Text("시술 일시")
                            .fontWeight(.bold)
                        Spacer()
                        Text("2023.09.26")
                    }
                    
                    HStack {
                        Text("시술 내용")
                            .fontWeight(.bold)
                        Spacer()
                        Text("컷트,펌")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                VStack {
                    HStack {
                        Text("요청 사항")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    Text("요청 사항 내용")
                        .frame(width: 354, height: 200)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    
                    NavigationLink {
                        //다가오는 예약에서 지난 예약인 상태의 뷰로 넘어간다.
                        ReservationSDetail(isShowing: $isShowing)
                    } label: {
                        Text("시술 완료")
                            .frame(width: 354, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1))
                    }
                    .padding(.top)
                   
                    Button {
                        //예약 취소 로직
                    } label: {
                        Text("예약 취소")
                            .frame(width: 354, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowing = false
                    } label: {
                        Label("취소", systemImage: "xmark")
                    }
                }
            })
        }
    }
}

#Preview {
    ReservationDetail(isShowing: .constant(true))
}
