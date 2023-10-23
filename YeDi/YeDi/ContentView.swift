//
//  ContentView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var cmProfileViewModel: CMProfileViewModel
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    @EnvironmentObject var dmPostViewModel: DMPostViewModel
    @EnvironmentObject var chattingListRoomViewModel: ChattingListRoomViewModel
    
    var body: some View {
        if userAuth.isLogin {
            if userAuth.userSession != nil {
                switch userAuth.userType {
                case .client:
                    ClientMainTabView()
                        .environmentObject(locationManager)
                        .environmentObject(cmProfileViewModel)
                        .environmentObject(reviewViewModel)
                case .designer:
                    DesignerMainTabView()
                        .environmentObject(locationManager)
                        .environmentObject(dmPostViewModel)
                case .none:
                    EmptyView()
                }
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

#Preview {
    ContentView()
        .environmentObject(UserAuth())
        .environmentObject(LocationManager())
        .environmentObject(ChattingListRoomViewModel())
}
