//
//  DMaccount.swift
//  YeDi
//
//  Created by 송성욱 on 10/4/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class DMAccount: ObservableObject {
    
    @Published private var dmAccount: [Designer]
    
    let db = Firestore.firestore()
    
    func fetchAccount() {
        db.collection("Designer").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    init() {
        dmAccount = [
            Designer(name: "d1", email: "d1@gmail.com", phoneNumber: "01000000000", designerScore: 4.9, reviewCount: 100, followerCount: 100, skill: ["커트", "펌"], chatRooms: ["1", "2"], birthDate: "", gender: "", rank: .Designer, designerUID: ""),
            Designer(name: "d2", email: "d2@gmail.com", phoneNumber: "01001010101", designerScore: 4.7, reviewCount: 90, followerCount: 90, skill: ["커트", "펌"], chatRooms: ["3", "4"], birthDate: "", gender: "", rank: .Designer, designerUID: ""),
            Designer(name: "d3", email: "d3@gmail.com", phoneNumber: "01002020202", designerScore: 4.6, reviewCount: 80, followerCount: 80, skill: ["커트", "펌"], chatRooms: ["5", "6"], birthDate: "", gender: "", rank: .Designer, designerUID: "")
        ]
    }
}
