//
//  DesignerMainTabView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct DesignerMainTabView: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var chattingListRoomViewModel: ChattingListRoomViewModel
    
    @State private var selectedIndex = 0
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedIndex) {
            DMReviewView()
                .tabItem {
                    Label("내 리뷰", systemImage: "star.fill")
                }.tag(0)
            
            DMGridView()
                .tabItem {
                    Label("내 게시물", systemImage: "photo.fill")
                }
                .tag(1)
            
            ReservationView()
                .tabItem {
                    Label("예약현황", systemImage: "calendar")
                }.tag(2)
            
            DMMainChattingView()
                .tabItem {
                    Label("채팅", systemImage: "message.fill")
                }.tag(3).badge(chattingListRoomViewModel.getUnReadTotalCount)
            
            DMProfileView()
                .tabItem {
                    Label("프로필", systemImage: "person.fill")
                }.tag(4)
        }
        .onAppear {
            chattingListRoomViewModel.fetchChattingList(login: userAuth.userType)
            locationManager.requestLocationPermission()
        }
    }
}

#Preview {
    DesignerMainTabView()
        .environmentObject(UserAuth())
        .environmentObject(ChattingViewModel())
}
