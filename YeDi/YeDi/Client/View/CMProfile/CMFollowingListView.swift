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
    @StateObject var postDetailViewModel: PostDetailViewModel = PostDetailViewModel()
    @State private var isFollowing: Bool = true
    @State private var isLoaded: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            ScrollView {
                ForEach(profileViewModel.followedDesigner, id: \.id) { designer in
                    NavigationLink {
                        CMDesignerProfileView(designer: designer)
                    } label: {
                        followingListButtonView(designer: designer)
                    }
                    .onAppear {
                        Task {
                            isLoaded = false
                            await postDetailViewModel.isFollowed(designerUid: designer.designerUID)
                            isLoaded = true
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
    
    private func followingListButtonView(designer: Designer) -> some View {
        VStack {
            if isLoaded {
                HStack(alignment: .top) {
                    if let imageURLString = designer.imageURLString {
                        AsyncImage(url: URL(string: "\(imageURLString)")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 50, maxHeight: 50)
                                .clipShape(Circle())
                                .offset(y: -5)
                        } placeholder: {
                            Text(String(designer.name.first ?? " ").capitalized)
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(width: 50, height: 50)
                                .background(Circle().fill(Color.quaternarySystemFill))
                                .foregroundColor(Color.primaryLabel)
                                .offset(y: -5)
                        }
                    } else {
                        Text(String(designer.name.first ?? " ").capitalized)
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(width: 50, height: 50)
                            .background(Circle().fill(Color.quaternarySystemFill))
                            .foregroundColor(Color.primaryLabel)
                            .offset(y: -5)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(designer.name)")
                        Text("\(designer.shop?.shopName ?? "프리랜서")")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await postDetailViewModel.toggleFollow(designerUid: designer.designerUID)
                        }
                    } label: {
                        Text("\(postDetailViewModel.isFollowing ? "팔로잉" : "팔로우")")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(postDetailViewModel.isFollowing ? Color.primaryLabel : Color.whiteMainColor)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(postDetailViewModel.isFollowing ? Color.whiteMainColor : Color.primaryLabel)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                Capsule()
                                    .stroke(postDetailViewModel.isFollowing ? Color.secondarySystemFill : .clear, lineWidth: 1)
                            )
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    CMFollowingListView()
        .environmentObject(CMProfileViewModel())
}
