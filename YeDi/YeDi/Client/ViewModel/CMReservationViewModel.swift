//
//  CMReservationViewModel.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/10/19.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class CMReservationViewModel: ObservableObject {
    @Published var dates: [Date] = []
    @Published var openingTime: Int = 0
    @Published var closingTime: Int = 0
    @Published var breakTime: [Int] = []
    private let db = Firestore.firestore()
    private var closedDay: ClosedDay = ClosedDay(id: "", day: [])
    private var currentUserUid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    @MainActor
    func createReservation(reservation: Reservation) async {
        guard let uid = currentUserUid else { return }
        do {
            var updatedReservation = reservation
            updatedReservation.clientUID = uid
            try db.collection("reservations").addDocument(from: updatedReservation)
        } catch {
            print("createReservation Error: \(error)")
        }
    }
    
    @MainActor
    func fetchCalendar(designerUID: String) async {
        do {
            let querySnapshot = try await db.collection("closedDays").whereField("designerID", isEqualTo: designerUID).getDocuments()
            for document in querySnapshot.documents {
                closedDay = try document.data(as: ClosedDay.self)
            }
            
            for day in closedDay.day {
                let date = SingleTonDateFormatter.sharedDateFommatter.changeStringToDate(dateString: day)
                self.dates.append(date)
            }
            print(dates)
        } catch {
            print("fetchCalendar Error: \(error)")
        }
    }
    
    @MainActor
    func fetchOperatingTime(designerUID: String) async {
        do {
            let querySnapshot = try await db.collection("designers").document(designerUID).collection("shop").getDocuments()
            
            for document in querySnapshot.documents {
                if let openingHour = document.data()["openingHour"] as? String,
                   let closingHour = document.data()["closingHour"] as? String {
                    self.openingTime = Int(openingHour) ?? 9
                    self.closingTime = Int(closingHour) ?? 21
                }
            }
        } catch {
            print("fetchOperatingTime Error: \(error)")
        }
    }

    @MainActor
    func fetchAvailableReservationTime(date: Date, designerUID: String) async {
        do {
            let startDateString = SingleTonDateFormatter.sharedDateFommatter.firebaseDate(from: date)
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            let endDateString = SingleTonDateFormatter.sharedDateFommatter.firebaseDate(from: endDate)
            let querySnapShot = try await db.collection("reservations").whereField("designerUID", isEqualTo: designerUID).whereField("reservationTime", isGreaterThanOrEqualTo: startDateString).whereField("reservationTime", isLessThan: endDateString).getDocuments()
            self.breakTime = []
            for document in querySnapShot.documents {
                let reservationTime = try document.data(as: Reservation.self).reservationTime
                guard let hour = extractHoursFromTimeString(reservationTime) else { return }
                self.breakTime.append(hour)
            }
        } catch {
            
        }
    }
    
    // TODO: -
    @MainActor
    func fetchBreakTime(designerUID: String) async {
        
    }
    

    private func extractHoursFromTimeString(_ timeString: String) -> Int? {
       let date = SingleTonDateFormatter.sharedDateFommatter.changeStringToDate(dateString: timeString)
            // Calendar를 사용하여 Date에서 시간 구성 요소를 추출
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: date)
            
            // 시간 구성 요소에서 시간 값을 추출
            if let hour = components.hour {
                return hour
            }
        
        return nil
    }
}
