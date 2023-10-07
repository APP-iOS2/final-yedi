//
//  AuthViewModel.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/06.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestore

enum UserType: String {
    case client, designer
}

final class UserAuth: ObservableObject {
    @Published var isClientLogin: Bool = false
    @Published var isDesignerLogin: Bool = false
    @Published var currentDesignerID: String? // 현재 로그인한 디자이너의 ID
    @Published var userType: UserType?
    @Published var userSession: FirebaseAuth.User?
    @Published var isEmailAvailable: Bool = true  // 이메일 중복 확인
    
    private var auth = Auth.auth()
    private var storeService = Firestore.firestore()
    
    func signIn(_ email: String, _ password: String, _ type: UserType, _ completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: signIn Error \(error.localizedDescription)")
                completion(false) // 로그인 실패 시 false 반환
                return
            }
            
            guard let user = result?.user else {
                completion(false)
                return
            }
            self.userSession = user
            self.userType = type
            
            /// user type에 따라서 각 고객, 디자이너 정보 가져오기
            guard let userTypeRawValue = self.userType?.rawValue else {
                return
            }
            let collectionName = userTypeRawValue + "s"
            
            self.storeService.collection(collectionName).whereField("email", isEqualTo: email).getDocuments { snapshot, error in
                if let error = error {
                    print("Firestore query error:", error.localizedDescription)
                    completion(false)
                    return
                }
                
                guard let documents = snapshot?.documents,
                      let userData = documents.first?.data() else {
                    print("User data not found")
                    completion(false)
                    return
                }
                
                switch self.userType {
                case .client:
                    if let name = userData["name"] as? String,
                       let email = userData["email"] as? String {
                        print("Name:", name)
                        print("Email:", email)
                        
                        self.isClientLogin = true
                        completion(true)
                    } else {
                        print("Invalid user data")
                        completion(false)
                    }
                case .designer:
                    if let userData = documents.first?.data() {
                        // 디자이너 정보 업데이트
                        if let name = userData["name"] as? String,
                           let email = userData["email"] as? String {
                            print("Name:", name)
                            print("Email:", email)
                            
                            self.isDesignerLogin = true
                            self.currentDesignerID = email
                            completion(true)
                        } else {
                            print("Invalid user data")
                            completion(false)
                        }
                    } else {
                        print("User data not found")
                        completion(false)
                    }
                    
                case .none:
                    return
                }
            }
        }
    }
    
    func registerClient(client: Client, password: String) {
        auth.createUser(withEmail: client.email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Error registering new user: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else { return }
            self.userSession = user

            print("DEBUG: Registered User successfully")

            let data: [String: Any] = [
                "name": client.name,
                "email": client.email,
                "phoneNumber": client.phoneNumber,
                "gender": client.gender,
                "birthDate": client.birthDate
            ]

            self.storeService.collection("clients")
                .document(user.uid)
                .setData(data, merge: true)
        }
    }
    
    func registerDesigner(designer: Designer, password: String) {
        auth.createUser(withEmail: designer.email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Error registering new user: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else { return }
            self.userSession = user

            print("DEBUG: Registered User successfully")

            let data: [String: Any] = [
                "name": designer.name,
                "email": designer.email,
                "phoneNumber": designer.phoneNumber,
                "description": designer.description ?? ""
            ]

            self.storeService.collection("clients")
                .document(user.uid)
                .setData(data, merge: true)
        }
    }
    
    /// firebase auth에서 제공하는 fetchSignInMethods를 가지고 auth 이메일 중복 체크하는 함수
    /// 10/07 : 동작 안 되는데 원인을 모르겠음...........
    func checkEmailAvailability(_ email: String, completion: @escaping (Bool, Error?) -> Void) {
        auth.fetchSignInMethods(forEmail: email) { signInMethods, error in
            if let error = error {
                let err = error as NSError
                
                switch err {
                case AuthErrorCode.emailAlreadyInUse:
                    completion(false, err)
                default:
                    print("unknown error: \(err.localizedDescription)")
                }
            } else {
                guard let signInMethods = signInMethods else {
                    return completion(false, nil)
                }
                completion(true, nil)
            }
        }
    }
    
    func signOut() {
        userSession = nil
        try? auth.signOut()
    }
}
