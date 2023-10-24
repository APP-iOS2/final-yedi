//
//  CMFollowingListView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

struct CMFollowingListView: View {
    // MARK: - Properties
    @EnvironmentObject var profileViewModel: CMProfileViewModel
    @State private var isFollowing: Bool = true
    
    // MARK: - Body
    var body: some View {
        VStack {
            if profileViewModel.followedDesigner.isEmpty {
                Text("팔로잉한 디자이너가 없습니다.")
                    .padding()
            } else {
                ScrollView {
                    ForEach(profileViewModel.followedDesigner, id: \.id) { designer in
                        NavigationLink {
                            CMDesignerProfileView(designer: designer)
                        } label: {
                            CMFollowingListButtonView(designer: designer)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await profileViewModel.fetchFollowedDesignerWithShopInfo()
            }
        }
    }
}

#Preview {
    CMFollowingListView()
        .environmentObject(CMProfileViewModel())
}
