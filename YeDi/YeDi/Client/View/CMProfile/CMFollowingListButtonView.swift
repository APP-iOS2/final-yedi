//
//  CMFollowingListButtonVIew.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/10/24.
//

import SwiftUI

struct CMFollowingListButtonView: View {
    @StateObject var postDetailViewModel: PostDetailViewModel = PostDetailViewModel()
    @State private var isLoaded = false
    let designer: Designer
    
    var body: some View {
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
        } else {
            ProgressView()
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
    
#Preview {
    CMFollowingListButtonView(designer: Designer(name: "", email: "", phoneNumber: "", designerScore: 0, reviewCount: 0, followerCount: 0, skill: [], chatRooms: [], birthDate: "", gender: "", rank: .Owner, designerUID: ""))
}
