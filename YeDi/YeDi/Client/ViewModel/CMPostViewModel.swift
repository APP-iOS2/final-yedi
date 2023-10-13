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
}



