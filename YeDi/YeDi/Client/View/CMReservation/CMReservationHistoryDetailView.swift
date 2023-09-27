//
//  CMReservationHistoryDetailView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI
import MapKit

struct CMReservationHistoryDetailView: View {
    @State private var isShowingCancelSheet = false
    @State private var myDate = Date()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var isUpcomingReservation: Bool {
        return myDate > Date()
    }
    
    var reservationStatusText: String {
        return isUpcomingReservation ? "다가오는 예약" : "지난 예약"
    }
    
    var scheduleOrRiveiw: () -> Void {
        return isUpcomingReservation ? 
        { /* 다가오는 예약일 때의 액션 */ } :
        { /* 지난 예약일 때의 액션 */ }
    }
    
    var cancelOrReservation: () -> Void {
        return isUpcomingReservation ?
        { isShowingCancelSheet = true } :
        { /* 지난 예약일 때의 액션 */ }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 30) {
                Group {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("유매리 디자이너")
                            .font(.title3)
                        Text("디자인 컷")
                            .font(.title)
                    }
                    .fontWeight(.semibold)
                    
                    HStack {
                        Text(formatDate(date: myDate))
                            .onAppear {
                                self.myDate = createDate(year: 2023, month: 10, day: 10, hour: 14, minute: 45)
                            }
                        Spacer()
                        Text(reservationStatusText)
                            .foregroundStyle(.white)
                            .padding(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
                            .background(
                                Capsule(style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.black)
                            )
                    }
                }
                .offset(y: 50)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .frame(height: 300)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    .opacity(0.3)
            )
            .offset(y: -10)
            
            Spacer(minLength: 50)
            
            VStack(alignment: .leading) {
                Text("샵 정보")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("서울특별시 종로구 종로3길 17")
                Map(coordinateRegion: $region, showsUserLocation: true)
                
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("결제정보")
                    .font(.title2)
                    .fontWeight(.semibold)
                Divider()
                HStack {
                    Text("결제수단")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    Text("무통장 입금")
                }
                
                HStack {
                    Text("결제금액")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    Text("33,000원")
                }
            }
            .padding()
            
            HStack {
                Button(action: {
                    scheduleOrRiveiw()
                },label: {
                    HStack {
                        Spacer()
                        Text(isUpcomingReservation ? "일정 변경" : "리뷰 작성")
                        Spacer()
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(.black)
                Button(action: {
                    cancelOrReservation()
                },label: {
                    HStack {
                        Spacer()
                        Text(isUpcomingReservation ? "예약 취소" : "다시 예약")
                        Spacer()
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(isUpcomingReservation ? .red : .black)
            }
            .padding()
            
            Spacer()
        }
        .sheet(isPresented: $isShowingCancelSheet, content: {
            CMReservationCancelView(isShowingCancelSheet: $isShowingCancelSheet)
                .presentationDetents([.medium])
        })
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let calendar = Calendar.current
        return calendar.date(from: dateComponents) ?? Date()
    }
}

#Preview {
    CMReservationHistoryDetailView()
}
