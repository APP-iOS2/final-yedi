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
                self.posts.append(contentsOf: snapshot.documents.compactMap { document in
                    try? document.data(as: Post.self)
                })
                
                self.lastDocument = snapshot.documents.last
                print("Fetched page. Total count:", self.posts.count)
            }
            
        } catch {
            print("Error fetching posts: \(error)")
        }
    }
    
    // 클라이언트가 팔로우한 디자이너의 ID 목록 불러오기
    func getFollowedDesignerIDs(forClientID clientID: String) async throws -> [String]? {
        let followingCollection = Firestore.firestore().collection("following")
        let clientDocument = followingCollection.document(clientID)
        
        do {
            let document = try await clientDocument.getDocument()
            if document.exists {
                if let data = document.data(), let designerIDs = data["uids"] as? [String] {
                    return designerIDs
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            print("Error getting following document: \(error)")
            throw error
        }
    }
    
    // 클라이언트가 팔로우한 디자이너의 게시물만 불러오기
    func fetchPostsForFollowedDesigners(clientID: String) async {
        do {
            let designerIDs = try await getFollowedDesignerIDs(forClientID: clientID)
            if let designerIDs = designerIDs, !designerIDs.isEmpty {
                // designerIDs 목록을 사용하여 Firestore에서 해당 디자이너의 게시물만 필터링
                let query = Firestore.firestore().collection("posts")
                    .whereField("designerID", in: designerIDs)
                
                do {
                    let snapshot = try await query.getDocuments()
                    self.posts = snapshot.documents.compactMap { document in
                        try? document.data(as: Post.self)
                    }
                } catch {
                    print("Error fetching posts: \(error)")
                }
            } else {
                // designerIDs 목록이 비어있을 때의 처리 (팔로우한 디자이너가 없을 때)
                print("No followed designers found.")
            }
        } catch {
            // handle error from getFollowedDesignerIDs
        }
    }
    
}
