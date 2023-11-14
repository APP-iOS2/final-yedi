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
    @EnvironmentObject var cmHistoryViewModel: CMHistoryViewModel
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    @EnvironmentObject var dmPostViewModel: DMPostViewModel
    @EnvironmentObject var chattingListRoomViewModel: ChattingListRoomViewModel
    
    var body: some View {
        if userAuth.isClientLogin {
            if userAuth.clientSession != nil {
                ClientMainTabView()
                    .environmentObject(locationManager)
                    .environmentObject(cmProfileViewModel)
                    .environmentObject(cmHistoryViewModel)
                    .environmentObject(reviewViewModel)
            }
        } else if userAuth.isDesignerLogin {
            if userAuth.designerSession != nil {
                DesignerMainTabView()
                    .environmentObject(locationManager)
                    .environmentObject(dmPostViewModel)
            }
        } else {
            AuthHomeView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserAuth())
        .environmentObject(LocationManager())
        .environmentObject(ChattingListRoomViewModel())
}
