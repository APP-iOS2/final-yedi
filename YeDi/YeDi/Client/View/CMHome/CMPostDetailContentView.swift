//
//  CMFeedDetailContentView.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/09/25.
//

import SwiftUI

struct CMFeedDetailContentView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var consultationViewModel: ConsultationViewModel
    
    @StateObject var postViewModel: PostDetailViewModel = PostDetailViewModel()

    @State private var showChattingRoom: Bool = false
    
    let post: Post
    private let images: [String] = ["https://images.pexels.com/photos/18005100/pexels-photo-18005100/free-photo-of-fa1-vsco.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2", "https://images.pexels.com/photos/17410647/pexels-photo-17410647.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"]
    let safeArea: EdgeInsets
    let size: CGSize
    
    var body: some View {
        VStack(spacing: 0) {
            toolbarView
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    imageTabView
                    feedInfoView
                    divider
                    designerProfileView
                }
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
                await postViewModel.isLikedPost(post: post)
            }
        }
        .toolbarBackground(Color.white, for: .navigationBar)
    }
    
    private var toolbarView: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundStyle(Color.mainColor)
            }
            
            Spacer()
            
            Image(systemName: postViewModel.isLiked ? "heart.fill" : "heart")
                .font(.title2)
                .foregroundStyle(postViewModel.isLiked ? Color.subColor : Color.mainColor)
                .onTapGesture {
                    Task {
                        await postViewModel.toggleLike(post: post)
                    }
                }
        }
        .padding([.horizontal, .bottom])
        .padding(.top, safeArea.top)
    }
    
    @ViewBuilder
    private var imageTabView: some View {
        let height = size.height * 0.4
        TabView {
            ForEach(post.photos, id: \.id) { photo in
                AsyncImage(url: URL(string: "\(photo.imageURL)")){ image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.width, height: size.height * 1.4)
                        .clipped()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                postViewModel.selectedImages = post.photos.map { $0.imageURL }
                                postViewModel.selectedImageID = photo.imageURL
                            }
                        }
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .background(.black)
        .frame(height: height * 1.4)
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var feedInfoView: some View {
        VStack(alignment: .leading) {
            Text("\(post.description ?? "")")
                .padding([.horizontal, .top])
            
            HStack {
                ForEach(0...1, id: \.self) { _ in
                    Text("#레이어드")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .foregroundStyle(Color.mainColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.subColor, lineWidth: 1)
                        )
                }
            }
            .padding([.leading])
        }
    }

    private var divider: some View {
        Divider()
            .frame(minHeight: 7)
            .overlay(Color.brightGrayColor)
            .padding(.top)
    }
    
    private var designerProfileView: some View {
        HStack(alignment: .center) {
            DMAsyncImage(url: images[0])
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 45)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 0) {
                Text("\(post.designerID)")
                    .font(.system(size: 16, design: .serif))
                
                Group {
                    Text("서울/합정")
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                Task {
                    await postViewModel.toggleFollow(designerUid: post.designerID)
                }
            } label: {
                Text("\(postViewModel.isFollowing ? "팔로잉" : "팔로우")")
                    .font(.caption)
                    .foregroundStyle(postViewModel.isFollowing ? .black : .white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 7)
                    .background(postViewModel.isFollowing ? .white : .black)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(postViewModel.isFollowing ? .black : .clear, lineWidth: 1)
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
                .background(Color.mainColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                NavigationLink {
                    CMReservationDateTimeView()
                } label: {
                    Text("바로예약")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.subColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.automatic)
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
    NavigationStack {
        CMFeedDetailView(post: Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "물결 펌", description: "This is post 1", photos: [Photo(id: "p1", imageURL: "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MThfNTUg%2FMDAxNjYwNzkyNTY0NjM4.7AB8JmZVjAbAT2o2ACDRIPMLwdm63rC8OM2dCz6huTEg.1e6s7_D9ihi7VxTP-nNfLE1FzEP4kgXCuGy2TNDukuYg.JPEG.hjjyy1209%2FIMG_9195.jpg&type=sc960_832"),Photo(id: "p2", imageURL: "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MjZfMjU2%2FMDAxNjYxNTE4MjkzMzYw.ztWMtqeoDOGfIPGTtQ9H_o0Kkinyuud5nNgy-izSgEog.g0f0NGZbBTM8zcS8B8i4EtwU5n8-XdLJqPZxzehQXKEg.JPEG.yongminjoe%2FIMG_7361.JPG&type=sc960_832")], comments: 5, timestamp: "1시간 전"))
            .environmentObject(ConsultationViewModel())
    }
}
