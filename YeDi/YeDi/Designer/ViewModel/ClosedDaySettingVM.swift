//
//  ClosedDaySettingVM.swift
//  YeDi
//
//  Created by 송성욱 on 10/16/23.
//

import Foundation
import Firebase

class ClosedDaySetting: ObservableObject {
    /// - 설정된 휴무일 구조체 만들어야 함
    @Published var days = [ClosedDay]()
    // Get a reference to rhe database
    let closedDB = Firestore.firestore().collection("closedDays")
    /// - Firestore에 저장된 데이터를 불러온다.
    func addDay(_ designerID: String, _ day: [String]) {
        // Add a documnet to a collection
        closedDB.addDocument(data: [
            "designerID" : designerID,
            "closedDay": day]) { error in
            // Check for errors
                if error == nil {
                    // No errors
                    // Call get data to retrieve latest data
                    self.getDay()
                } else {
                    // Handle the error
                }
        }
    }
    
    func getDay() {
        closedDB.getDocuments { snapshot, error in
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    //Update the days property in the main thread
                    DispatchQueue.main.async {
                        self.days = snapshot.documents.map { d in
                            return ClosedDay(
                                id: d.documentID,
                                designerID: d["designerID"] as? String ?? "[디자이너 없음]",
                                day: d["day"] as? [String] ?? ["[날짜를 추가하세요]"]
                            )
                        }
                    }
                }
            } else {
                // Handle the error
            }
        }
    }
    
    func deleteDay(selectedDay: ClosedDay) {
        guard let closedDayID = selectedDay.id else { return }
        
        closedDB.document(closedDayID).delete() { error in
            if let error = error {
                print("error removing closedDay \(error)")
            } else {
                print("ClosedDay successfully removed!")
            }
        }
    }
}
