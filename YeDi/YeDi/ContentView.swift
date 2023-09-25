//
//  ContentView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/22.
//

import SwiftUI
import FirebaseAuth

class UserAuth: ObservableObject {
    @Published var isLogged = false
}

struct ContentView: View {
    //@EnvironmentObject var userAuth: UserAuth
    
    @State private var isClientLogin: Bool = false
    @State private var isDesignerLogin: Bool = false
    
    var body: some View {
        VStack{
            if isClientLogin {
                ClientMainTabView()
            } else if isDesignerLogin {
                DesignerMainTabView()
            } else {
                TempSelectionView(client: $isClientLogin, designer: $isDesignerLogin)
                    .environmentObject(UserAuth())
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
            HStack{
                Button(action: {
                    self.signIn("d1@gmail.com", "111111"){ success in
                        if success {
                            designer = true
                        }
                    }
                }, label: {
                    Text("디자이너1")
                })
                .frame(width: 100, height: 100)
                .background(Color(.gray))
                .tint(.white)
                .padding()
                
                Button(action: {
                    self.signIn("d2@gmail.com", "111111"){ success in
                        if success {
                            designer = true
                        }
                    }
                }, label: {
                    Text("디자이너2")
                })
                .frame(width: 100, height: 100)
                .background(Color(.gray))
                .tint(.white)
                .padding()
                
                Button(action: {
                    self.signIn("d3@gmail.com", "111111"){ success in
                        if success {
                            designer = true
                        }
                    }
                }, label: {
                    Text("디자이너3")
                })
                .frame(width: 100, height: 100)
                .background(Color(.gray))
                .tint(.white)
                .padding()
            }
        }
    }

    func signIn(_ email: String, _ password: String, completion: @escaping (Bool) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("DEBUG: signIn Error \(error.localizedDescription)")
                    completion(false) // 로그인 실패 시 false 반환
                    return
                }
                
                guard let user = result?.user else {
                    completion(false) // 사용자가 nil일 경우 false 반환
                    return
                }
                
                print("DEBUG: signIn User successfully")
                
                completion(true) // 로그인 성공 시 true 반환
            }
        }
    
}

#Preview {
    ContentView()
        .environmentObject(UserAuth())
}
