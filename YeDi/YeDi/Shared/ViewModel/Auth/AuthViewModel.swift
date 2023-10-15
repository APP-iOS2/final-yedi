//
//  AuthViewModel.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/06.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum UserType: String {
    case client, designer
}

final class UserAuth: ObservableObject {
    @Published var currentClientID: String?
    @Published var currentDesignerID: String?
    @Published var userType: UserType?
    @Published var userSession: FirebaseAuth.User?
    
    private let auth = Auth.auth()
    private let storeService = Firestore.firestore()
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    init() {
        fetchUserTypeinUserDefaults()
        fetchUser()
    }
    
    func fetchUser() {
        auth.addStateDidChangeListener { auth, user in
            if let user = user {
                self.userSession = user
                self.userType = self.userType
                
                switch self.userType {
                case .client:
                    self.currentClientID = user.uid
                case .designer:
                    self.currentDesignerID = user.uid
                case nil:
                    return
                }
            } else {
                self.userSession = nil
            }
        }
    }
    
    func fetchUserTypeinUserDefaults() {
        if let type = userDefaults.value(forKey: "UserType") {
            let typeToString = String(describing: type)
            self.userType = UserType(rawValue: typeToString)
        }
    }
    
    func saveUserTypeinUserDefaults(_ type: String) {
        userDefaults.set(type, forKey: "UserType")
    }
    
    func removeUserTypeinUserDefaults() {
        userDefaults.removeObject(forKey: "UserType")
    }
    
    func signIn(_ email: String, _ password: String, _ type: UserType, _ completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: signIn Error \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let user = result?.user else {
                completion(false)
                return
            }
            
            /// user type에 따라서 각 고객, 디자이너 정보 가져오기
            let collectionName = type.rawValue + "s"
            
            self.storeService.collection(collectionName).whereField("email", isEqualTo: email).getDocuments { snapshot, error in
                if let error = error {
                    print("Firestore query error:", error.localizedDescription)
                    completion(false)
                }
                
                guard let documents = snapshot?.documents,
                      let userData = documents.first?.data() else {
                    print("User data not found")
                    completion(false)
                    return
                }
                
                if let name = userData["name"] as? String,
                   let email = userData["email"] as? String{
                    print("Name:", name)
                    print("Email:", email)
                    
                    switch type {
                    case .client:
                        self.currentClientID = user.uid
                    case .designer:
                        self.currentDesignerID = user.uid
                    }
                    
                    self.userSession = user
                    self.userType = type
                    self.saveUserTypeinUserDefaults(type.rawValue)
                    
                    completion(true)
                } else {
                    print("Invalid user data")
                    completion(false)
                }
            }
        }
    }
    
    func registerClient(client: Client, password: String, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: client.email, password: password) { result, error in
            if let error = error {
                completion(false)
                print("DEBUG: Error registering new user: \(error.localizedDescription)")
            } else {
                completion(true)
                
                guard let user = result?.user else { return }
                print("DEBUG: Registered User successfully")
                
                let data: [String: Any] = [
                    "id": user.uid,
                    "name": client.name,
                    "email": client.email,
                    "profileImageURLString": client.profileImageURLString,
                    "phoneNumber": client.phoneNumber,
                    "gender": client.gender,
                    "birthDate": client.birthDate,
                    "favoriteStyle": client.favoriteStyle,
                    "chatRooms": client.chatRooms
                ]
                
                self.storeService.collection("clients")
                    .document(user.uid)
                    .setData(data, merge: true)
            }
        }
    }
    
    func registerDesigner(designer: Designer, password: String, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: designer.email, password: password) { result, error in
            if let error = error {
                completion(false)
                print("DEBUG: Error registering new user: \(error.localizedDescription)")
            } else {
                completion(true)
                
                guard let user = result?.user else { return }
                print("DEBUG: Registered User successfully")
                
                let data: [String: Any] = [
                    "id": user.uid,
                    "name": designer.name,
                    "email": designer.email,
                    "imageURLString": designer.imageURLString ?? "",
                    "phoneNumber": designer.phoneNumber,
                    "description": designer.description ?? "",
                    "designerScore": designer.designerScore,
                    "reviewCount": designer.reviewCount,
                    "followerCount": designer.followerCount,
                    "skill": designer.skill,
                    "chatRooms": designer.chatRooms,
                    "birthDate": designer.birthDate,
                    "gender": designer.gender,
                    "rank": designer.rank.rawValue,
                    "designerUID": user.uid
                ]
                
                self.storeService.collection("designers")
                    .document(user.uid)
                    .setData(data, merge: true)
            }
        }
    }
    
    func signOut() {
        userSession = nil
        userType = nil
        currentClientID = nil
        currentDesignerID = nil
        
        removeUserTypeinUserDefaults()
        
        try? auth.signOut()
    }
    
    func deleteClientAccount() {
        if let currentClientID {
            storeService
                .collection("clients")
                .document(currentClientID).delete()
            
            userSession = nil
        }
    }
}
