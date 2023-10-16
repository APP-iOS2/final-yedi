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
    
    // 초기 게시물 페이지를 가져오는 함수
    func fetchInitialPosts() async {
            let query = dbRef
                .order(by: "timestamp", descending: true)
                .limit(to: pageSize)  // 한 페이지에 표시할 게시물 수

            do {
                let snapshot = try await query.getDocuments()
                self.posts = snapshot.documents.compactMap { document in
                    try? document.data(as: Post.self)
                }
                
                self.lastDocument = snapshot.documents.last
                
                print("Fetched initial posts. Count:", self.posts.count)
                
            } catch {
                print("Error fetching initial posts: \(error)")
            }
        }
    
    // 다음 페이지의 게시물을 가져오는 함수
    func fetchNextPageOfPosts() async {
            guard let lastDocument = self.lastDocument else { return }

            let query = dbRef
                .order(by: "timestamp", descending: true)
                .start(afterDocument: lastDocument)
                .limit(to: pageSize)  // 한 페이지에 표시할 게시물 수

            do {
                let snapshot = try await query.getDocuments()
                
                if !snapshot.isEmpty {
                    self.posts.append(contentsOf:
                        snapshot.documents.compactMap { document in
                            try? document.data(as: Post.self)
                        }
                    )
                    
                    self.lastDocument = snapshot.documents.last
                    
                    print("Fetched next page of posts. Count:", snapshot.documents.count, "Total count:", self.posts.count)
                                    
                }
                
            } catch {
               print("Error fetching next page of posts: \(error)")
           }
       }
    
    // 클라이언트가 팔로우한 디자이너의 ID 목록을 가져오는 함수
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
    
    // 클라이언트가 팔로우한 디자이너의 게시물만 가져오는 함수
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
                        // 여기에서 필터링된 게시물을 사용하여 SwiftUI 뷰를 업데이트합니다.
                    }
                }
            } else {
                // designerIDs 목록이 비어있을 때의 처리 (팔로우한 디자이너가 없을 때)
                print("No followed designers found.")
                // 여기에서 필요한 예외 처리를 수행하거나 사용자에게 알릴 수 있습니다.
            }
        }
    }
}



