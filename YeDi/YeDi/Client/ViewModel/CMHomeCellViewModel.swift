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
    @Published var designer: Designer?
    @Published var isLiked: Bool = false
    @Published var showHeartImage: Bool = false
    @Published var selectedImageIndex: Int = 0
    @Published var shouldShowMoreText: Bool = false
    
    // 게시물을 올린 디자이너의 정보 불러오기
    func fetchDesignerInfo(post: Post) async {
        let db = Firestore.firestore()
        let designerRef = db.collection("designers").document(post.designerID)
        
        do {
            let document = try await designerRef.getDocument()
            // Initialize the designer model using Codable
            designer = try? document.data(as: Designer.self)
            
            // "shop" 하위 컬렉션을 가져오기
            let shopCollectionRef = designerRef.collection("shop")
            let shopSnapshot = try await shopCollectionRef.getDocuments()
            let shopData = shopSnapshot.documents.compactMap { document in
                return try? document.data(as: Shop.self)
            }
            
            // "shop" 정보를 디자이너 모델에 할당
            designer?.shop = shopData.first
            
        } catch {
            print("Error fetching designer document: \(error)")
        }
    }
    
    // 게시물의 찜 여부 확인
    func checkIfLiked(forClientID clientID: String, post: Post) async {
        let db = Firestore.firestore()
        
        do {
            let querySnapshot = try await db.collection("likedPosts")
                .whereField("clientID", isEqualTo: clientID)
                .whereField("postID", isEqualTo: post.id ?? "")
                .getDocuments()
            
            if !querySnapshot.isEmpty {
                // Firestore에서 해당 게시물을 찜되어 있는 경우
                self.isLiked = true
            } else {
                // Firestore에서 해당 게시물을 찜되어 있지 않은 경우
                self.isLiked = false
            }
        } catch {
            print("Error checking liked post: \(error)")
        }
    }
    
    // 게시물 찜 관리
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
                    if let document = snapshot?.documents.first {
                        // 이미 찜한 게시물이므로 Firestore에서 삭제
                        document.reference.delete { error in
                            if let error = error {
                                print("Error unliking post: \(error)")
                            } else {
                                print("Post unliked successfully.")
                                self.isLiked = false
                            }
                        }
                    } else {
                        // 아직 찜하지 않은 게시물인 경우 Firestore에 추가
                        let likedPostData: [String: Any] = [
                            "clientID": clientID,
                            "postID": post.id ?? "",
                            "isLiked": true,
                            "timestamp": FieldValue.serverTimestamp()
                        ]
                        
                        likeCollection.addDocument(data: likedPostData) { error in
                            if let error = error {
                                print("Error liking post: \(error)")
                            } else {
                                print("Post liked successfully.")
                                self.isLiked = true
                            }
                        }
                    }
                }
            }
    }
}
