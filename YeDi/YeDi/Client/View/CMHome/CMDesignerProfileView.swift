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
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(designer.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(designer.description ?? "")
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                }
                Spacer()
                if let imageURLString = designer.imageURLString {
                    AsyncImage(url: URL(string: "\(imageURLString)")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 50, maxHeight: 50)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 50, maxHeight: 50)
                            .clipShape(Circle())
                            .foregroundStyle(.gray)
                    }
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 50, maxHeight: 50)
                        .clipShape(Circle())
                        .foregroundStyle(.gray)
                    
                }
            }
            .padding()
            
            HStack {
                Text("\(designer.followerCount) 팔로워")
                Spacer()
                Button {
                    Task {
                        await viewModel.toggleFollow(designerUid: designer.designerUID)
                    }
                } label: {
                    Text("\(viewModel.isFollowing ? "팔로잉" : "팔로우")")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7)
                        .background {
                            Capsule(style: .continuous)
                                .stroke(.black.opacity(0.5), lineWidth: 1)
                        }
                }
            }
            .padding(.horizontal)
            
            VStack {
                VStack(alignment: .leading) {
                    Text("근무지 이름")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("근무지 주소")
                        .foregroundStyle(.gray)
                    Divider()
                    Text("휴무일")
                        .foregroundStyle(.gray)
                }
                .padding()
            }
            .background(.gray.opacity(0.2))
            .padding()
            
            VStack {
                HStack {
                    Text("이 디자이너의 게시물")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                }
                Divider()
                if designerPosts.isEmpty {
                    Text("업로드된 게시물이 없습니다")
                        .padding()
                } else {
                    LazyVGrid(columns: gridItems, spacing: 1) {
                        ForEach(designerPosts.prefix(6), id: \.id) { post in
                            DMAsyncImage(url: post.photos[0].imageURL, placeholder: Image(systemName: "photo"))
                                .scaledToFill()
                                .frame(width: imageDimension, height: imageDimension)
                                .clipped()
                            
                        }
                    }
                    NavigationLink(destination: CMStyleDetailView(designer: designer)) {
                        Text("스타일 전체보기")
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
                Task {
                    await viewModel.isFollowed(designerUid: designer.designerUID)
                }
            fetchDesignerPosts()
        }
        
        Spacer()
    }
    
    // Firestore에서 디자이너의 게시물 데이터를 가져오는 함수
    func fetchDesignerPosts() {
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
}

#Preview {
    CMDesignerProfileView(designer: Designer(name: "가나다", email: "", phoneNumber: "", designerScore: 0, reviewCount: 0, followerCount: 0, skill: [], chatRooms: [], birthDate: "", gender: "", rank: .Owner, designerUID: ""))
}
