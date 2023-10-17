//
//  CMProfileViewModel.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/05.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

/// 고객 프로필 뷰 모델
final class CMProfileViewModel: ObservableObject {
    // MARK: - Properties
    @Published var client: Client = Client(id: "", name: "", email: "", profileImageURLString: "", phoneNumber: "", gender: "", birthDate: "", favoriteStyle: "", chatRooms: [])
    @Published var followedDesigner: [Designer] = []
    
    /// clients 컬렉션 참조 변수
    let collectionRef = Firestore.firestore().collection("clients")
    /// storage 참조 변수
    let storageRef = Storage.storage().reference()
    
    // MARK: - Methods
    /// 고객 프로필 패치 메서드
    @MainActor
    func fetchClientProfile(userAuth: UserAuth) async {
        do {
            if let clientId = userAuth.currentClientID {
                let docSnapshot = try await collectionRef.document(clientId).getDocument()
                
                self.client = try docSnapshot.data(as: Client.self)
            }
        } catch {
            print("Error fetching client profile: \(error)")
        }
    }
    
    /// 고객 프로필 업데이트 메서드
    @MainActor
    func updateClientProfile(userAuth: UserAuth, newClient: Client) async {
        do {
            if let clientId = userAuth.currentClientID {
                var newClient = newClient
                
                // 로컬에 임시로 저장된 이미지를 Jpeg으로 압축 > storage에 업로드하고 URL 다운받기
                if !newClient.profileImageURLString.isEmpty {
                    let localFile = URL(string: newClient.profileImageURLString)!
                    
                    let data = try await URLSession.shared.data(from: localFile).0
                    
                    let localJpeg = UIImage(data: data)?.jpegData(compressionQuality: 0.2)
                    if let localJpeg {
                        self.storageRef.child("clients/profiles/\(clientId)").putData(localJpeg)
                    }
                    
                    let downloadURL = try await storageRef.child("clients/profiles/\(clientId)").downloadURL()
                    newClient.profileImageURLString = downloadURL.absoluteString

                    self.client.profileImageURLString = downloadURL.absoluteString
                }
                
                try collectionRef.document(clientId).setData(from: newClient)
                
                try await Task.sleep(for: .seconds(0.5))
            }
        } catch {
            print("Error updating client profile: \(error)")
        }
    }
    
    /// 팔로우하는 디자이너 리스트 패치 메서드
    @MainActor
    func fetchFollowedDesigner() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let followingDocument = try? await Firestore.firestore().collection("following").document(uid).getDocument(),
              let followingData = followingDocument.data(),
              let uids = followingData["uids"] as? [String], !uids.isEmpty else {
            
            self.followedDesigner = []
            return
        }
         
        do {
            let designerQuerySnapshot = try await Firestore.firestore()
                .collection("designers")
                .whereField("designerUID", in: uids)
                .getDocuments()
            
            self.followedDesigner = designerQuerySnapshot.documents.compactMap { document in
                try? document.data(as: Designer.self)
            }
            
            print(followedDesigner)
        } catch {
            print("Fetch Followed Designer Error: \(error)")
        }
    }
}
