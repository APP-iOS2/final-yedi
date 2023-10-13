//
//  CMReviewViewModel.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/06.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class CMReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    
    let collectionRef = Firestore.firestore().collection("reviews")
    let storageRef = Storage.storage().reference()
    
    var downloadURLs: [String] = []
    
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
    
    @MainActor
    func uploadReview(review: Review) async {
        self.downloadURLs = []
        
        do {
            var newReview = review
            
            for imageURLString in newReview.imageURLStrings {
                let localFile = URL(string: imageURLString)!
                let temp = UUID().uuidString
                
                storageRef.child("reviews/\(temp)").putFile(from: localFile)
                
                try await Task.sleep(for: .seconds(3))
                
                let downloadURL = try await storageRef.child("reviews/\(temp)").downloadURL()
                self.downloadURLs.append(downloadURL.absoluteString)
                
                print(downloadURLs)
            }
            
            newReview.imageURLStrings = downloadURLs
            
            try collectionRef.document(newReview.id ?? "").setData(from: newReview)
        } catch {
            print("Error updating client reviews: \(error)")
        }
    }
}
