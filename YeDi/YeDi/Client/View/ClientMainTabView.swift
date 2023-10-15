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
    @StateObject var chattingListViewModel = ChattingListRoomViewModel()
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
                    Label("예약", systemImage: "chart.bar.doc.horizontal.fill")
                }.tag(2)
                
                CMMainChattingView()
                    .environmentObject(chattingListViewModel)
                .tabItem {
                    Label("채팅", systemImage: "bubble.left.fill")
                        
                }.tag(3).badge(chattingListViewModel.getUnReadTotalCount())
                
                CMProfileView()
                .tabItem {
                    Label("프로필", systemImage: "person.fill")
                }.tag(4)
            }
        }
        .onAppear {
            chattingListViewModel.fetchChattingList(login: userAuth.userType)
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
