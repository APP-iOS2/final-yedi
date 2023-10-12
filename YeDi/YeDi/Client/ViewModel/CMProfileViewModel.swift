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

final class CMProfileViewModel: ObservableObject {
    @Published var client: Client = Client(
        id: "",
        name: "",
        email: "",
        profileImageURLString: "",
        phoneNumber: "",
        gender: "",
        birthDate: "",
        favoriteStyle: "",
        chatRooms: []
    )
    
    @Published var followedDesigner: [Designer] = []
    
    let collectionRef = Firestore.firestore().collection("clients")
    let storageRef = Storage.storage().reference()
    
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
    
    @MainActor
    func updateClientProfile(userAuth: UserAuth, client: Client) async {
        do {
            if let clientId = userAuth.currentClientID {
                var newClient = client
                
                if client.profileImageURLString != "" {
                    let localFile = URL(string: client.profileImageURLString)!
                    
                    storageRef.child("clients/\(clientId)").putFile(from: localFile)
                    
                    let downloadURL = try await storageRef.child("clients/\(clientId)").downloadURL()
                    
                    newClient.profileImageURLString = downloadURL.absoluteString
                }
                
                try collectionRef.document(clientId).setData(from: newClient)
                self.client = newClient
            }
        } catch {
            print("Error updating client profile: \(error)")
        }
    }
    
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
        } catch {
            print("Fetch Followed Designer Error: \(error)")
        }
    }
}
