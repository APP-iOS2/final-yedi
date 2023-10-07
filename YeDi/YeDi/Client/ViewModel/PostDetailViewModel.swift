//
//  PostDetailViewModel.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/09/26.
//

import Foundation
import FirebaseFirestore

final class PostDetailViewModel: ObservableObject {
    @Published var selectedImages: [String] = []
    @Published var selectedImageID: String = ""
    @Published var isFollowing: Bool = false
    
    private let db = Firestore.firestore()
    
    /// Client의 팔로잉 목록에 특정한 Designer가 포함되어 있는지 여부를 나타내는 Bool 값 반환
    /// - Parameter designerUid: Client 팔로잉 목록에서 찾을 DesignerUid
    /// - Returns: 팔로잉 목록에 Designer가 포함되어 있을 경우 `true`,  아닐경우 `false`
    @MainActor
    func isFollowed(designerUid: String) async {
        // TODO: UserDefautls 대신 다른 인증 방법 사용
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        
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
        if isFollowing {
            await unfollowing(designerUid: designerUid)
            isFollowing = false
        } else {
            await following(designerUid: designerUid)
            isFollowing = true
        }
    }
    
    private func following(designerUid: String) async {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        
        do {
            let documentSnapshot = try await db.collection("following").document(uid).getDocument()
            if documentSnapshot.exists {
                try await db.collection("following").document(uid).updateData([
                    "uids": FieldValue.arrayUnion([designerUid])
                ])
            } else {
                try await db.collection("following").document(uid).setData([
                    "uids": [designerUid]
                ])
            }
        } catch {
            print("Error following: \(error)")
        }
    }
    
    private func unfollowing(designerUid: String) async {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        
        do {
            try await db.collection("following").document(uid).updateData([
                "uids": FieldValue.arrayRemove([designerUid])
            ])
        } catch {
            print("Error unfollowing: \(error)")
        }
    }
}
