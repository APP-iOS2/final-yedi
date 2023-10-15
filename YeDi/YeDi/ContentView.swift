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
    
    var body: some View {
        if userAuth.userSession != nil {
            switch userAuth.userType {
            case .client:
                ClientMainTabView()
                    .environmentObject(profileViewModel)
                    .environmentObject(reviewViewModel)
            case .designer:
                DesignerMainTabView()
            case .none:
                EmptyView()
            }
        } else {
            AuthHomeView()
        }
        
//        let _ = print(
//            """
//            ================================================================
//            user type: \(String(describing: userAuth.userType))
//            user session: \(String(describing: userAuth.userSession?.uid))
//            client id: \(String(describing: userAuth.currentClientID))
//            designer id: \(String(describing: userAuth.currentDesignerID))
//            """
//        )
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
