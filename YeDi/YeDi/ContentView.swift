//
//  ContentView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Firebase

struct ContentView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var profileViewModel: CMProfileViewModel
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    @State private var isClientLogin: Bool = false
    @State private var isDesignerLogin: Bool = false
    
    var body: some View {
        VStack{
            if userAuth.isClientLogin {
                ClientMainTabView()
                    .environmentObject(userAuth)
                    .environmentObject(profileViewModel)
                    .environmentObject(reviewViewModel)
            } else if userAuth.isDesignerLogin {

                DesignerMainTabView()
                    .environmentObject(userAuth)
            } else {
                AuthHomeView()
            }
        }
    }
}

/*
 c1@gmail.com / 111111
 c2@gmail.com / 111111
 c3@gmail.com / 111111
 d1@gmail.com / 111111
 d2@gmail.com / 111111
 d3@gmail.com / 111111
 */

#Preview {
    ContentView()
        .environmentObject(UserAuth())
}
