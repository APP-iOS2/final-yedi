//
//  CMHomeCellViewModel.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/6/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor
class CMHomeCellViewModel: ObservableObject {
    @Published var isLiked: Bool = false
    @Published var designerName: String?
    @Published var designerImage: String?
    
    func fetchDesignerInfo(post: Post) async {
            let db = Firestore.firestore()
            let designerRef = db.collection("designers").document(post.designerID)

            do {
                let document = try await designerRef.getDocument()
                if let designerData = document.data() {
                    designerName = designerData["name"] as? String
                    designerImage = designerData["imageURLString"] as? String
                }
            } catch {
                print("Error fetching designer document: \(error)")
            }
        }
    
    func checkIfLiked(forClientID clientID: String, post: Post) {
        let db = Firestore.firestore()
        
        db.collection("likedPosts")
            .whereField("clientID", isEqualTo: clientID)
            .whereField("postID", isEqualTo: post.id ?? "")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error checking liked post: \(error)")
                } else {
                    if (snapshot?.documents.first) != nil {
                        // Firestore에서 해당 게시물을 찜되어 있는 경우
                        DispatchQueue.main.async {
                            self.isLiked = true
                        }
                    } else {
                        // Firestore에서 해당 게시물을 찜되어 있지 않은 경우
                        DispatchQueue.main.async {
                            self.isLiked = false
                        }
                    }
                }
            }
    }
    
    func likePost(forClientID clientID: String, post: Post) {
        let db = Firestore.firestore()
        let likeCollection = db.collection("likedPosts")
        
        // 이미 찜한 게시물인지 확인
        likeCollection
            .whereField("clientID", isEqualTo: clientID)
            .whereField("postID", isEqualTo: post.id ?? "")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error checking liked post: \(error)")
                } else {
                    if (snapshot?.documents.first) != nil {
                        // 이미 찜한 게시물이므로 아무 작업도 수행하지 않습니다.
                        // 여기에서 찜 상태를 변경하지 않고 함수 종료
                        return
                    }
                    
                    // 아직 찜하지 않은 게시물인 경우 Firestore에 추가
                    let likedPostData: [String: Any] = [
                        "clientID": clientID,
                        "postID": post.id ?? "",
                        "isLiked": isLiked,
                        "timestamp": FieldValue.serverTimestamp()
                    ]
                    
                    likeCollection.addDocument(data: likedPostData) { error in
                        if let error = error {
                            print("Error liking post: \(error)")
                        } else {
                            print("Post liked successfully.")
                            
                            if !self.isLiked {
                                // isLiked가 false인 경우, 해당 게시물을 Firestore에서 삭제합니다.
                                self.deleteFromFirestore(forClientID: clientID, post: post)
                            }
                        }
                    }
                }
            }
    }
    
    
    private func deleteFromFirestore(forClientID clientID: String, post: Post) {
        let db = Firestore.firestore()
        
        db.collection("likedPosts")
            .whereField("clientID", isEqualTo: clientID)
            .whereField("postID", isEqualTo: post.id ?? "")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error deleting liked post: \(error)")
                } else {
                    for document in snapshot?.documents ?? [] {
                        document.reference.delete()
                    }
                    
                    print("Post unliked successfully.")
                }
            }
    }
}

