//
//  CMPostViewModel.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/27.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class CMPostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    var lastDocument: DocumentSnapshot?
    let pageSize: Int = 3
    
    let dbRef = Firestore.firestore().collection("posts")
    
    // 모든 게시물 불러오기 (페이지네이션)
    func fetchPosts() async {
            var query = dbRef
                .order(by: "timestamp", descending: true)
                .limit(to: pageSize)  // 한 페이지에 표시할 게시물 수
            
            if let lastDocument = self.lastDocument {
                query = query.start(afterDocument: lastDocument)
            }
            do {
                let snapshot = try await query.getDocuments()
                
                if !snapshot.isEmpty {
                    self.posts.append(contentsOf:
                        snapshot.documents.compactMap { document in
                            try? document.data(as: Post.self)
                        }
                    )
                    self.lastDocument = snapshot.documents.last
                    print("Fetched page. Total count:", self.posts.count)
                }
                
            } catch {
               print("Error fetching posts: \(error)")
           }
        }
    
    // 클라이언트가 팔로우한 디자이너의 ID 목록 불러오기
    func getFollowedDesignerIDs(forClientID clientID: String, completion: @escaping ([String]?) -> Void) {
        let followingCollection = Firestore.firestore().collection("following")
        let clientDocument = followingCollection.document(clientID)
        
        clientDocument.getDocument { (document, error) in
            if let error = error {
                print("Error getting following document: \(error)")
                completion(nil)
            } else if let document = document, document.exists {
                if let data = document.data(), let designerIDs = data["uids"] as? [String] {
                    completion(designerIDs)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    // 클라이언트가 팔로우한 디자이너의 게시물만 불러오기
    func fetchPostsForFollowedDesigners(clientID: String) {
        getFollowedDesignerIDs(forClientID: clientID) { designerIDs in
            if let designerIDs = designerIDs, !designerIDs.isEmpty {
                // designerIDs 목록을 사용하여 Firestore에서 해당 디자이너의 게시물만 필터링
                let query = Firestore.firestore().collection("posts")
                    .whereField("designerID", in: designerIDs)
                
                query.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error fetching posts: \(error)")
                    } else if let snapshot = snapshot {
                        self.posts = snapshot.documents.compactMap { document in
                            try? document.data(as: Post.self)
                        }
                    }
                }
            } else {
                // designerIDs 목록이 비어있을 때의 처리 (팔로우한 디자이너가 없을 때)
                print("No followed designers found.")
            }
        }
    }
}
