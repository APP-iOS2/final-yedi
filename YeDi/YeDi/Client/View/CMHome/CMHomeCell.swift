//
//  CMHomeCell.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CMHomeCell: View {
    var post: Post
    
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var consultationViewModel: ConsultationViewModel
    @StateObject private var viewModel = CMHomeCellViewModel()
    
    /// 이미지의 수를 판단할 수 있는 변수
    @State private var selectedImageIndex: Int = 0
    /// 텍스트 수가 지정된 수를 넘었는지 확인할 수 있는 변수
    @State private var shouldShowMoreText: Bool = false
    /// 이미지를 두 번 연속 눌렀을 때 나오는 하트 이미지 변수
    @State private var showHeartImage: Bool = false
    /// 상담하기 버튼 채팅방 시트 표출 변수
    @State private var showChattingRoom = false
    
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width) - 10
    
    var body: some View {
        VStack {
            // MARK: - Post Header
            if let designer = viewModel.designer {
                NavigationLink(destination: CMDesignerProfileView(designer: designer)) {
                    HStack {
                        // 디자이너 프로필 이미지
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
                        // 디자이너 아이디 & 디자이너 근무 지점
                        VStack(alignment: .leading) {
                            Text(designer.name)
                                .foregroundStyle(Color.mainColor)
                            Text(post.location)
                                .font(.callout)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            
            
            // MARK: - Post Image
            // 업로드한 이미지의 수가 1장일 경우와 1장 이상일 경우 분리
            // 1장의 경우는 단순히 이미지를 불러오고
            // 1장 이상일 경우에는 TabView를 이용하여 사진을 넘길 수 있음
            if post.photos.count == 1 {
                NavigationLink(destination: CMFeedDetailView(post: post)) {
                    DMAsyncImage(url: post.photos[0].imageURL, placeholder: Image(systemName: "photo"))
                        .scaledToFill()
                        .frame(width: imageDimension, height: imageDimension)
                        .clipped()
                        .cornerRadius(8)
                        .onTapGesture(count: 2) { // 이미지를 2번 연속 눌렀을 때
                            viewModel.isLiked = true
                            showHeartImage = true
                            viewModel.likePost(forClientID: userAuth.currentClientID ?? "", post: post)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                showHeartImage = false
                            }
                        }
                }
            } else {
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<post.photos.count, id: \.self) { index in
                        NavigationLink(destination: CMFeedDetailView(post: post)) {
                            DMAsyncImage(url: post.photos[index].imageURL, placeholder: Image(systemName: "photo"))
                                .scaledToFill()
                                .frame(width: imageDimension, height: imageDimension)
                                .clipped()
                                .cornerRadius(8)
                                .tag(index)
                                .overlay( // 현재 이미지가 총 이미지 중에서 몇 번째인지를 나타냄
                                    ZStack {
                                        Text("\(selectedImageIndex + 1)/\(post.photos.count)")
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 7)
                                            .background {
                                                Capsule(style: .continuous)
                                                    .foregroundStyle(.black.opacity(0.5))
                                            }
                                            .padding()
                                    }
                                        .frame(maxWidth: .infinity, alignment: .topTrailing),alignment: .topTrailing
                                )
                        }
                    }
                    .onTapGesture(count: 2) { // 이미지를 2번 연속 눌렀을 때
                        viewModel.isLiked = true
                        showHeartImage = true
                        viewModel.likePost(forClientID: userAuth.currentClientID ?? "", post: post)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showHeartImage = false
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: imageDimension)
            }
            
            // MARK: - Post Button
            HStack {
                // 게시글 찜 Button
                Button(action: {
                    viewModel.isLiked.toggle()
                    viewModel.likePost(forClientID: userAuth.currentClientID ?? "", post: post)
                }, label: {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundStyle(viewModel.isLiked ? Color.subColor : Color.mainColor)
                })
                Spacer()
                // 상담하기 Button
                Button(action: {
                    consultationViewModel.proccessConsulation(designerId: post.designerID, post: post)
                }, label: {
                    Text("상담하기")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7)
                        .background {
                            Capsule(style: .continuous)
                                .stroke(Color.mainColor.opacity(0.5), lineWidth: 1)
                        }
                })
                .foregroundColor(Color.mainColor)
            }
            .padding(.horizontal)
            
            // MARK: - Post Description
            // 게시글의 텍스트 제한이 없기 때문에 게시글이 방대해질 경우를 대비하여 더보기 설정
            HStack {
                if shouldShowMoreText || post.description?.count ?? 0 <= 60 {
                    Text("\(viewModel.designer?.name ?? "디자이너 이름") ").fontWeight(.semibold) + Text(post.description ?? "")
                } else {
                    Text("\(viewModel.designer?.name ?? "디자이너 이름") ").fontWeight(.semibold) + Text(post.description?.prefix(60) ?? "") + Text("...더보기")
                    
                }
                Spacer()
            }
            .foregroundStyle(Color.mainColor)
            .padding(.horizontal)
            .onTapGesture {
                shouldShowMoreText.toggle()
            }
            
            HStack {
                Text("\(SingleTonDateFormatter.sharedDateFommatter.changeDateString(transition: "yyyy년 MM월 dd일", from: post.timestamp))")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .overlay( // 이미지를 2번 연속 눌렀을 경우 이미지 위에 하트 이미지가 뜨도록 설정
            ZStack {
                if showHeartImage {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color.subColor)
                        .padding()
                        .zIndex(1) // 메시지를 이미지 위에 배치
                }
            }
        )
        .onChange(of: consultationViewModel.showChattingRoom, perform: { value in
            showChattingRoom = consultationViewModel.showChattingRoom
        })
        .fullScreenCover(isPresented: $showChattingRoom) {
            ChatRoomSheetView(chatRoomId: consultationViewModel.chatRoomId)
                .onAppear {
                    if let currentClientID = userAuth.currentClientID {
                        viewModel.checkIfLiked(forClientID: currentClientID, post: post)
                    }
                }
        }
        .onAppear {
            Task {
                await viewModel.fetchDesignerInfo(post: post)
            }
            viewModel.checkIfLiked(forClientID: userAuth.currentClientID ?? "", post: post)
        }
    }
}

#Preview {
    CMHomeCell(post: Post(id: "1", designerID: "디자이너 이름", location: "디자이너 근무 지점", title: "게시물 제목", description: "게시물 설명", photos: [Photo(id: "1", imageURL: "https://example.com/image1.jpg"), Photo(id: "2", imageURL: "https://example.com/image2.jpg")], comments: 0, timestamp: "타임스탬프", hairCategory: .Cut))
        .environmentObject(ConsultationViewModel())
}
