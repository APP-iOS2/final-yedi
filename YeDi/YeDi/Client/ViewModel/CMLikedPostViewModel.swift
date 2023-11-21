//
//  CMLikedPostViewModel.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/6/23.
//

import SwiftUI
import FirebaseFirestore

class CMLikedPostViewModel: ObservableObject {
    @Published var likedPosts: [Post] = []
    
    // 클라이언트가 찜한 게시물만 불러오기
    func fetchLikedPosts(forClientID clientID: String) {
        let db = Firestore.firestore()
        
        let likedPostsCollection = db.collection("likedPosts")
        likedPostsCollection
            .whereField("clientID", isEqualTo: clientID)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching liked posts: \(error)")
                    return
                }
                
                var likedPostIDs: [String] = []
                
                for document in snapshot?.documents ?? [] {
                    if let postID = document["postID"] as? String {
                        likedPostIDs.append(postID)
                    }
                }
                
                guard !likedPostIDs.isEmpty else {
                    self.likedPosts.removeAll()
                    return
                }
                
                let postsCollection = db.collection("posts")
                postsCollection
                    .whereField(FieldPath.documentID(), in: likedPostIDs)
                    .getDocuments { snapshot, error in
                        if let error = error {
                            print("Error fetching liked posts: \(error)")
                            return
                        }
                        
                        var likedPosts: [Post] = []
                        
                        for document in snapshot?.documents ?? [] {
                            if let post = try? document.data(as: Post.self) {
                                likedPosts.append(post)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.likedPosts = likedPosts
                        }
                    }
            }
    }
}
