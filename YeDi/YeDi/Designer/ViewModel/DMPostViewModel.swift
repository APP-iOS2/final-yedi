//
//  DMPostViewModel.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

/// 포스트 뷰 모델
class DMPostViewModel: ObservableObject {
    // MARK: - Properties
    @Published var posts: [Post] = []
    
    /// posts 컬렉션 참조 변수
    let collectionRef = Firestore.firestore().collection("posts")
    /// storage 참조 변수
    let storageRef = Storage.storage().reference()
    /// storage에 저장된 이미지 URL 배열
    var downloadURLs: [String] = []
    
    // MARK: - Methods
    /// 포스트 패치 함수
    func fetchPostsFromFirestore(userAuth: UserAuth) {
        guard let currentDesignerID = userAuth.currentDesignerID else {
            print("No designer is currently logged in.")
            return
        }
        
        collectionRef
          .whereField("designerID", isEqualTo: currentDesignerID) // 현재 디자이너 아이디로 필터링
          .order(by: "timestamp", descending: true)
          .addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            self?.posts = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Post.self)
            }
        }
    }
    
    /// Firestore에 게시물 저장하는 메서드
    func savePostToFirestore(post: Post, imageURLs: [String]) async {
        self.downloadURLs = []
        guard let postId = post.id else { return }
        
        for url in imageURLs {
            let temp = UUID().uuidString
            
            let localFile = URL(string: url)!
            
            let uploadTask = URLSession.shared.dataTask(with: localFile) { data, _, error in
                guard let data = data else { return }
                
                let localJpeg = UIImage(data: data)?.jpegData(compressionQuality: 0.7)
                if let localJpeg {
                    let uploadTask = self.storageRef.child("posts/\(temp)").putData( localJpeg)
                    uploadTask.observe(.success) { StorageTaskSnapshot in
                        if StorageTaskSnapshot.status == .success {
                            Task {
                                do {
                                    var capturedPost = post
                                    
                                    let downloadURL = try await self.storageRef.child("posts/\(temp)").downloadURL()
                                    self.downloadURLs.append(downloadURL.absoluteString)
                                    
                                    capturedPost.photos = self.downloadURLs.map { Photo(id: UUID().uuidString, imageURL: $0) }
                                    try self.collectionRef.document(postId).setData(from: capturedPost)
                                } catch {
                                    print("Error uploading designer post: \(error)")
                                }
                            }
                        }
                    }
                }
            }
            
            uploadTask.resume()
        }
    }
    
    /// 게시물 업데이트 메서드
    func updatePost(updatedPost: Post, imageURLs: [String]) async {
        self.downloadURLs = []
        
        guard let postId = updatedPost.id else { return }
        
        for url in imageURLs {
            let temp = UUID().uuidString
            
            let localFile = URL(string: url)!
            
            let uploadTask = URLSession.shared.dataTask(with: localFile) { data, _, error in
                guard let data = data else { return }
                
                let localJpeg = UIImage(data: data)?.jpegData(compressionQuality: 0.7)
                if let localJpeg {
                    let uploadTask = self.storageRef.child("posts/\(temp)").putData( localJpeg)
                    uploadTask.observe(.success) { StorageTaskSnapshot in
                        if StorageTaskSnapshot.status == .success {
                            Task {
                                do {
                                    var capturedPost = updatedPost
                                    
                                    let downloadURL = try await self.storageRef.child("posts/\(temp)").downloadURL()
                                    self.downloadURLs.append(downloadURL.absoluteString)
                                    
                                    capturedPost.photos = self.downloadURLs.map { Photo(id: UUID().uuidString, imageURL: $0) }
                                    try self.collectionRef.document(postId).setData(from: capturedPost)
                                } catch {
                                    print("Error uploading designer post: \(error)")
                                }
                            }
                        }
                    }
                }
            }
            
            uploadTask.resume()
        }
    }
    
    /// 게시글 삭제 메서드
    func deletePost(selectedPost: Post) {
        // 게시글 ID 확인
        guard let postId = selectedPost.id else { return }
        
        // Firestore에서 게시글 삭제
        collectionRef.document(postId).delete { error in
            if let error = error {
                print("Error removing post: \(error)")
            } else {
                print("Post successfully removed!")
            }
        }
    }
}
