//
//  CMFeedDetailContentView.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/09/25.
//

import SwiftUI

struct CMFeedDetailContentView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userAuth: UserAuth
    
    @StateObject var postViewModel: PostDetailViewModel = PostDetailViewModel()
    @EnvironmentObject var consultationViewModel: ConsultationViewModel
    @State private var showChattingRoom: Bool = false
    @State private var isLiked: Bool = false
    @State private var isFollowed: Bool = false
    let post: Post
    private let images: [String] = ["https://images.pexels.com/photos/18005100/pexels-photo-18005100/free-photo-of-fa1-vsco.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2", "https://images.pexels.com/photos/17410647/pexels-photo-17410647.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"]
    let safeArea: EdgeInsets
    let size: CGSize
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: true) {
                imageTabView
                feedInfoView
                designerProfileView
            }
            .coordinateSpace(name: "SCROLL")
            .overlay(alignment: .top) {
                headerView
            }
            
            footerView
        }
        .onChange(of: consultationViewModel.showChattingRoom, perform: { value in
            showChattingRoom = consultationViewModel.showChattingRoom
        })
        .fullScreenCover(isPresented: $showChattingRoom) {
            ChatRoomSheetView(chatRoomId: consultationViewModel.chatRoomId)
        }
        .overlay(
            ZStack {
                if !postViewModel.selectedImages.isEmpty {
                    imageDetailView
                }
            }
        )
        .onAppear {
            Task {
                await postViewModel.isFollowed(designerUid: post.designerID)
                isFollowed = postViewModel.isFollowing
            }
        }
    }
    
    private var headerView: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCORLL")).minY
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Button {
                      isLiked.toggle()
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.title)
                        .foregroundStyle(isLiked ? .pink : .white)
                }
            }
            .padding(.top, safeArea.top)
            .padding([.horizontal, .bottom], 20)
            .offset(y: -minY)
            // TODO: 스크롤시에 헤더 배경이 이미지를 벗어날 경우에 background displaying
        }
    }
    
    @ViewBuilder
    private var imageTabView: some View {
        let height = size.height * 0.4
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            
            TabView {
                ForEach(post.photos, id: \.id) { photo in
                    AsyncImage(url: URL(string: "\(photo.imageURL)")){ image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                            .clipped()
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    postViewModel.selectedImages = post.photos.map { $0.imageURL }
                                    postViewModel.selectedImageID = photo.imageURL
                                }
                            }
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: safeArea.top + 50)
                                .zIndex(1),
                                alignment: .top
                            )
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .background(.black)
            .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
            .offset(y: minY > 0 ? -minY : 0)
            .tabViewStyle(PageTabViewStyle())
        }
        .frame(height: height + safeArea.top)
    }
    
    private var feedInfoView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                ForEach(0...1, id: \.self) { _ in
                    Text("#레이어드")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(UIColor(red: 0, green: 0, blue: 1, alpha: 0.45)))
                        .clipShape(RoundedRectangle(cornerRadius:5))
                        .foregroundStyle(.white)
                }
            }
            .padding([.leading, .top])
            .padding(.bottom, 8)
            
            Text("\(post.description ?? "")")
                .padding(.horizontal)
            
            Divider()
                .frame(height: 7)
                .background(.gray)
                .padding(.top)
        }
    }
    
    private var designerProfileView: some View {
        HStack(alignment: .center) {
            DMAsyncImage(url: images[0])
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 50)
                    .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("\(post.designerID)")
                    .font(.system(size: 16, design: .serif))
                
                Group {
                    Text("서울/합정")
                    Text("팔로우 234")
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                Task {
                    await postViewModel.toggleFollow(designerUid: post.designerID)
                }
                isFollowed.toggle()
            } label: {
                Text("\(isFollowed ? "팔로잉" : "팔로우")")
                    .font(.system(size: 14))
                    .foregroundStyle(isFollowed ? .black : .white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                    .background(isFollowed ? .white : .black)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(isFollowed ? .black : .clear, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal)
    }
    
    private var footerView: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(alignment: .center) {
                Button {
                    consultationViewModel.proccessConsulation(designerId: post.designerID, post: post)
                } label: {
                    Text("상담하기")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button {
                    
                } label: {
                    Text("바로예약")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(.pink)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        }
       
    }
    
    private var imageDetailView: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            TabView(selection: $postViewModel.selectedImageID) {
                ForEach(postViewModel.selectedImages, id: \.self) { imageString in
                    DMAsyncImage(url:imageString)
                            .aspectRatio(contentMode: .fit)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .overlay(
                Button {
                    withAnimation(.default) {
                        postViewModel.selectedImages.removeAll()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                }
                    .padding(.top, safeArea.top)
                ,alignment: .topTrailing
            )
        }
    }
}

#Preview {
    CMFeedDetailView(post: Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "물결 펌", description: "This is post 1", photos: [Photo(id: "p1", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg"),Photo(id: "p2", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg")], comments: 5, timestamp: "1시간 전", hairCategory: .Cut))
        .environmentObject(ConsultationViewModel())
}
