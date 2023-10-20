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
    
    let db = Firestore.firestore().collection("breakTimes")
    
    /// - firestore에 시간 데이터를 저장한다.
    func addTimes(_ designerID: String, _ breakTime: [String]) {
        db.addDocument(data: ["designerID" : designerID, "breakTime": breakTime]) { error in
            if error == nil {
                self.getTimes()
            } else {
                // Handle the error
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
                                designerID: d["designerID"] as? String ?? "[디자이너 없음]",
                                selectedTime: d["selectedTime"] as? [String] ?? ["[시간을 설정하세요]"],
                                timePeriod: d["timePeriod"] as? TimePeriod ?? .am
                            )
                        }
                    }
                }
            } else {
                // Handle the error
            }
        }
    }
    /// -  저장된 시간 삭제
    func deleteTime() {
        
    }
}


