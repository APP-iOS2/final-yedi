//
//  DMReservationVM.swift
//  YeDi
//
//  Created by 송성욱 on 10/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class ReservationVM: ObservableObject {
    /// - 예약내용을 담는 프로퍼티
    @Published var reservationList = [String]()
    
}




/// sample structure
/// -  sample task
struct Tasks: Identifiable {
    var id: UUID = .init()
    var dateAdded: Date
    var reservationName: String
    var reservationDC: String
    
}

var sampleTasks: [Tasks] = [
    .init(dateAdded: Date(timeIntervalSince1970: 1650022160), reservationName: "송성욱", reservationDC: "hello test")
]

