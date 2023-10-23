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
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundStyle(Color.mainColor)
            }
            
            Spacer()
            
            Image(systemName: postDetailViewModel.isLiked ? "heart.fill" : "heart")
                .font(.title2)
                .foregroundStyle(postDetailViewModel.isLiked ? Color.subColor : Color.mainColor)
                .onTapGesture {
                    Task {
                        await postDetailViewModel.toggleLike(post: post)
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
            .frame(minHeight: 7)
            .overlay(Color.lightGrayColor)
            .padding(.top)
    }
    
    private var designerProfileView: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/yedi-b7f5a.appspot.com/o/clients%2Fprofiles%2FdAWO8ofNhPU2UuHeWG7u9OYncnk1?alt=media&token=c2b8bdfe-4aa7-44de-a0d0-aa3a5a252a7e")) { image in
                image
                    .resizable()
                    .frame(maxWidth: 45, maxHeight: 45)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 45)
                    .clipShape(Circle())
                    .foregroundStyle(.gray)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("\(postDetailViewModel.designer?.name ?? "디자이너 이름")")
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
                    await postDetailViewModel.toggleFollow(designerUid: post.designerID)
                }
            } label: {
                Text("\(postDetailViewModel.isFollowing ? "팔로잉" : "팔로우")")
                    .font(.caption)
                    .foregroundStyle(postDetailViewModel.isFollowing ? .black : .white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 7)
                    .background(postDetailViewModel.isFollowing ? .white : .black)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(postDetailViewModel.isFollowing ? .black : .clear, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
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
    }
}
