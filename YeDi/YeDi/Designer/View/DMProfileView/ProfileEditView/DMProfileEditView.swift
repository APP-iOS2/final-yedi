//
//  DMProfileEditView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/10/05.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

// DMProfileEditView: 디자이너의 프로필 수정 뷰
struct DMProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var profileViewModel: DMProfileViewModel
    
    // 디자이너 정보
    @State private var selectedPhotoURL: String = ""
    @State private var isShowingPhotoPicker: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var designerName: String = ""
    @State private var designerRank: Rank = .Designer
    @State private var designerGender: String = ""
    @State private var designerBirthDate: String = ""
    
    // 계정 정보
    @State private var accountEmail: String = ""
    @State private var accountPhoneNumber: String = ""
    
    // 샵 정보
    @State private var shopName: String = ""
    @State private var shopHeadAddress: String = ""
    @State private var shopSubAddress: String = ""

    func imageFromURL(_ url: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print("URL을 UIImage로 변환하는 중 오류 발생:", error)
            return nil
        }
    }

    func uploadImageToFirebaseStorage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("이미지를 Data 형식으로 변환하는 데 실패했습니다.")
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("profile_images/\(imageName).jpg")

        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Firebase Storage에 이미지 업로드 실패: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Firebase Storage에서 이미지 URL 가져오기 실패: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(url?.absoluteString)
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                profileImageSection() // 프로필 이미지 선택 및 표시 섹션
                
                // 디자이너 정보 수정 섹션
                Section {
                     DMDesignerInfoEditView(
                         designerName: $designerName,
                         designerRank: $designerRank,
                         designerGender: $designerGender,
                         designerBirthDate: $designerBirthDate,
                         isShowingDatePicker: $isShowingDatePicker
                     )
                     .padding(.bottom, 40)
                 } header: {
                     HStack {
                         Text("회원 정보")
                             .fontWeight(.semibold)
                             .padding(.leading)
                         Spacer()
                     }
                     Divider()
                         .frame(width: 360)
                 }
                
                // 계정 정보 수정 섹션
                Section {
                    DMAccountInfoEditView(
                        accountEmail: $accountEmail,
                        accountPhoneNumber: $accountPhoneNumber
                    )
                } header: {
                    HStack {
                        Text("계정 정보")
                            .fontWeight(.semibold)
                            .padding(.leading)
                        Spacer()
                    }
                    Divider()
                        .frame(width: 360)
                }
                
                Spacer()
                
                // 변경 사항 저장 버튼
                Button(action: {
                    if let designerId = userAuth.currentDesignerID {
                        let newDesigner = Designer(
                            id: designerId,
                            name: designerName,
                            email: accountEmail,
                            imageURLString: selectedPhotoURL,
                            phoneNumber: accountPhoneNumber,
                            description: nil,
                            designerScore: 0,
                            reviewCount: 0,
                            followerCount: 0,
                            skill: [],
                            chatRooms: [],
                            birthDate: designerBirthDate,
                            gender: designerGender,
                            rank: designerRank,
                            designerUID: designerId
                        )

                        Task {
                            let isSuccess = await profileViewModel.updateDesignerProfile(userAuth: userAuth, designer: newDesigner)
                            if isSuccess {
                                profileViewModel.designer = newDesigner
                                dismiss()
                            } else {
                                print("Firestore에 데이터 저장 실패")
                                // 사용자에게 데이터 저장 실패를 알리는 UI 로직을 추가
                            }
                        }
                    }
                }, label: {
                    Text("저장")
                         .frame(width: 330, height: 30)
                 })
                 .buttonStyle(.borderedProminent)
                 .tint(.black)
             }
             .navigationTitle("")
             .navigationBarTitleDisplayMode(.inline)
             .onAppear {
                 DispatchQueue.main.async {
                     designerName = profileViewModel.designer.name
                     designerRank = profileViewModel.designer.rank
                     designerGender = profileViewModel.designer.gender
                     designerBirthDate = profileViewModel.designer.birthDate
                     accountEmail = profileViewModel.designer.email
                     accountPhoneNumber = profileViewModel.designer.phoneNumber
                     selectedPhotoURL = profileViewModel.designer.imageURLString ?? ""
                 }
             }

            .sheet(isPresented: $isShowingPhotoPicker, content: {
                PhotoPicker { selectedImageURL in
                    guard let selectedImage = imageFromURL(selectedImageURL) else {
                        // 이미지 변환 오류 처리
                        return
                    }

                    // Firebase Storage에 이미지 업로드
                    uploadImageToFirebaseStorage(selectedImage) { uploadedImageURL in
                        if let uploadedImageURL = uploadedImageURL {
                            selectedPhotoURL = uploadedImageURL

                            // Firestore에 저장
                            let designerRef = Firestore.firestore().collection("designers").document(userAuth.currentDesignerID ?? "")
                            designerRef.updateData(["imageURLString": uploadedImageURL])
                        } else {
                            print("이미지 업로드 실패")
                        }
                    }
                }
            })
        }
    }

    // 프로필 이미지 선택 및 표시 섹션
    private func profileImageSection() -> some View {
        Group {
            if selectedPhotoURL.isEmpty {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .padding([.top, .bottom])
                    .overlay(
                        ZStack {
                            Circle()
                                .trim(from: 0.07, to: 0.43)
                                .fill(Color(white: 0.2))
                                .frame(width: 80)
                            Text("편집")
                                .font(.system(size: 13))
                                .foregroundStyle(.white)
                                .offset(y: 27)
                        }
                    )
                    .onTapGesture(perform: {
                        isShowingPhotoPicker.toggle()
                    })
            } else {
                AsyncImage(url: URL(string: selectedPhotoURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding([.top, .bottom])
                        .overlay(
                            ZStack {
                                Circle()
                                    .trim(from: 0.07, to: 0.43)
                                    .fill(Color(white: 0.2))
                                    .frame(width: 80)
                                Text("편집")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.white)
                                    .offset(y: 27)
                            }
                        )
                        .onTapGesture(perform: {
                            isShowingPhotoPicker.toggle()
                        })
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    DMProfileEditView()
        .environmentObject(UserAuth())
        .environmentObject(DMProfileViewModel.shared)
}
