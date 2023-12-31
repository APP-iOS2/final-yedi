//
//  ClientMainTabView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct ClientMainTabView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var profileViewModel: CMProfileViewModel
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    @EnvironmentObject var chattingListRoomViewModel : ChattingListRoomViewModel
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedIndex) {
                CMHomeView()
                    .tabItem {
                        Label("홈", systemImage: "house")
                    }.tag(0)
                
                CMSearchView()
                    .tabItem {
                        Label("검색", systemImage: "magnifyingglass")
                    }.tag(1)
                
                CMReservationHistoryView()
                    .tabItem {
                        Label("예약내역", systemImage: "calendar")
                    }.tag(2)
                
                CMMainChattingView()
                    .environmentObject(chattingListRoomViewModel)
                    .tabItem {
                        Label("채팅", systemImage: "bubble.left.fill")
                        
                    }.tag(3).badge(chattingListRoomViewModel.getUnReadTotalCount)
                
                CMProfileView()
                    .tabItem {
                        Label("프로필", systemImage: "person.fill")
                    }.tag(4)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    YdIconView(height: 32)
                }
            
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CMSettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Color.primaryLabel)
                    }
                }
            }
        }
        .onAppear {
            chattingListRoomViewModel.fetchChattingList(login: userAuth.userType)
        }
    }
}

#Preview {
    ClientMainTabView()
        .environmentObject(UserAuth())
        .environmentObject(CMProfileViewModel())
        .environmentObject(CMReviewViewModel())
        .environmentObject(ChattingListRoomViewModel())
}
