//
//  CMProfileViewModel.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/05.
//

import SwiftUI
import FirebaseFirestore

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
    func updateClientProfile(userAuth: UserAuth, newClient: Client) async {
        do {
            if let clientId = userAuth.currentClientID {
                try collectionRef.document(clientId).setData(from: newClient)
                
                self.client = newClient
            }
        } catch {
            print("Error updating client profile: \(error)")
        }
    }
    
    func fetchFollowedDesigner() async {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        do {
            let documentSnapshot = try await Firestore.firestore().collection("following").document(uid).getDocument()
            guard let followingData = documentSnapshot.data(), let uids = followingData["uids"] as? [String] else { return }
            let querySnapshot = try await Firestore.firestore()
                .collection("designers")
                .whereField("designerUID", in: uids)
                .getDocuments()
            
            for document in querySnapshot.documents {
                self.followedDesigner = try document.data(as: [Designer].self)
            }
        } catch {
            print("Fetch Followed Designer Error: \(error)")
        }
    }
}
