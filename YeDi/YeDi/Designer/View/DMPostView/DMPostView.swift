//
// DMPostView.swift
// YeDi
//
// Created by 박찬호 on 2023/09/25.
//

import SwiftUI
import FirebaseFirestore

/// 디자이너 포스트 뷰
struct DMPostView: View {

    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var postViewModel: DMPostViewModel

    /// 선택한 포스트
    @State var selectedPost: Post
    /// 포스트 사진 인덱스
    @State private var selectedTab = 0
    /// 수정 및 삭제를 위한 액션 Sheet용 Bool타입 변수
    @State private var isShowingActionSheet: Bool = false
    /// 삭제 확인을 위한 Alert용 Bool타입 변수
    @State private var isShowingDeleteAlert: Bool = false
    /// 수정 뷰로 이동하기 위한 Bool타입 변수
    @State private var navigateToEditView: Bool = false
    /// 새로고침 여부를 나타내기 위한 Bool타입 변수
    @State private var shouldRefresh: Bool = false
    /// 시술 카테고리를 담은 변수
    @State private var hairCategory: HairCategory = .Else

    // MARK: - Body
    var body: some View {
        // 스크롤뷰 추가
        ScrollView {
            // 주요 컨텐츠 배치
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    // MARK: - 디자이너 정보와 위치
                    VStack(alignment: .leading) {
                        // 디자이너 정보
                        NavigationLink(destination: DMProfileView()) {
                            Text(selectedPost.designerID)
                                .font(.headline)
                                .foregroundColor(Color(UIColor.label))
                        }
                        // 디자이너 위치
                        NavigationLink(destination: DMProfileView()) {
                            Text("\(selectedPost.location) | \(selectedPost.title)")
                                .font(.caption)
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                    }
                    Spacer()
                    
                    // MARK: - 수정, 삭제 액션 버튼
                    HStack {

                        NavigationLink(isActive: $navigateToEditView) {
                            DMEditPostView(post: $selectedPost, shouldRefresh: $shouldRefresh)
                        } label: {
                            Button(action: {
                                isShowingActionSheet = true
                            }) {
                                Image(systemName: "ellipsis")
                                    .imageScale(.large)
                                    .foregroundColor(Color.black)
                            }

                        }
                    }
                    // MARK: - 수정 및 삭제를 위한 액션 Sheet
                    .actionSheet(isPresented: $isShowingActionSheet) {
                        ActionSheet(title: Text("선택"), buttons: [
                            .default(Text("수정"), action: {
                                navigateToEditView = true
                            }),
                            .destructive(Text("삭제"), action: {
                                isShowingDeleteAlert = true
                            }),
                            .cancel()
                        ])
                    }
                }
                .padding(.horizontal)
                // MARK: - 삭제 확인 Alert
                .alert(isPresented: $isShowingDeleteAlert) {
                    Alert(
                        title: Text("삭제 확인"),
                        message: Text("이 게시물을 정말로 삭제하시겠습니까?"),
                        primaryButton: .default(Text("취소")),
                        secondaryButton: .destructive(Text("삭제"), action: {
                            postViewModel.deletePost(selectedPost: selectedPost)
                            
                            DispatchQueue.main.async {
                                presentationMode.wrappedValue.dismiss()
                            }
                        })
                    )
                }
                
                // MARK: - 게시글 사진
                TabView(selection: $selectedTab) {
                    ForEach(Array(selectedPost.photos.enumerated()), id: \.element.id) { index, photo in
                        DMAsyncImage(url: photo.imageURL)
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 350)
                            .clipped()
                            .tag(index)
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: selectedPost.photos.count > 1 ? .automatic : .never))
                
                // MARK: - 게시글 설명
                if let description = selectedPost.description {
                    DMExpandableText(text: description)
                        .padding(.horizontal)
                }
                // MARK: - 게시글 시술 카테고리
                Text("\(selectedPost.hairCategory.rawValue)")
                    .padding(.horizontal)
                // MARK: - 게시글 시술 가격
                Text("\(selectedPost.price)")
                    .padding(.horizontal)
                // MARK: - 게시 시간
                Text(selectedPost.timestamp)
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .padding(.horizontal)
            }
            // 새로고침 기능
            .refreshable {
                refreshPost(post: selectedPost)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton(color: nil, action: {})
            }
        }
        .onAppear {
            refreshPost(post: selectedPost)
        }
    }
    
    /// 새로고침 함수
    func refreshPost(post: Post) {
        // 게시글 ID 확인
        guard let postId = selectedPost.id else { return }
        guard let currentDesignerID = userAuth.currentDesignerID else { return }

        // Firestore에서 게시글 정보 업데이트
        Firestore.firestore().collection("posts")
            .whereField("designerID", isEqualTo: currentDesignerID) // 현재 디자이너의 게시물만 쿼리
            .whereField("id", isEqualTo: postId) // 게시글 ID로 필터링
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                } else if let documents = snapshot?.documents, let document = documents.first {
                    if let refreshedPost = try? document.data(as: Post.self) {
                        selectedPost = refreshedPost
                    } else {
                        print("Error decoding post.")
                    }
                }
            }
    }
}

// MARK: - 미리보기
struct DMPostView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "물결 펌", description: "This is post 1 This is post 1 Thisㅁㅁㅁㅁㅁㅁㅁㅁㄴㄴㅁㅁ", photos: [Photo(id: "p1", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg")], comments: 5, timestamp: "1시간 전", hairCategory: .Cut, price: 15000)
      
        DMPostView(selectedPost: samplePost) 
            .environmentObject(DMPostViewModel())
    }
}
