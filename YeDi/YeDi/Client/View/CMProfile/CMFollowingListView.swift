//
//  CMFollowingListView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

struct CMFollowingListView: View {
    @State private var isFollowingDesigner: Bool = true
    @StateObject var postDetailViewModel = PostDetailViewModel()
    let profileViewModel: CMProfileViewModel
    var body: some View {
        ScrollView {
            if profileViewModel.followedDesigner.isEmpty {
                Text("팔로잉한 디자이너가 없습니다.")
                    .padding()
            } else {
                ForEach(profileViewModel.followedDesigner, id: \.id) { designer in
                    followingList(designerUid: "\(designer.name)")
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                }
            }
        }
        .onAppear {
            Task {
                await profileViewModel.fetchFollowedDesigner()
            }
        }
    }
    
    private func followingList(designerUid: String) -> some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/04/27/09/21/cat-5098930_1280.jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 50, maxHeight: 50)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }

            VStack(alignment: .leading) {
                Text("Designer1")
                Text("서울")
            }
            
            Spacer()
            
            Button {
                Task {
                    await postDetailViewModel.toggleFollow(designerUid: designerUid)
                }
            } label: {
                Text("팔로우")
                    .font(.system(size: 14))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    CMFollowingListView(profileViewModel: CMProfileViewModel())
}
