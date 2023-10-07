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
    
    @MainActor
    func fetchReview(userAuth: UserAuth) async {
        self.reviews = []
        
        do {
            if let clientId = userAuth.currentClientID {
                let docSnapshot = try await collectionRef.whereField("reviewer", isEqualTo: clientId).getDocuments()
                
                for doc in docSnapshot.documents {
                    if let review = try? doc.data(as: Review.self) {
                        self.reviews.append(review)
                    }
                }
            }
        } catch {
            print("Error fetching client reviews: \(error)")
        }
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
