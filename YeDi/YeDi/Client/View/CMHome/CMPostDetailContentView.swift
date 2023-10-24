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
    @ObservedObject var consultationViewModel: ConsultationViewModel = ConsultationViewModel()
    
    @StateObject var postDetailViewModel: PostDetailViewModel = PostDetailViewModel()

    @State private var showChattingRoom: Bool = false
    @State private var isPresentedAlert: Bool = false
    @State private var isPresentedNavigation: Bool = false
    
    let post: Post
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
        .background(Color.whiteMainColor)
        .onChange(of: consultationViewModel.showChattingRoom, perform: { value in
            showChattingRoom = consultationViewModel.showChattingRoom
        })
        .fullScreenCover(isPresented: $showChattingRoom) {
            ChatRoomSheetView(chatRoomId: consultationViewModel.chatRoomId)
        }
        .overlay(
            ZStack {
                if !postDetailViewModel.selectedImages.isEmpty {
                    imageDetailView
                }
            }
        )
        .onAppear {
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await postDetailViewModel.isFollowed(designerUid: post.designerID)
                    }
                    
                    group.addTask {
                        await postDetailViewModel.isLikedPost(post: post)
                    }
                    
                    group.addTask {
                        await postDetailViewModel.getDesignerProfile(designerUid: post.designerID)
                    }
                }
            }
        }
        .toolbarBackground(Color.white, for: .navigationBar)
    }
    
    private var toolbarView: some View {
        HStack {
            DismissButton(color: Color.primary) { }
            
            Spacer()
            
            Image(systemName: postDetailViewModel.isLiked ? "heart.fill" : "heart")
                .font(.title2)
                .foregroundStyle(postDetailViewModel.isLiked ? Color.subColor : Color.primaryLabel)
                .onTapGesture {
                    Task {
                        await postDetailViewModel.toggleLike(post: post)
                    }
                    postDetailViewModel.isLiked.toggle()
                }
        }
        .padding()
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
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width)
                        .clipped()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                postDetailViewModel.selectedImages = post.photos.map { $0.imageURL }
                                postDetailViewModel.selectedImageID = photo.imageURL
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
        }
    }

    private var divider: some View {
        Divider()
            .frame(minHeight: 10)
            .overlay(Color.divider)
            .padding(.top)
    }
    
    private var designerProfileView: some View {
        HStack(alignment: .center) {
            if postDetailViewModel.designer?.imageURLString != "" {
                AsyncImage(url: URL(string: postDetailViewModel.designer?.imageURLString ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 50, maxHeight: 50)
                        .clipShape(Circle())
                } placeholder: {
                    Text(String(postDetailViewModel.designer?.name.first ?? " ").capitalized)
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(width: 50, height: 50)
                                .background(Circle().fill(Color.quaternarySystemFill))
                                .foregroundColor(Color.primaryLabel)
                }
            } else {
                Text(String(postDetailViewModel.designer?.name.first ?? " ").capitalized)
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(width: 50, height: 50)
                            .background(Circle().fill(Color.quaternarySystemFill))
                            .foregroundColor(Color.primaryLabel)
            }

            VStack(alignment: .leading, spacing: 0) {
                Text("\(postDetailViewModel.designer?.name ?? "디자이너 이름")")
                    .font(.system(size: 16, design: .serif))
                
                Group {
                    Text("\(postDetailViewModel.designer?.shop?.shopName ?? "")")
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                Task {
                    await postDetailViewModel.toggleFollow(designerUid: post.designerID)
                }
            } label: {
                Text("\(postDetailViewModel.isFollowing ? "팔로잉" : "팔로우")")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(postDetailViewModel.isFollowing ? Color.primaryLabel : Color.whiteMainColor)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(postDetailViewModel.isFollowing ? Color.whiteMainColor : Color.primaryLabel)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(postDetailViewModel.isFollowing ? Color.secondarySystemFill : .clear, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private var footerView: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.divider)
            
            HStack(alignment: .center) {
                Button {
                    consultationViewModel.proccessConsulation(designerId: post.designerID, post: post)
                } label: {
                    Text("상담하기")
                        .foregroundStyle(Color.whiteMainColor)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(Color.primaryLabel)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button {
                    isPresentedNavigation.toggle()
                    isPresentedAlert.toggle()
                } label: {
                    Text("바로예약")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.subColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .navigationDestination(isPresented: $isPresentedNavigation, destination: {
                    CMReservationDateTimeView(isPresentedAlert: $isPresentedAlert, isPresentedNavigation: $isPresentedNavigation)
                        .environmentObject(postDetailViewModel)
                })
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
            
            TabView(selection: $postDetailViewModel.selectedImageID) {
                ForEach(postDetailViewModel.selectedImages, id: \.self) { imageString in
                    DMAsyncImage(url:imageString)
                        .aspectRatio(contentMode: .fit)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .overlay(
                Button {
                    withAnimation(.default) {
                        postDetailViewModel.selectedImages.removeAll()
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
        CMFeedDetailView(post: Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "물결 펌", description: "This is post 1", photos: [Photo(id: "p1", imageURL: "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MThfNTUg%2FMDAxNjYwNzkyNTY0NjM4.7AB8JmZVjAbAT2o2ACDRIPMLwdm63rC8OM2dCz6huTEg.1e6s7_D9ihi7VxTP-nNfLE1FzEP4kgXCuGy2TNDukuYg.JPEG.hjjyy1209%2FIMG_9195.jpg&type=sc960_832"),Photo(id: "p2", imageURL: "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MjZfMjU2%2FMDAxNjYxNTE4MjkzMzYw.ztWMtqeoDOGfIPGTtQ9H_o0Kkinyuud5nNgy-izSgEog.g0f0NGZbBTM8zcS8B8i4EtwU5n8-XdLJqPZxzehQXKEg.JPEG.yongminjoe%2FIMG_7361.JPG&type=sc960_832")], comments: 5, timestamp: "1시간 전", hairCategory: .Cut, price: 15000))
            .environmentObject(ConsultationViewModel())
            .environmentObject(UserAuth())
    }
}
