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
    func updateClientProfile(userAuth: UserAuth, client: Client) async {
        if let clientId = userAuth.currentClientID {
            // MARK: - 프로필 이미지 바꾸는 경우
            if !client.profileImageURLString.isEmpty {
                let localFile = URL(string: client.profileImageURLString)!
                
                // 로컬에 임시로 저장된 이미지를 Jpeg으로 압축 > storage에 업로드하고 URL 다운받기
                let uploadTask = URLSession.shared.dataTask(with: localFile) { data, response, error in
                    guard let data = data else { return }
                    
                    let localJpeg = UIImage(data: data)?.jpegData(compressionQuality: 0.4)
                    if let localJpeg {
                        let uploadTask = self.storageRef.child("clients/profiles/\(clientId)").putData(localJpeg)
                        uploadTask.observe(.success) { StorageTaskSnapshot in
                            if StorageTaskSnapshot.status == .success {
                                Task {
                                    do {
                                        var capturedClient = client
                                        
                                        let downloadURL = try await self.storageRef.child("clients/profiles/\(clientId)").downloadURL()
                                        
                                        capturedClient.profileImageURLString = downloadURL.absoluteString
                                        try self.collectionRef.document(clientId).setData(from: capturedClient)
                                    } catch {
                                        print("Error updating client profile: \(error)")
                                    }
                                }
                            }
                        }
                    }
                }
                
                uploadTask.resume()
            } else {
                // MARK: - 프로필 이미지 바꾸지 않는 경우
                Task {
                    do {
                        try self.collectionRef.document(clientId).setData(from: client)
                    } catch {
                        print("Error updating client profile: \(error)")
                    }
                }
            }
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
