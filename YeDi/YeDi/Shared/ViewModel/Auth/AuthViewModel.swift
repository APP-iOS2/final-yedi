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
    @Published var isLogin: Bool = false
    
    private let auth = Auth.auth()
    private let storeService = Firestore.firestore()
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    init() {
        fetchUserTypeinUserDefaults()
        fetchUser()
    }
    
    func fetchUser() {
        auth.addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.checkIfUserExistsInFirestore(user: user) { exists in
                    if exists {
                        // 사용자 데이터가 서버에 존재하면 사용자 정보 저장
                        self?.userSession = user
                        self?.userType = self?.userType
                        self?.isLogin = true
                        
                        switch self?.userType {
                        case .client:
                            self?.currentClientID = user.uid
                        case .designer:
                            self?.currentDesignerID = user.uid
                        case nil:
                            return
                        }
                    } else {
                        self?.signOut()
                    }
                }
            } else {
                self?.isLogin = false
                self?.userSession = nil
                self?.currentClientID = nil
                self?.currentDesignerID = nil
            }
        }
    }
    
    func checkIfUserExistsInFirestore(user: User, completion: @escaping (Bool) -> Void) {
        let clientCollection = storeService.collection("clients")
        let designerCollection = storeService.collection("designers")
        
        // clients collection에서 사용자 데이터를 확인할 함수
        func checkClientCollection(completion: @escaping (Bool) -> Void) {
            clientCollection.document(user.uid).getDocument { document, error in
                if let document = document, document.exists {
                    // 사용자 데이터가 clients collection에 존재
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        
        // designers collection에서 사용자 데이터를 확인할 함수
        func checkDesignerCollection(completion: @escaping (Bool) -> Void) {
            designerCollection.document(user.uid).getDocument { document, error in
                if let document = document, document.exists {
                    // 사용자 데이터가 designers collection에 존재
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        
        // 두 컬렉션에서 사용자 데이터 확인
        checkClientCollection { existsInClientCollection in
            checkDesignerCollection { existsInDesignerCollection in
                // 두 컬렉션 모두 사용자 데이터가 존재하면 completion(true) 호출
                if existsInClientCollection && existsInDesignerCollection {
                    completion(true)
                } else {
                    completion(false)
                }
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
                    self.isLogin = true
                    
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
                
                self.userSession = nil
                self.isLogin = false
            }
        }
    }
    
    func registerDesigner(designer: Designer, shop: Shop, password: String, completion: @escaping (Bool) -> Void) {
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
                    "designerUID": user.uid,
                    //MARK: shop information
                    "shopName" : shop.shopName,
                    "headAddress" : shop.headAddress,
                    "subAddress" : shop.subAddress,
                    "detailAddress" : shop.detailAddress,
                    // "telNumber" : "",
                    // "longitude" : "",
                    // "latitude" : "",
                    "openingHour" : shop.openingHour,
                    "closingHour" : shop.closingHour,
                    // "messangerLinkURL" : ["": ""],
                    "closedDays" : shop.closedDays
                ]
                
                self.storeService.collection("designers")
                    .document(user.uid)
                    .setData(data, merge: true)
                
                self.userSession = nil
                self.isLogin = false
            }
        }
    }
    
    func resetPassword(forEmail email: String, completion: @escaping (Bool) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func updatePassword(_ email: String, _ currentPassword: String, _ newPassword: String, _ completion: @escaping (Bool) -> Void) {
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        auth.currentUser?.reauthenticate(with: credential) { result, error in
            if let error = error {
                print("reauthenticate error: \(error.localizedDescription)")
                completion(false)
            } else {
                self.auth.currentUser?.updatePassword(to: newPassword) { error in
                    if let error = error {
                        print("update error: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
    
    func signOut() {
        resetUserInfo()
        try? auth.signOut()
    }
    
    func deleteClientAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        if let currentClientID {
            storeService
                .collection("clients")
                .document(currentClientID).delete()
        }
        
        if let currentDesignerID {
            storeService
                .collection("designers")
                .document(currentDesignerID).delete()
        }
        
        user.delete { error in
            if let error = error {
                print("DEBUG: Error deleting user account: \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: User account deleted")
            
            self.signOut()
        }
    }
    
    func resetUserInfo() {
        userSession = nil
        userType = nil
        currentClientID = nil
        currentDesignerID = nil
        isLogin = false
        
        removeUserTypeinUserDefaults()
    }
}
