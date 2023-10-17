//
//  DMEditPostView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/28.
//

import SwiftUI
import FirebaseFirestore

// MARK: - DMEditPostView
// 게시물을 수정하는 뷰
struct DMEditPostView: View {
    @Binding var post: Post
    @Binding var shouldRefresh: Bool  // 새로운 Binding 변수 추가
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var imageUrls: [String] = []
    @State private var newImageUrl = ""
    @State private var showAlert = false
    @State private var hairCategory: HairCategory = .Else

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let hairCategoryArray: [HairCategory] = [HairCategory.Cut,
                            HairCategory.Dying,
                            HairCategory.Perm,
                            HairCategory.Else]
    
    private var isFormValid: Bool {
        return !title.isEmpty && !description.isEmpty && !imageUrls.isEmpty
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView {
                        contentForm
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack {
                        Button(action: {
                            updatePost()
                        }) {
                            Text("확인")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(isFormValid ? Color.black : Color.gray)
                                .cornerRadius(10)
                        }
                        .padding([.leading, .trailing], 16)
                        .padding(.bottom, 16)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("게시물 수정")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            self.title = post.title
            self.description = post.description ?? ""
            self.imageUrls = post.photos.map { $0.imageURL }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("성공"),
                message: Text("게시물이 수정되었습니다."),
                dismissButton: .default(Text("확인")) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    
    // MARK: - Custom Views
    private var contentForm: some View {
        VStack(alignment: .leading) {
            TextField("시술명", text: $title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            TextField("내용", text: $description)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            categoryPickerView
            imageUrlsSection
            
        }
        .padding([.leading, .trailing], 20)
    }
    
    private var categoryPickerView: some View {
            VStack{
                Text("스타일 종류를 선택하세요")
                Picker("", selection: $hairCategory) {
                    ForEach(hairCategoryArray, id: \.self) { style in
                        Text("\(style.rawValue)")
                    }

                }

            }
        }
    
    private var imageUrlsSection: some View {
        VStack(alignment: .leading) {
            Text("이미지 URL")
                .font(.headline)
            ForEach(Array(zip(imageUrls.indices, imageUrls)), id: \.0) { index, imageUrl in
                HStack {
                    Text(imageUrl)
                    Spacer()
                    Button("수정") {
                        // 수정 버튼을 누를 경우, 수정할 수 있도록 구현
                        newImageUrl = imageUrl
                        imageUrls.remove(at: index)
                    }
                    Button("삭제") {
                        imageUrls.remove(at: index)
                    }
                }
            }
            HStack {
                TextField("이미지 URL을 입력해주세요.", text: $newImageUrl)
                Button("추가") {
                    if !newImageUrl.isEmpty {
                        imageUrls.append(newImageUrl)
                        newImageUrl = ""
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Helper Functions
    private func updatePost() {
        guard let postId = post.id else { return }
        
        let db = Firestore.firestore()
        let updatedPhotos = imageUrls.map { Photo(id: UUID().uuidString, imageURL: $0) }
        let updatedPhotosDicts = updatedPhotos.map { $0.dictionary } // Photo 객체를 Dictionary로 변환
        
        db.collection("posts").document(postId).updateData([
            "title": title,
            "description": description,
            "photos": updatedPhotosDicts,  // Dictionary 배열로 업데이트
            "hairCategory" : hairCategory.rawValue
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                showAlert = true  // 게시물 수정 성공 알림
                shouldRefresh = true  // 새로고침이 필요함을 알림
            }
        }
    }
}


struct DMEditPostView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = State(initialValue: Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "물결 펌", description: "This is post 1", photos: [Photo(id: "p1", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg")], comments: 5, timestamp: "1시간 전", hairCategory: .Cut))
        let shouldRefresh = State(initialValue: false)
        DMEditPostView(post: samplePost.projectedValue, shouldRefresh: shouldRefresh.projectedValue)
    }
}
