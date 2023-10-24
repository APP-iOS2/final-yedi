//
//  CMDesignerProfileViewModel.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/21/23.
//

import Foundation
import Firebase
import FirebaseFirestore

@MainActor
class CMDesignerProfileViewModel: ObservableObject {
    @Published var designerPosts: [Post] = []
    @Published var reviews: [Review] = []
    @Published var keywords: [String] = []
    @Published var keywordCount: [(String, Int)] = []
    @Published var isFollowing: Bool = false
    @Published var previousFollowerCount: Int = 0
    
    private let db = Firestore.firestore()
    private var currentUserUid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    /// Client의 팔로잉 목록에 특정한 Designer가 포함되어 있는지 여부를 Bool값으로 `isFollowing`에 반영
    /// - Parameter designerUid: Client 팔로잉 목록에서 찾을 DesignerUid
    @MainActor
    func isFollowed(designerUid: String) async {
        guard let uid = currentUserUid else { return }
        
        do {
            let document = try await db.collection("following").document(uid).getDocument()
            guard let followingUids = document.data()?["uids"] as? [String] else { return }
            
            self.isFollowing = followingUids.contains(designerUid)
        } catch {
            print("Error getting document: \(error)")
        }
    }
    
    @MainActor
    func toggleFollow(designerUid: String) async {
        guard let uid = currentUserUid else { return }
        
        if isFollowing {
            isFollowing = false
            await unfollowing(designerUid: designerUid, currentUserUid: uid)
        } else {
            isFollowing = true
            await following(designerUid: designerUid, currentUserUid: uid)
        }
    }
    
    private func following(designerUid: String, currentUserUid: String) async {
        do {
            let documentSnapshot = try await db.collection("following").document(currentUserUid).getDocument()
            if documentSnapshot.exists {
                try await db.collection("following").document(currentUserUid).updateData([
                    "uids": FieldValue.arrayUnion([designerUid])
                ])
            } else {
                try await db.collection("following").document(currentUserUid).setData([
                    "uids": [designerUid]
                ])
            }
        } catch {
            print("Error following: \(error)")
        }
    }
    
    private func unfollowing(designerUid: String, currentUserUid: String) async {
        do {
            try await db.collection("following").document(currentUserUid).updateData([
                "uids": FieldValue.arrayRemove([designerUid])
            ])
        } catch {
            print("Error unfollowing: \(error)")
        }
    }
    
    func updateFollowerCountForDesigner(designerUID: String, followerCount: Int) async {
        print("Received designerUID: \(designerUID)")
        guard !designerUID.isEmpty else {
            print("UID가 유효하지 않습니다.")
            return
        }
        
        let followingCollection = Firestore.firestore().collection("following")
        let designerRef = Firestore.firestore().collection("designers").document(designerUID)
        
        do {
            let followingDocuments = try await followingCollection.whereField("uids", arrayContains: designerUID).getDocuments()
            
            let validDocuments = followingDocuments.documents
            if !validDocuments.isEmpty {
                let followerCountFromFirebase = validDocuments.count
                
                if followerCountFromFirebase != self.previousFollowerCount {
                    try await designerRef.updateData(["followerCount": followerCountFromFirebase])
                    _ = followerCountFromFirebase
                    self.previousFollowerCount = followerCountFromFirebase
                    print("팔로워 수가 \(followerCountFromFirebase)으로 업데이트되었습니다.")
                    
                } else {
                    print("팔로워 수가 변경되지 않았습니다.")
                }
            } else {
                print("팔로우한 디자이너를 찾지 못했습니다.")
            }
        } catch let error {
            print("Error updating follower count: \(error.localizedDescription)")
        }
    }
    
    // Firestore에서 디자이너의 게시물 데이터를 가져오는 함수
    func fetchDesignerPosts(designerUID: String) {
        db.collection("posts")
            .whereField("designerID", isEqualTo: designerUID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching designer posts: \(error.localizedDescription)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    self.designerPosts = documents.compactMap { document in
                        do {
                            let post = try document.data(as: Post.self)
                            return post
                        } catch {
                            print("Error decoding post: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
            }
    }
    
    func formattedFollowerCount(followerCount: Int) -> String {
        if followerCount < 10_000 {
            return "\(followerCount)"
        } else if followerCount < 1_000_000 {
            let followers = Double(followerCount) / 10_000.0
            if followers.truncatingRemainder(dividingBy: 1) == 0 {
                return "\(Int(followers))만"
            } else {
                return "\(followers)만"
            }
        } else {
            let millions = followerCount / 10_000
            return "\(millions)만"
        }
    }
    
    // 리뷰 정보 불러오기
    func fetchReview(designerUID: String) {
        db.collection("reviews")
            .whereField("designer", isEqualTo: designerUID) // designerUID 필드를 사용하여 해당 디자이너의 리뷰만 가져오도록 수정
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }
                self.reviews = documents.compactMap{ document in
                    try? document.data(as: Review.self)
                }
            }
    }
    
    
    func fetchKeywords(designerUID: String) {
        let db = Firestore.firestore()
        
        db.collection("reviews")
            .whereField("designer", isEqualTo: designerUID) // designerUID 필드를 사용하여 해당 디자이너의 리뷰만 가져오도록 수정
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("데이터를 가져오는 중 오류 발생: \(error)")
                    return
                }
                
                if let querySnapshot = querySnapshot {
                    var keywords: [String] = []
                    var keywordCountDict: [String: Int] = [:]
                    
                    for document in querySnapshot.documents {
                        if let keywordReviews = document.data()["keywordReviews"] as? [[String: Any]] {
                            for keywordReview in keywordReviews {
                                if let keyword = keywordReview["keyword"] as? String {
                                    keywords.append(keyword)
                                    keywordCountDict[keyword, default: 0] += 1
                                }
                            }
                        }
                    }
                    
                    // 키워드 데이터 업데이트
                    DispatchQueue.main.async {
                        self.keywords = keywords
                        self.keywordCount = keywordCountDict.map { ($0.key, $0.value) }
                    }
                }
            }
    }
    
    
}
