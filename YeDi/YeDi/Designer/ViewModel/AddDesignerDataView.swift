//
//  AddDesignerDataView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/10/06.
//

import SwiftUI
import Firebase

struct AddDesignerDataView: View {
    var body: some View {
        Button("Add New Designer Data") {
            addNewDesignerData()
        }
    }
    
    func addNewDesignerData() {
        let db = Firestore.firestore()
        
        // 새로 추가할 디자이너 데이터
        let newDesigners = [
            [
                "name": "디자이너1",
                "email": "d1@gmail.com",
                "phoneNumber": "010-1234-5678",
                "description": "나는 디자이너 1입니다",
                "designerScore": 4.9,
                "reviewCount": 25,
                "followerCount": 175,
                "skill": ["커트", "염색"],
                "chatRooms": ["room1"],
                "birthDate": "1980-01-01",
                "gender": "남성",
                "rank": "원장",
                "designerUID": "new_uid_1"  // 실제 UID로 교체 필요
            ],
            [
                "name": "디자이너2",
                "email": "d2@gmail.com",
                "phoneNumber": "010-1234-5679",
                "description": "나는 디자이너 2입니다",
                "designerScore": 4.7,
                "reviewCount": 15,
                "followerCount": 150,
                "skill": ["커트", "펌"],
                "chatRooms": ["room2"],
                "birthDate": "1985-02-02",
                "gender": "여성",
                "rank": "실장",
                "designerUID": "new_uid_2"  // 실제 UID로 교체 필요
            ],
            [
                "name": "디자이너3",
                "email": "d3@gmail.com",
                "phoneNumber": "010-1234-5680",
                "description": "나는 디자이너 3입니다",
                "designerScore": 4.8,
                "reviewCount": 20,
                "followerCount": 200,
                "skill": ["커트", "스타일링"],
                "chatRooms": ["room3"],
                "birthDate": "1990-03-03",
                "gender": "남성",
                "rank": "디자이너",
                "designerUID": "new_uid_3"  // 실제 UID로 교체 필요
            ]
        ]
        
        // 새 디자이너 추가
        for designer in newDesigners {
            db.collection("designers").addDocument(data: designer) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
}

struct AddDesignerDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddDesignerDataView()
    }
}
