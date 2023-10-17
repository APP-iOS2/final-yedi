//
// DMPostView.swift
// YeDi
//
// Created by 이승준 on 2023/09/25.
//

import SwiftUI
import FirebaseFirestore

// MARK: - DMPostView 구조체
// 작성자: 박찬호
struct DMPostView: View {
    // 상태 변수 선언
    @State var selectedPost: Post
    @State private var selectedTab = 0
    @State private var showActionSheet = false
    @State private var showDeleteAlert = false
    @State private var navigateToEditView = false
    @State private var shouldRefresh = false
    @State private var expanded: Bool = false
    @State private var hairCategory: HairCategory = .Else



    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // MARK: - 본문 (Body)
    var body: some View {
        // 스크롤뷰 추가
        ScrollView {
            // 주요 컨텐츠 배치
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - 디자이너 정보와 위치
                HStack {
                    // 디자이너 정보와 위치
                    VStack(alignment: .leading) {
                        NavigationLink(destination: DMProfileView()) {
                            Text(selectedPost.designerID)
                                .font(.headline)
                                .foregroundColor(Color.black)
                        }
                        NavigationLink(destination: DMProfileView()) {
                            Text("\(selectedPost.location) | \(selectedPost.title)")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                        }
                    }
                    Spacer()
                    
                    // 수정, 삭제 액션 버튼
                    HStack {
                        NavigationLink("", destination: DMEditPostView(post: $selectedPost, shouldRefresh: $shouldRefresh), isActive: $navigateToEditView)
                        Button(action: {
                            showActionSheet = true
                        }) {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                                .foregroundColor(Color.black)
                        }
                    }
                    // 액션 시트
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("선택"), buttons: [
                            .default(Text("수정"), action: {
                                navigateToEditView = true
                            }),
                            .destructive(Text("삭제"), action: {
                                showDeleteAlert = true
                            }),
                            .cancel()
                        ])
                    }
                }
                .padding(.horizontal)
                // 삭제 확인 알럿
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("삭제 확인"),
                        message: Text("이 게시물을 정말로 삭제하시겠습니까?"),
                        primaryButton: .default(Text("취소")),
                        secondaryButton: .destructive(Text("삭제"), action: deletePost)
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
                // MARK: - 게시 시간
                Text(selectedPost.timestamp)
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal)
            }
            // 새로고침 기능
            .refreshable {
                refreshPost()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: refreshPost) {
            Image(systemName: "arrow.clockwise")  // 새로고침 아이콘
                .foregroundStyle(Color.black)
        })
        .onAppear {
            if shouldRefresh {
                refreshPost()
                shouldRefresh = false
            }
        }
    }

    // MARK: - 새로고침 함수
    private func refreshPost() {
        // 게시글 ID 확인
        guard let postId = selectedPost.id else { return }
        guard let currentDesignerID = userAuth.currentDesignerID else { return }

        // Firestore에서 게시글 정보 업데이트
        let db = Firestore.firestore()
        db.collection("posts")
            .whereField("designerID", isEqualTo: currentDesignerID) // 현재 디자이너의 게시물만 쿼리
            .whereField("id", isEqualTo: postId) // 게시글 ID로 필터링
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                } else if let documents = snapshot?.documents, let document = documents.first {
                    if let refreshedPost = try? document.data(as: Post.self) {
                        self.selectedPost = refreshedPost
                    } else {
                        print("Error decoding post.")
                    }
                }
            }
    }
    // MARK: - 게시글 삭제 함수
    private func deletePost() {
        // 게시글 ID 확인
        guard let postId = selectedPost.id else { return }
        
        // Firestore에서 게시글 삭제
        let db = Firestore.firestore()
        db.collection("posts").document(postId).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
                // 삭제 완료 알림
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

// MARK: - 미리보기
struct DMPostView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "물결 펌", description: "This is post 1 This is post 1 Thisㅁㅁㅁㅁㅁㅁㅁㅁㄴㄴㅁㅁ", photos: [Photo(id: "p1", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg")], comments: 5, timestamp: "1시간 전", hairCategory: .Cut)
        
        DMPostView(selectedPost: samplePost)
    }
}
