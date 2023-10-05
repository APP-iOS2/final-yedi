//
//  NewPostView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/26.
//

import SwiftUI
import FirebaseFirestore


// 메인 게시물 생성 뷰
struct DMNewPostView: View {
    // MARK: - Properties
    @State private var title = ""
    @State private var description = ""
    @State private var imageUrls: [String] = []
    @State private var newImageUrl = ""
    @State private var showAlert = false

    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode

    // 폼 유효성 검사
    private var isFormValid: Bool {
        return !title.isEmpty && !description.isEmpty && !imageUrls.isEmpty
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    contentForm
                }
                .navigationTitle("새 게시물")
                .navigationBarTitleDisplayMode(.inline)
                postButton
            }
        }
    }

    // MARK: - Custom Views
    /// 게시물 폼 레이아웃
    private var contentForm: some View {
        VStack(alignment: .leading) {
            navigationLinkToTextEditor(title: "시술명", text: $title, placeholder: "시술명을 입력해주세요.")
                .foregroundStyle(.black)
            navigationLinkToTextEditor(title: "내용", text: $description, placeholder: "내용을 입력해주세요.")
                .foregroundStyle(.black)
            imageUrlsSection
            Spacer()
        }
        .padding([.leading, .trailing], 20)
    }
    
    /// 텍스트 편집기로 이동하는 네비게이션 링크
    private func navigationLinkToTextEditor(title: String, text: Binding<String>, placeholder: String) -> some View {
        NavigationLink(destination: TextEditorView(editingField: title, text: text, placeholder: placeholder)) {
            InputField(title: title, text: text, placeholder: placeholder)
        }
    }
    
    /// 이미지 URL 섹션
    private var imageUrlsSection: some View {
        VStack(alignment: .leading) {
            Text("이미지 URL")
                .font(.headline)
            ForEach(imageUrls, id: \.self) { imageUrl in
                Text(imageUrl)
            }
            HStack {
                TextField("이미지 URL을 입력해주세요.", text: $newImageUrl)
                Button("추가") {
                    imageUrls.append(newImageUrl)
                    newImageUrl = ""
                }
            }
        }
        .padding(.bottom, 20)
    }

    /// 게시물 생성 버튼
    private var postButton: some View {
        VStack {
            Spacer()
            Button("게시물 생성") {
                createPost()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isFormValid ? Color.black : Color.gray)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .padding([.horizontal, .bottom])
            .disabled(!isFormValid)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("성공"),
                    message: Text("게시물이 생성되었습니다."),
                    dismissButton: .default(Text("확인")) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }

    // MARK: - Helper Functions
    /// 게시물 생성 함수
    private func createPost() {
        let photos = imageUrls.map { Photo(id: UUID().uuidString, imageURL: $0) }
        let newPost = Post(
            id: nil,
            designerID: userAuth.currentDesignerID ?? "Unknown",
            location: "예디샵 홍대지점",
            title: title,
            description: description,
            photos: photos,
            comments: 0,
            timestamp: "just now"
        )
        savePostToFirestore(post: newPost)
        showAlert = true
    }

    /// Firestore에 게시물 저장
    private func savePostToFirestore(post: Post) {
        let db = Firestore.firestore()
        do {
            try db.collection("posts").addDocument(from: post)
        } catch let error {
            print("Error writing to Firestore: \(error)")
        }
    }
}


// MARK: - InputField
/// 입력 필드를 표현하는 SwiftUI 뷰
struct InputField: View {
    // MARK: - Properties
    var title: String
    @Binding var text: String
    var placeholder: String

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            HStack {
                Text(displayText)
                    .foregroundStyle(isPlaceholderText ? .gray : .black)
                Spacer()
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
        }
        .padding(.bottom, 20)
    }

    // MARK: - Helpers
    /// 텍스트가 비어 있거나 플레이스홀더와 동일한지 확인
    private var isPlaceholderText: Bool {
        return text.isEmpty || text == placeholder
    }

    /// 표시할 텍스트 결정
    private var displayText: String {
        if text.isEmpty || text == placeholder {
            return placeholder
        } else {
            return text
        }
    }
}

// MARK: - TextEditorView
/// 텍스트 편집기 뷰
struct TextEditorView: View {
    enum Field {
        case editor
    }

    // MARK: - Properties
    var editingField: String
    @Binding var text: String
    var placeholder: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var focusedField: Field?
    @State private var showPlaceholder: Bool = true

    // MARK: - Body
    var body: some View {
        ZStack (alignment: .topLeading) {
            TextEditor(text: $text)
                .focused($focusedField, equals: .editor)
                .onChange(of: text) { newValue in
                    showPlaceholder = newValue.isEmpty
                }
                .onAppear() {
                    // 키보드를 가능한 빨리 표시
                    DispatchQueue.main.async {
                        focusedField = .editor
                        showPlaceholder = text.isEmpty
                    }
                }
                .onTapGesture {
                    if showPlaceholder {
                        text = ""
                        showPlaceholder = false
                    }
                }
            .padding()
            .navigationTitle(editingField)
            .navigationBarBackButtonHidden(true)  // 뒤로 가기 버튼 숨기기

            // 플레이스홀더 표시
            if showPlaceholder {
                Text(placeholder)
                    .foregroundStyle(.gray)
                    .padding(.top, 25)
                    .padding(.leading, 23)
                    .onTapGesture {
                        text = ""
                        showPlaceholder = false
                        focusedField = .editor
                    }
            }

            // 확인 버튼
            VStack {
                Spacer()
                Button("확인") {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    DMNewPostView()
}