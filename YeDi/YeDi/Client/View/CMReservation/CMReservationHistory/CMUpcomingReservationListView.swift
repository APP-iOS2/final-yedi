//
//  CMUpcomingReservationListView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/26.
//

import SwiftUI

/// 다가오는 예약 목록 뷰
struct CMUpcomingReservationListView: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var cmHistoryViewModel: CMHistoryViewModel
    
    /// 다가오는 예약 목록 변수
    @State private var upcomingReservations: [Reservation] = []
    
    // MARK: - Body
    var body: some View {
        VStack {
            if upcomingReservations.isEmpty {
                Spacer()
                Text("예정된 예약이 없습니다")
                    .fontWeight(.bold)
            } else {
                ScrollView {
                    ForEach(upcomingReservations) { reservation in
                        NavigationLink {
                            CMReservationHistoryDetailView(reservation: reservation)
                        } label: {
                            CMHistoryCellView(reservation: reservation)
                                .background(Color.gray6)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding([.leading, .trailing])
                                .padding(.top, 5)
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear(perform: {
            Task {
                await cmHistoryViewModel.fetchReservation(userAuth: userAuth)
                
                // 다가오는 예약만 가져오도록 필터링
                upcomingReservations = cmHistoryViewModel.reservations.filter({ $0.isFinished == false })
                // 다가오는 예약 > 예약 일시가 가까운 순으로 정렬
                upcomingReservations = upcomingReservations.sorted { $0.reservationTime < $1.reservationTime }
            }
        })
    }
}

#Preview {
    CMUpcomingReservationListView()
        .environmentObject(UserAuth())
        .environmentObject(CMHistoryViewModel())
}
