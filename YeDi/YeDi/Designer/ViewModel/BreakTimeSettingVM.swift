//
//  BreakTimeSettingVM.swift
//  YeDi
//
//  Created by 송성욱 on 10/17/23.
//

import SwiftUI
import Firebase

class BreakTimeSetting: ObservableObject {
    
    @Published var breakTimes = [BreakTime]()
    /// - firestore에 시간 데이터를 저장한다.
    func addTimes(_ designerID: String, _ breakTime: [String]) {
       
        let db = Firestore.firestore()
        
        db.collection("breakTimes").addDocument(data: ["designerID" : designerID, "breakTime": breakTime]) { error in
            if error == nil {
                self.getTimes()
            } else {
                // Handle the error
            }
        }
    }
    
    /// - firestore 에서 시간을 들고온다
    func getTimes() {
        let db = Firestore.firestore()
        
        db.collection("breakTimes").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    /// Update the days property in the main thread
                    DispatchQueue.main.async {
                        self.breakTimes = snapshot.documents.map { d in
                            return BreakTime(designerID: d["designerID"] as? String ?? "[디자이너 없음]",
                                             breakTime: d["breakTime"] as? [String] ?? ["[시간을 설정하세요]"])
                        }
                    }
                }
            } else {
                // Handle the error
            }
        }
    }
}
