//
//  ClosedDaySettingVM.swift
//  YeDi
//
//  Created by 송성욱 on 10/16/23.
//

import Foundation
import Firebase
import FirebaseAuth

class ClosedDaySetting: ObservableObject {
    /// - 설정된 휴무일 구조체 만들어야 함
    @Published var days = [ClosedDay]()
    private var currentUserUid: String? {
        return Auth.auth().currentUser?.uid
    }
    // Get a reference to rhe database
    let closedDB = Firestore.firestore().collection("closedDays")
    
    /// - Fetch data
    func addDay(_ day: [String]) {
        guard let currentUserUid = currentUserUid else {
            print("사용자가 로그인되지 않았습니다")
            return
        }
        
        let myDay = closedDB.document()
        
        myDay.setData(["id": myDay.documentID, "designerUID": currentUserUid, "closedDay": day]) { error in
            if let error = error {
                print("데이터 추가 중 에러발생 \(error.localizedDescription)")
            } else {
                self.getDay()
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
                                designerUID: d["designerUid"] as? String ?? "Don`t have userId",
                                closedDay: d["day"] as? [String] ?? ["[날짜를 추가하세요]"]
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

