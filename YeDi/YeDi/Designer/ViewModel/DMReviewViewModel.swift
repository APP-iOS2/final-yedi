//
//  DMReviewViewModel.swift
//  YeDi
//
//  Created by 송성욱 on 10/11/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

class ReviewModel: ObservableObject {
    
    @Published var reviews = [Review]()
    /// Get a  firestore database
    func getData() {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Read the documents at a specific path
        db.collection("reviews").getDocuments { snapshot, error in
            
            //check the error
            if error == nil {
                // no errors
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async {
                        // Get all the documents and create reviews
                        self.reviews = snapshot.documents.map { d in
                            // Get all the documents and create reviews
                            return Review(id: d.documentID,
                                          reviewer: d["reviewr"] as? String ?? "리뷰어 없음",
                                          date: d["date"] as? String ?? "날짜 없음",
                                          keywordReviews: d["keywordReviews"] as? [Keyword] ?? [] ,
                                          designerScore: d["designerScore"] as? Int ?? 0,
                                          content: d["content"] as? String ?? "",
                                          imageURLStrings: d["imageURLStrings"] as? [String] ?? ["이미지 없음"],
                                          reservationId: d["reservationId"] as? String ?? "예약ID 없음",
                                          style: d["style"] as? String ?? "스타일 없음",
                                          designer: d["designer"] as? String ?? "디자이너ID 없음")
                        }
                    }
                }
            }
            else {
                // Handle the error
            }
        }
    }
}


