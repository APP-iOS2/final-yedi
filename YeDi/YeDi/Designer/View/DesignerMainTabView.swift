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
            DMReviewView()
                .tabItem {
                    Label("리뷰", systemImage: "star.fill")
                }.tag(0)
            
            DMGridView()
                .tabItem {
                    Label("게시물", systemImage: "photo.fill")
                }
                .tag(1)
            
            ReservationView()
                .tabItem {
                    Label("예약", systemImage: "calendar")
                }.tag(2)
            
            DMMainChattingView()
                .tabItem {
                    Label("채팅", systemImage: "message.fill")
                }.tag(3)
            
            DMProfileView()
                .tabItem {
                    Label("프로필", systemImage: "person.fill")
                }.tag(4)
        }
    }
}

#Preview {
    DesignerMainTabView()
}
