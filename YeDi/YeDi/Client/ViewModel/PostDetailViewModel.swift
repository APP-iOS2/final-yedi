//
//  PostDetailViewModel.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/09/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class PostDetailViewModel: ObservableObject {
    @Published var selectedImages: [String] = []
    @Published var selectedImageID: String = ""
    @Published var isFollowing: Bool = false
    
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
            await unfollowing(designerUid: designerUid, currentUserUid: uid)
            isFollowing = false
        } else {
            await following(designerUid: designerUid, currentUserUid: uid)
            isFollowing = true
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
}
