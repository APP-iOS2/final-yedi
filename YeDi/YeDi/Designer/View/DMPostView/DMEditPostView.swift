//
//  DMEditPostView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/28.
//

import SwiftUI
import FirebaseFirestore
import Firebase

/// 포스트 수정 뷰
struct DMEditPostView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var postViewModel: DMPostViewModel
    
    @Binding var post: Post
    @Binding var shouldRefresh: Bool  // 새로운 Binding 변수 추가
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var imageUrls: [String] = []
    @State private var hairCategory: HairCategory = .Else
    @State private var price: String = ""
    
    @State private var isShowingPhotoPicker: Bool = false
    @State private var isShowingConfirmAlert = false

    let hairCategoryArray: [HairCategory] = [
        HairCategory.Cut,
        HairCategory.Dying,
        HairCategory.Perm,
        HairCategory.Else
    ]
    
    private var isFormValid: Bool {
        return !title.isEmpty && !description.isEmpty && !imageUrls.isEmpty
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            contentForm
            
            Spacer()
            
            VStack {
                // MARK: - 수정 완료 버튼
                Button {
                    let updatedPost: Post = Post(
                        id: post.id,
                        designerID: post.designerID,
                        location: post.location,
                        title: title,
                        description: description,
                        photos: [],
                        comments: post.comments,
                        timestamp: post.timestamp,
                        hairCategory: hairCategory,
                        price: Int(price) ?? 0
                    )
                    
                    Task {
                        await postViewModel.updatePost(updatedPost: updatedPost, imageURLs: imageUrls)
                        isShowingConfirmAlert.toggle()
                    }
                } label: {
                    Text("확인")
                }
                .buttonModifier(.main)
                .padding([.leading, .trailing, .bottom])
            }
        }
        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPicker { imageURL in
                imageUrls.append(imageURL.absoluteString)
            }
        }
        .navigationTitle("게시물 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            self.title = post.title
            self.description = post.description ?? ""
            self.imageUrls = post.photos.map { $0.imageURL }
            self.hairCategory = post.hairCategory
            self.price = String(post.price)
        }
        .alert(isPresented: $isShowingConfirmAlert) {
            Alert(
                title: Text("수정 완료"),
                message: Text("게시물이 수정되었습니다."),
                dismissButton: .default(Text("확인")) {
                    shouldRefresh = true
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton(color: nil, action: {})
            }
        }
    }
    
    // MARK: - Custom Views
    /// 컨텐츠 폼
    private var contentForm: some View {
        VStack(alignment: .leading) {
            // MARK: - 시술 사진 수정 섹션
            PhotoSelectionView(selectedPhotoURLs: $imageUrls, isShowingPhotoPicker: $isShowingPhotoPicker)
            
            Group {
                // MARK: - 카테고리 수정 섹션
                categoryPickerView
                
                // MARK: - 시술명 수정 섹션
                Text("제목")
                    .fontWeight(.semibold)
                TextField("시술명", text: $title)
                    .textFieldModifier()
                    .padding(.bottom)
                
                // MARK: - 내용 수정 섹션
                Text("내용")
                    .fontWeight(.semibold)
                TextField("내용", text: $description, axis: .vertical)
                    .textAreaModifier(200)
                    .padding(.bottom)
                
                Text("가격")
                    .fontWeight(.semibold)
                TextField("가격", text: $price)
                    .textFieldModifier()
                    .keyboardType(.numberPad)
            }
            .padding([.leading, .trailing], 20)
        }
    }
    
    /// 시술 카테고리 피커 뷰
    private var categoryPickerView: some View {
        HStack {
            Text("시술 카테고리")
                .fontWeight(.semibold)
            Spacer()
            Picker("", selection: $hairCategory) {
                ForEach(hairCategoryArray, id: \.self) { style in
                    Text("\(style.rawValue)")
                }
            }
            .tint(.main)
        }
    }
}

struct DMEditPostView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = State(initialValue: Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "물결 펌", description: "This is post 1", photos: [Photo(id: "p1", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg")], comments: 5, timestamp: "1시간 전", hairCategory: .Cut, price: 15000))
        let shouldRefresh = State(initialValue: false)
        
        NavigationStack {
            DMEditPostView(post: samplePost.projectedValue, shouldRefresh: shouldRefresh.projectedValue)
        }
    }
}
