//
//  DesignerMainTabView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct DesignerMainTabView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            NavigationStack {
                DMReviewView()
            }
            .onTapGesture {
                self.selectedIndex = 0
            }
            .tabItem {
                Label("리뷰", systemImage: "")
            }.tag(0)
            
            NavigationStack {
                DMPostView()
            }
            .onTapGesture {
                self.selectedIndex = 1
            }
            .tabItem {
                Label("게시물", systemImage: "")
            }.tag(1)
            
            NavigationStack {
                DMReservationView()
            }
            .onTapGesture {
                self.selectedIndex = 2
            }
            .tabItem {
                Label("예약", systemImage: "")
            }.tag(2)
            
            NavigationStack {
                DMMainChattingView()
            }
            .onTapGesture {
                self.selectedIndex = 3
            }
            .tabItem {
                Label("채팅", systemImage: "")
            }.tag(3)
            
            NavigationStack {
                DMProfileView()
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
    DesignerMainTabView()
}
