//
//  DMReservationVM.swift
//  YeDi
//
//  Created by 송성욱 on 10/19/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


//MARK: - Reservation History View Model

class ReservationVM: ObservableObject {
    /// - 예약 목록 변수
    @Published var reservations = [Reservation]()
    /// - 예약 참조 상수
    let reservationCol = Firestore.firestore().collection("reservations")
    /// - 고객 참조 상수
    let clientCol = Firestore.firestore().collection("clients")
    
    func getReservation() {
        
        guard let userId = fetchUserUID() else {
            debugPrint("로그인 정보를 찾을 수 없음")
            return
        }
        
        reservationCol
            .whereField("designerUID", isEqualTo: "\(userId)")
            .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting reservation list: \(error)")
                
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    print("예약데이터: \(data)")
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let reservation = try JSONDecoder().decode(Reservation.self, from: jsonData)
                        self.reservations.append(reservation)
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
    
    func getClientData(for clientUID: String, completion: @escaping ([String: Any]?) -> Void) {
           clientCol.document(clientUID).getDocument { (document, error) in
               if let error = error {
                   print("Error getting client data: \(error)")
                   completion(nil)
               } else {
                   if let document = document, document.exists {
                       let data = document.data()
                       completion(data)
                   } else {
                       print("클라이언트 데이터를 찾을 수 없음")
                       completion(nil)
                   }
               }
           }
       }
    
    final func fetchUserUID() -> String? {
        return  Auth.auth().currentUser?.uid
    }
}

//sample structure
/// -  sample task
//struct Tasks: Identifiable {
//    var id: UUID = .init()
//    var dateAdded: Date
//    var reservationName: String
//    var reservationDC: String
//
//}

//struct Reservation: Codable, Identifiable {
//    @DocumentID var id: String?
//    var clientUID: String
//    let designerUID: String
//    let reservationTime: String
//    let hairStyle: [HairStyle]
//    let isFinished: Bool
//}



