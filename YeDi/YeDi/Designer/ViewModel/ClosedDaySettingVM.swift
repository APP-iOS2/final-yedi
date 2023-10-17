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
    /// - Firestore에 저장된 데이터를 불러온다.
    func addDay(_ designerID: String, _ day: [String]) {
        
        // Get a reference to rhe database
        let db = Firestore.firestore()
        
        // Add a documnet to a collection
        db.collection("closedDays").addDocument(data: [
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
        let db = Firestore.firestore()
        
        db.collection("closedDays").getDocuments { snapshot, error in
            
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    //Update the days property in the main thread
                    DispatchQueue.main.async {
                        self.days = snapshot.documents.map { d in
                            
                            return ClosedDay(id: d.documentID,
                                             designerID: d["designerID"] as? String ?? "[디자이너 없음]",
                                             day: d["day"] as? [String] ?? ["[날짜를 추가하세요]"])
                        }
                    }
                }
            } else {
                // Handle the error
            }
        }
    }
}
