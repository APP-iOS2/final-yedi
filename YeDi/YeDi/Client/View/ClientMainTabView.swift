//
//  ClientMainTabView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct ClientMainTabView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            NavigationStack {
                CMHomeView()
            }
            .onTapGesture {
                self.selectedIndex = 0
            }
            .tabItem {
                Label("홈", systemImage: "house")
            }.tag(0)
            
            NavigationStack {
                CMFilterView()
            }
            .onTapGesture {
                self.selectedIndex = 1
            }
            .tabItem {
                Label("필터", systemImage: "")
            }.tag(1)
            
            NavigationStack {
                CMReservationView()
            }
            .onTapGesture {
                self.selectedIndex = 2
            }
            .tabItem {
                Label("예약", systemImage: "")
            }.tag(2)
            
            NavigationStack {
                CMMainChattingView()
            }
            .onTapGesture {
                self.selectedIndex = 3
            }
            .tabItem {
                Label("채팅", systemImage: "")
            }.tag(3)
            
            NavigationStack {
                CMProfileView()
            }
            .onTapGesture {
                self.selectedIndex = 4
            }
            .tabItem {
                Label("프로필", systemImage: "")
            }.tag(4)
            
        }
    }
}

#Preview {
    ClientMainTabView()
}
