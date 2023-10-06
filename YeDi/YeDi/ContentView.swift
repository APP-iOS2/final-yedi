//
//  ContentView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum UserType: String {
    case client, designer
}

class UserAuth: ObservableObject {
    @Published var isLogged = false
    @Published var currentDesignerID: String? // 현재 로그인한 디자이너의 ID
    @Published var userType: UserType?
}

struct ContentView: View {
    @EnvironmentObject var userAuth: UserAuth
    @State private var isClientLogin: Bool = false
    @State private var isDesignerLogin: Bool = false
    
    var body: some View {
        VStack{
            if isClientLogin {
                ClientMainTabView()
                    .environmentObject(userAuth)
            } else if isDesignerLogin {
                DesignerMainTabView()
                    .environmentObject(userAuth)
            } else {
                TempSelectionView(client: $isClientLogin, designer: $isDesignerLogin)
                    .environmentObject(userAuth)
            }
        }
    }
}

struct TempSelectionView: View {
    @Binding var client: Bool
    @Binding var designer: Bool
    
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    self.signIn("c1@gmail.com", "111111"){ success in
                        if success {
                            client = true
                        }
                    }
                }, label: {
                    Text("고객1")
                })
                .frame(width: 100, height: 100)
                .background(Color(.gray))
                .tint(.white)
                .padding()
                
                Button(action: {
                    self.signIn("c2@gmail.com", "111111"){ success in
                        if success {
                            client = true
                        }
                    }
                }, label: {
                    Text("고객2")
                })
                .frame(width: 100, height: 100)
                .background(Color(.gray))
                .tint(.white)
                .padding()
                
                Button(action: {
                    self.signIn("c3@gmail.com", "111111"){ success in
                        if success {
                            client = true
                        }
                    }
                }, label: {
                    Text("고객3")
                })
                .frame(width: 100, height: 100)
                .background(Color(.gray))
                .tint(.white)
                .padding()
            }
            HStack {
                Button(action: {
                    self.signInDesigner("d1@gmail.com", "111111") { success in
                        if success {
                            designer = true
                        }
                    }
                }, label: {
                    Text("디자이너1")
                })
                .frame(width: 100, height: 100)
                .background(Color(.gray))
                .foregroundColor(.white)
                .padding()
                
                Button(action: {
                    self.signInDesigner("d2@gmail.com", "111111") { success in
                        if success {
                            designer = true
                        }
                    }
                }, label: {
                    Text("디자이너2")
                })
                .frame(width: 100, height: 100)
                .background(Color(.gray))
                .foregroundColor(.white)
                .padding()
                
                Button(action: {
                    self.signInDesigner("d3@gmail.com", "111111") { success in
                        if success {
                            designer = true
                        }
                    }
                }, label: {
                    Text("디자이너3")
                })
                .frame(width: 100, height: 100)
                .background(Color(.gray))
                .foregroundColor(.white)
                .padding()
            }
        }
    }

    
    func signIn(_ email: String, _ password: String, _ completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Sign in error:", error.localizedDescription)
                completion(false)
                return
            }
            
            guard let user = result?.user else {
                completion(false)
                return
            }
            
            // Firebase Authentication에 로그인 성공
            
            // Firestore에서 사용자 정보 가져오기
            let db = Firestore.firestore()
            
            db.collection("clients").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
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
                
                // 사용자 프로필 업데이트
                
                // 이름과 이메일 출력
                if let name = userData["name"] as? String,
                   let email = userData["email"] as? String {
                    print("Name:", name)
                    print("Email:", email)
                    
                    // 여기서 UserAuth 클래스의 isLogged 속성을 true로 설정
                    // 필요한 다른 사용자 정보도 업데이트 가능
                    
                    self.userAuth.isLogged = true
                    self.userAuth.userType = .client
                    completion(true)
                } else {
                    print("Invalid user data")
                    completion(false)
                }
                
                return
            }
        }
    }
    
    // 디자이너 로그인을 위한 함수
    func signInDesigner(_ email: String, _ password: String, _ completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Sign in error:", error.localizedDescription)
                completion(false)
                return
            }
            
            guard result?.user != nil else {
                completion(false)
                return
            }
            
            // Firestore에서 디자이너 정보 가져오기
            let db = Firestore.firestore()
            
            db.collection("designers").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
                if let error = error {
                    print("Firestore query error:", error.localizedDescription)
                    completion(false)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("User data not found")
                    completion(false)
                    return
                }
                
                if let userData = documents.first?.data() {
                    // 디자이너 정보 업데이트
                    if let name = userData["name"] as? String,
                       let email = userData["email"] as? String {
                        print("Name:", name)
                        print("Email:", email)
                        
                        self.userAuth.isLogged = true
                        self.userAuth.currentDesignerID = email // 디자이너 ID 설정
                        self.userAuth.userType = .designer
                        completion(true)
                    } else {
                        print("Invalid user data")
                        completion(false)
                    }
                } else {
                    print("User data not found")
                    completion(false)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserAuth())
}
