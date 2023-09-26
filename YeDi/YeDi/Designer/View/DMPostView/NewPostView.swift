//
//  NewPostView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/26.
//

import SwiftUI
import FirebaseFirestore

struct NewPostView: View {
    @State private var title: String = ""  // 게시물 제목
    @State private var description: String = ""  // 게시물 내용
    @State private var imageURL: String = ""  // 이미지 URL
    
    @EnvironmentObject var userAuth: UserAuth  // 사용자 인증 정보
    @Environment(\.presentationMode) var presentationMode  // 현재 뷰의 표시 상태


    var body: some View {
        NavigationView {
            VStack {
                // 시술명 입력 필드
                VStack(alignment: .leading) {
                    Text("시술명")
                        .font(.headline)
                    TextField("시술명을 입력해주세요.", text: $title)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                .padding(.bottom, 20)
                
                // 내용 입력 필드
                VStack(alignment: .leading) {
                    Text("내용")
                        .font(.headline)
                    TextField("내용을 입력해주세요.", text: $description)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                .padding(.bottom, 20)
                
                // 이미지 URL 입력 필드
                VStack(alignment: .leading) {
                    Text("이미지 URL")
                        .font(.headline)
                    TextField("이미지 URL을 입력해주세요.", text: $imageURL)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                .padding(.bottom, 20)
                
                // 게시물 생성 버튼
                Button("게시물 생성") {
                    let newPost = Post(
                        id: nil,
                        designerID: userAuth.currentDesignerID ?? "Unknown",
                        location: "예디샵 홍대지점",
                        title: title,
                        description: description,
                        photos: [Photo(id: "someID", imageURL: imageURL)],
                        comments: 0,
                        timestamp: "just now"
                    )
                    savePostToFirestore(post: newPost)  // Firestore에 게시물 저장
                    self.presentationMode.wrappedValue.dismiss()  // 현재 뷰 닫기
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding([.leading, .trailing], 20)
            .navigationTitle("새 게시물")
        }
    }
    
    // Firestore에 게시물 저장 함수
    private func savePostToFirestore(post: Post) {
        let db = Firestore.firestore()  // Firestore 인스턴스
        do {
            try db.collection("posts").addDocument(from: post)  // 'posts' 컬렉션에 새 문서 추가
        } catch let error {
            print("Firestore에 데이터 쓰기 오류: \(error)")
        }
    }
}

#Preview {
    NewPostView()
}
