//
//  CMLastReservationView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/26.
//

import SwiftUI
import FirebaseFirestore

struct CMLastReservationView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var cmHistoryViewModel: CMHistoryViewModel
    
    @State private var lastReservations: [Reservation] = []
    
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
                lastReservations = cmHistoryViewModel.reservations.filter({ $0.isFinished == true })
            }
        })
    }
}

#Preview {
    CMLastReservationView()
}
