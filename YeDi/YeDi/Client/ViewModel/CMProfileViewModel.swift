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
}
