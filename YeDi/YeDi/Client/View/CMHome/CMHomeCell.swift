//
//  CMHomeCell.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI

struct CMHomeCell: View {
    var post: Post
    
    /// 이미지의 수를 판단할 수 있는 변수
    @State private var selectedImageIndex: Int = 0
    /// 찜 버튼을 눌렀는지 판단할 수 있는 변수
    @State private var isLiked: Bool = false
    /// 텍스트 수가 지정된 수를 넘었는지 확인할 수 있는 변수
    @State private var shouldShowMoreText: Bool = false
    /// 이미지를 두 번 연속 눌렀을 때 나오는 하트 이미지 변수
    @State private var showHeartImage: Bool = false
    
    var body: some View {
        VStack {
            // MARK: Post Header
            HStack {
                // 디자이너 프로필 이미지
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                // 디자이너 아이디 & 디자이너 근무 지점
                VStack(alignment: .leading) {
                    Text(post.designerID)
                    Text(post.location)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            // MARK: Post Image
            // 업로드한 이미지의 수가 1장일 경우와 1장 이상일 경우 분리
            // 1장의 경우는 단순히 이미지를 불러오고
            // 1장 이상일 경우에는 TabView를 이용하여 사진을 넘길 수 있음
            if post.photos.count == 1 {
                // TODO: 이미지 누르면 DetailVeiw로 이동
                // 이 주석 아래에 있는 4개의 주석을 풀고 디테일 뷰에서 imageURL 받기
                //                NavigationLink(destination: CMFeedDetailView(imageURL: post.photos[0].imageURL)) {
                AsyncImage(url: post.photos[0].imageURL, placeholder: Image(systemName: "photo"))
                    .frame(width: 360, height: 360)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    .onTapGesture(count: 2) { // 이미지를 2번 연속 눌렀을 때
                        isLiked = true
                        showHeartImage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showHeartImage = false
                        }
                    }
                //                }
            } else {
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<post.photos.count, id: \.self) { index in
                        //                        NavigationLink(destination: CMFeedDetailView(imageURL: post.photos[index].imageURL)) {
                        AsyncImage(url: post.photos[index].imageURL, placeholder: Image(systemName: "photo"))
                            .frame(width: 360, height: 360)
                            .aspectRatio(contentMode:.fit)
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
                                        .padding(10)
                                }
                                    .frame(maxWidth: .infinity, alignment: .topTrailing),alignment: .topTrailing
                            )
                        //                        }
                    }
                    .onTapGesture(count: 2) { // 이미지를 2번 연속 눌렀을 때
                        isLiked = true
                        showHeartImage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showHeartImage = false
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 360)
                .padding(.horizontal)
            }
            
            // MARK: Post Button
            HStack {
                // 게시글 찜 Button
                // 계획) 버튼을 누르면 고객의 찜한 게시물 목록에 저장
                // 질문) 하트 모양이 단순히 좋아요 느낌으로 다가오는 느낌이 있는데 변경이 필요할지?
                Button(action: {
                    isLiked.toggle()
                }, label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundStyle(isLiked ? .red : .black)
                })
                Spacer()
                // 상담하기 Button
                // 계획) 버튼을 누르면 채팅방으로 이동
                Button(action: {}, label: {
                    Text("상담하기")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7)
                        .background {
                            Capsule(style: .continuous)
                                .stroke(.black, lineWidth: 1)
                        }
                })
                .foregroundColor(.black)
            }
            .padding(.horizontal)
            
            // MARK: Post Description
            // 게시글의 텍스트 제한이 없기 때문에 게시글이 방대해질 경우를 대비하여 더보기 설정
            HStack {
                if shouldShowMoreText || post.description?.count ?? 0 <= 60 {
                    Text("\(post.designerID) ").fontWeight(.semibold) + Text(post.description ?? "")
                } else {
                    Text("\(post.designerID) ").fontWeight(.semibold) + Text(post.description?.prefix(60) ?? "") + Text("...더보기")
                    
                }
                Spacer()
            }
            .padding(.horizontal)
            .onTapGesture {
                shouldShowMoreText.toggle()
            }
        }
        .padding(.bottom)
        .overlay( // 이미지를 2번 연속 눌렀을 경우 이미지 위에 하트 이미지가 뜨도록 설정
            ZStack {
                if showHeartImage {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.red)
                        .padding()
                        .zIndex(1) // 메시지를 이미지 위에 배치
                }
            }
        )
    }
}

#Preview {
    CMHomeCell(post: Post(id: "1", designerID: "디자이너 이름", location: "디자이너 근무 지점", title: "게시물 제목", description: "게시물 설명", photos: [Photo(id: "1", imageURL: "https://example.com/image1.jpg"), Photo(id: "2", imageURL: "https://example.com/image2.jpg")], comments: 0, timestamp: "타임스탬프"))
}
