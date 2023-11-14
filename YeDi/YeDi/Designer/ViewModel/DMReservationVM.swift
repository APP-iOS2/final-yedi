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
        
        reservationCol.whereField("designerUID", isEqualTo: "\(userId)").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting reservation list: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    print("예약데이터: \(data)")
                    
                    var hairStyles: [HairStyle] = []
                    //HairStyle 파싱작업
                    if let hairStyleArray = data["hairStyle"] as? [[String: Any]] {
                        for hairStyleData in hairStyleArray {
                            let hairStyle = self.parseHairStyle(hairStyleData)
                            hairStyles.append(hairStyle)
                        }
                        
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
    
    func parseHairStyle(_ data: [String: Any]) -> HairStyle {
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let price = data["price"] as? Int,
              let typeString = data["type"] as? String,
              let type = HairType(rawValue: typeString) else {
            // 필요한 데이터가 없거나 데이터 변환이 실패한 경우 기본값을 반환하거나 에러 처리를 수행할 수 있습니다.
            return HairStyle(id: "", name: "", type: .cut, price: 0)
        }
        return HairStyle(id: id, name: name, type: type, price: price)
    }
    
    func fetchUserUID() -> String? {
        return  Auth.auth().currentUser?.uid
    }
}

//sample structure
// -  sample task
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
