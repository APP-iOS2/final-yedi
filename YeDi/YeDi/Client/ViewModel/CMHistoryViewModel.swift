//
//  CMHistoryViewModel.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/24.
//

import SwiftUI
import FirebaseFirestore

/// 예약 내역 뷰 모델
class CMHistoryViewModel: ObservableObject {
    // MARK: - Properties
    @Published var reservations: [Reservation] = []
    
    /// reservations 컬렉션 참조 변수
    let collectionRef = Firestore.firestore().collection("reservations")
    
    // MARK: - Method
    @MainActor
    func fetchReservation(userAuth: UserAuth) async {
        self.reservations = []
        
        do {
            if let clientId = userAuth.currentClientID {
                let docSnapshot = try await collectionRef.whereField("clientUID", isEqualTo: clientId).getDocuments()
                
                for doc in docSnapshot.documents {
                    if let reservation = try? doc.data(as: Reservation.self) {
                        self.reservations.append(reservation)
                    }
                }
                
                self.reservations = self.reservations.sorted { $0.reservationTime < $1.reservationTime }
            }
        } catch {
            print("Error fetching client reviews: \(error)")
        }
    }
}
