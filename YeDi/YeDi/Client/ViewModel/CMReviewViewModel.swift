//
//  CMReviewViewModel.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/06.
//

import Foundation
import FirebaseFirestore

class CMReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    
    let collectionRef = Firestore.firestore().collection("reviews")
    
    func fetchReview() async {
        
    }
    
    func uploadReview(newReview: Review) {
        do {
            try collectionRef.document(newReview.id ?? "").setData(from: newReview)
            
            self.reviews.append(newReview)
        } catch {
            print("Error updating client reviews: \(error)")
        }
    }
}
