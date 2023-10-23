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
    
    /// - Fetch data
    func addDay(_ day: [String]) {
        
        let myDay = closedDB.document()
        
        myDay.setData(["id": myDay.documentID, "closedDay": day]) { error in
            if error == nil {
                self.getDay()
            } else {
                //Handle the error
            }
        }
    }
    
    /// - Firestore에 저장된 데이터를 불러온다.
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
    
    
}

