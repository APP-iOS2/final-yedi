//
//  CMUpcomingReservationView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/26.
//

import SwiftUI

struct CMUpcomingReservationView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var cmHistoryViewModel: CMHistoryViewModel
    
    @State private var upcomingReservations: [Reservation] = []
    
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
                upcomingReservations = cmHistoryViewModel.reservations.filter({ $0.isFinished == false })
            }
        })
    }
}

#Preview {
    CMUpcomingReservationView()
        .environmentObject(UserAuth())
        .environmentObject(CMHistoryViewModel())
}
