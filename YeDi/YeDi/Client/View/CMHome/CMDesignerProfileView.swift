//
//  CMDesignerProfileView.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/13/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CMDesignerProfileView: View {
    
    var designer: Designer
    @State private var designerPosts: [Post] = []
    @StateObject var viewModel = PostDetailViewModel()
    
    let db = Firestore.firestore()
    
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 3) - 1
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    if let imageURLString = designer.imageURLString {
                        AsyncImage(url: URL(string: "\(imageURLString)")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 100, maxHeight: 100)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 100, maxHeight: 100)
                                .clipShape(Circle())
                                .foregroundStyle(Color.primaryLabel)
                        }
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 100, maxHeight: 100)
                            .clipShape(Circle())
                            .foregroundStyle(Color.primaryLabel)
                        
                    }
                    Text(designer.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top,10)
                    Text(designer.description ?? "")
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.callout)
                        .fontWeight(.light)
                        .padding(.horizontal)
                    Text("팔로워 \(formattedFollowerCount()) · 게시물 \(designerPosts.count)")
                        .fontWeight(.medium)
                        .padding(.vertical,10)
                    Button {
                        Task {
                            await viewModel.toggleFollow(designerUid: designer.designerUID)
                        }
                    } label: {
                        Text("\(viewModel.isFollowing ? "팔로잉" : "팔로우")")
                            .foregroundStyle(viewModel.isFollowing ? Color.primaryLabel :  .white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 7)
                            .background {
                                Capsule(style: .continuous)
                                    .fill(viewModel.isFollowing ? .gray : Color.subColor)
                            }
                    }
                }
                .padding(.top)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("근무지 이름")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primaryLabel)
                        Text("근무지 주소")
                            .foregroundStyle(.gray)
                        Divider()
                        Text("휴무일")
                            .foregroundStyle(.gray)
                    }
                    .padding()
                }
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.quaternarySystemFill)
                }
                .padding()
                
                if designerPosts.isEmpty {
                    VStack {
                        HStack {
                            Text("이 디자이너의 게시물")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primaryLabel)
                            Spacer()
                        }
                        Divider()
                        Text("업로드된 게시물이 없습니다.")
                            .foregroundStyle(Color.primaryLabel)
                            .padding()
                    }
                    .padding(.horizontal)
                } else {
                    VStack {
                        HStack {
                            Text("이 디자이너의 게시물")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primaryLabel)
                            Spacer()
                            NavigationLink(destination: CMStyleDetailView(designer: designer)) {
                                Text("스타일 전체보기")
                                    .foregroundStyle(Color.primaryLabel)
                            }
                        }
                        .padding(.horizontal)
                        Divider()
                        LazyVGrid(columns: gridItems, spacing: 1) {
                            ForEach(designerPosts.prefix(6), id: \.id) { post in
                                DMAsyncImage(url: post.photos[0].imageURL, placeholder: Image(systemName: "photo"))
                                    .scaledToFill()
                                    .frame(width: imageDimension, height: imageDimension)
                                    .clipped()
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton(color: nil, action: {})
            }
        }
        .task {
            await viewModel.isFollowed(designerUid: designer.designerUID)
            await fetchDesignerPosts()
        }
        
        Spacer()
    }
    
    // Firestore에서 디자이너의 게시물 데이터를 가져오는 함수
    func fetchDesignerPosts() async {
        db.collection("posts")
            .whereField("designerID", isEqualTo: designer.designerUID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching designer posts: \(error.localizedDescription)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    designerPosts = documents.compactMap { document in
                        do {
                            let post = try document.data(as: Post.self)
                            return post
                        } catch {
                            print("Error decoding post: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
            }
    }
    
    func formattedFollowerCount() -> String {
        if designer.followerCount < 10_000 {
            return "\(designer.followerCount)"
        } else if designer.followerCount < 1_000_000 {
            let followers = Double(designer.followerCount) / 10_000.0
            if followers.truncatingRemainder(dividingBy: 1) == 0 {
                return "\(Int(followers))만"
            } else {
                return "\(followers)만"
            }
        } else {
            let millions = designer.followerCount / 10_000
            return "\(millions)만"
        }
    }
    
}

#Preview {
    CMDesignerProfileView(designer: Designer(name: "양파쿵야", email: "", phoneNumber: "", designerScore: 0, reviewCount: 0, followerCount: 15430020, skill: [], chatRooms: [], birthDate: "", gender: "", rank: .Owner, designerUID: ""))
}
