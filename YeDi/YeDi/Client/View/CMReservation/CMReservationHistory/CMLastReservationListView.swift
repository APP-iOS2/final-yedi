//
//  CMLastReservationListView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/26.
//

import SwiftUI
import FirebaseFirestore

/// 지난 예약 목록 뷰
struct CMLastReservationListView: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var cmHistoryViewModel: CMHistoryViewModel
    
    /// 지난 예약 목록 변수
    @State private var lastReservations: [Reservation] = []
    
    // MARK: - Body
    var body: some View {
        VStack {
            if lastReservations.isEmpty {
                Spacer()
                Text("지난 예약이 없습니다")
                    .fontWeight(.bold)
            } else {
                ScrollView {
                    ForEach(lastReservations) { reservation in
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
                
                // 지난 예약만 가져오도록 필터링
                lastReservations = cmHistoryViewModel.reservations.filter({ $0.isFinished == true })
                // 지난 예약 > 예약 일시가 먼 순으로 정렬
                lastReservations = lastReservations.sorted { $0.reservationTime > $1.reservationTime }
            }
        })
    }
}

#Preview {
    CMLastReservationListView()
}
