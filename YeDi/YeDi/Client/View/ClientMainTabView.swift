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
    
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedIndex) {
                CMHomeView()
//                .onTapGesture {
//                    self.selectedIndex = 0
//                }
                .tabItem {
                    Label("홈", systemImage: "house")
                }.tag(0)
                
                CMSearchView()
//                .onTapGesture {
//                    self.selectedIndex = 1
//                }
                .tabItem {
                    Label("검색", systemImage: "magnifyingglass")
                }.tag(1)
                
                CMReservationHistoryView()
//                .onTapGesture {
//                    self.selectedIndex = 2
//                }
                .tabItem {
                    Label("예약", systemImage: "chart.bar.doc.horizontal.fill")
                }.tag(2)
                
                CMMainChattingView()
//                .onTapGesture {
//                    self.selectedIndex = 3
//                }
                .tabItem {
                    Label("채팅", systemImage: "bubble.left.fill")
                }.tag(3)
                
                CMProfileView()
//                .onTapGesture {
//                    self.selectedIndex = 4
//                }
                .tabItem {
                    Label("프로필", systemImage: "person.fill")
                }.tag(4)
            }
        }
    }
}

#Preview {
    ClientMainTabView()
        .environmentObject(UserAuth())
        .environmentObject(CMProfileViewModel())
        .environmentObject(CMReviewViewModel())
}
