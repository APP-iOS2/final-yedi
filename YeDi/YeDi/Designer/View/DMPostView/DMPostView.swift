// DMPostView.swift
// YeDi
//
// Created by 이승준 on 2023/09/25.
//

import SwiftUI
import FirebaseFirestore

// MARK: - DMPostView
struct DMPostView: View {
    let selectedPost: Post  // 선택된 게시글
    @State private var selectedTab = 0  // 현재 선택된 탭 페이지
    @State private var showActionSheet = false  // 액션 시트 표시 여부
    @State private var showDeleteAlert = false  // 삭제 확인 알림 표시 여부
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>  // 이전 화면으로 돌아가기 위한 변수

    // MARK: - Body
    var body: some View {
        // 스크롤뷰 추가
        ScrollView {
            // 컨텐츠 배치
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - 디자이너 정보와 위치
                HStack {
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
                    
                    // 수정, 삭제 메뉴
                    Button(action: {
                        showActionSheet = true
                    }) {
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                            .foregroundColor(Color.black)
                    }
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("선택"), buttons: [
                            .default(Text("수정"), action: {
                                // 수정 로직
                            }),
                            .destructive(Text("삭제"), action: {
                                showDeleteAlert = true
                            }),
                            .cancel()
                        ])
                    }
                }
                .padding(.horizontal)
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
                        AsyncImage(url: photo.imageURL)
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
                    Text(description)
                        .foregroundColor(Color.black)
                        .padding(.horizontal)
                }
                
                // MARK: - 게시 시간
                Text(selectedPost.timestamp)
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
    }

    // MARK: - Helper Functions
    private func deletePost() {
        guard let postId = selectedPost.id else { return }
        
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

struct DMPostView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "물결 펌", description: "This is post 1", photos: [Photo(id: "p1", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg")], comments: 5, timestamp: "1시간 전")
        
        DMPostView(selectedPost: samplePost)
    }
}
