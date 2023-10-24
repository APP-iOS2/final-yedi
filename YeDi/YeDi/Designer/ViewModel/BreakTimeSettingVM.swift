//
//  BreakTimeSettingVM.swift
//  YeDi
//
//  Created by 송성욱 on 10/17/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

class BreakTimeSetting: ObservableObject {
    
    @Published var breakTimes = [BreakTime]()
    private var currentUserUid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    let db = Firestore.firestore().collection("breakTimes")
       
       func addTimes(_ selectedTime: [String]) {
           guard let currentUserUid = currentUserUid else {
               print("사용자가 로그인되지 않았습니다")
               return
           }
           
           let myTime = db.document()
           
           myTime.setData(["id": myTime.documentID, "designerUid": currentUserUid, "selectedTime": selectedTime]) { error in
               if let error = error {
                   print("데이터 추가 중 에러발생 \(error.localizedDescription)")
               } else {
                   self.getTimes()
               }
           }
       }
    
    /// - firestore 에서 시간을 들고온다
    func getTimes() {
        db.getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    /// Update the days property in the main thread
                    DispatchQueue.main.async {
                        self.breakTimes = snapshot.documents.map { d in
                            return BreakTime(
                                id: d.documentID,
                                designerUid: d["designerUid"] as? String ?? "유저 id",
                                selectedTime: d["selectedTime"] as? [String] ?? ["[시간을 설정하세요]"]
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


