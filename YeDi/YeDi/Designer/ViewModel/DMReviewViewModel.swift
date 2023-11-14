//
//  DMReviewViewModel.swift
//  YeDi
//
//  Created by 송성욱 on 10/11/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase

final class ReviewModel: ObservableObject {
    
    @Published var reviews = [Review]()
    
    func fetchReviews() {
        guard let userId = fetchUserUID() else {
            debugPrint("로그인 정보를 찾을 수 없음")
            return
        }
        
        let colRef = Firestore.firestore().collection("reviews").whereField("designer", isEqualTo: "\(userId)")
        
        colRef.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                debugPrint("Error getting reviews: \(error)")
            }
            
            if let snapshot = snapshot, !snapshot.isEmpty {
                self?.reviews = snapshot.documents.compactMap { try? $0.data(as: Review.self)}
            }
        }
    }
        
    final func fetchUserUID() -> String? {
        return  Auth.auth().currentUser?.uid
    }
    
}
