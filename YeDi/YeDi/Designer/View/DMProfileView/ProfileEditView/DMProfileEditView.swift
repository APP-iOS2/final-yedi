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

// 디자이너의 프로필 수정 뷰
struct DMProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var profileViewModel: DMProfileViewModel
    
    // 디자이너 정보 상태 변수
    @State private var selectedPhotoURL: String = ""
    @State private var isShowingPhotoPicker: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var designerName: String = ""
    @State private var designerRank: Rank = .Designer
    @State private var designerGender: String = ""
    @State private var designerBirthDate: String = ""
    
    // 계정 정보 상태 변수
    @State private var accountEmail: String = ""
    @State private var accountPhoneNumber: String = ""
    
    // 샵 정보 상태 변수
    @State private var shopName: String = ""
    @State private var shopHeadAddress: String = ""
    @State private var shopSubAddress: String = ""

    // URL에서 이미지를 로드하는 함수
    private func imageFromURL(_ url: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print("URL을 UIImage로 변환하는 중 오류 발생:", error)
            return nil
        }
    }

    // Firebase Storage에 이미지 업로드하는 함수
    private func uploadImageToFirebaseStorage(_ image: UIImage, completion: @escaping (String?) -> Void) {
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
            VStack(spacing: 20) {
                // 프로필 이미지 선택 및 표시 섹션
                profileImageSection()
                
                // 디자이너 정보 수정 섹션
                designerInfoSection()
                
                // 계정 정보 수정 섹션
                accountInfoSection()
                
                // 변경 사항 저장 버튼
                saveChangesButton()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadData)
            .sheet(isPresented: $isShowingPhotoPicker, content: {
                photoPicker()
            })
        }
    }
    
    // 프로필 이미지 선택 및 표시 섹션
    private func profileImageSection() -> some View {
        Group {
            if selectedPhotoURL.isEmpty {
                defaultProfileImage()
            } else {
                asyncProfileImage()
            }
        }
    }
    
    // 기본 프로필 이미지 섹션
    private func defaultProfileImage() -> some View {
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
    }

    
    // 비동기로 로드되는 프로필 이미지 섹션
    private func asyncProfileImage() -> some View {
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

    
    // 디자이너 정보 수정 섹션
    private func designerInfoSection() -> some View {
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
            sectionHeader(title: "회원 정보")
        }
    }
    
    // 계정 정보 수정 섹션
    private func accountInfoSection() -> some View {
        Section {
            DMAccountInfoEditView(
                accountEmail: $accountEmail,
                accountPhoneNumber: $accountPhoneNumber
            )
        } header: {
            sectionHeader(title: "계정 정보")
        }
    }
    
    // 섹션 헤더
    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
                .padding(.leading)
            Spacer()
            Divider().frame(width: 360)
        }
    }
    
    // 변경 사항 저장 버튼
    private func saveChangesButton() -> some View {
        Button(action: saveProfileData, label: {
            Text("저장")
                .frame(width: 330, height: 30)
        })
        .buttonStyle(.borderedProminent)
        .tint(.black)
    }
    
    // 프로필 데이터 저장
    private func saveProfileData() {
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
                    // 데이터 저장 실패를 사용자에게 알리는 UI 로직
                }
            }
        }
    }
    
    // 데이터 로드
    private func loadData() {
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
    
    // 사진 선택기
    private func photoPicker() -> some View {
        PhotoPicker { selectedImageURL in
            guard let selectedImage = imageFromURL(selectedImageURL) else {
                // 이미지 변환 오류 처리
                return
            }

            uploadImageToFirebaseStorage(selectedImage) { uploadedImageURL in
                if let uploadedImageURL = uploadedImageURL {
                    selectedPhotoURL = uploadedImageURL

                    let designerRef = Firestore.firestore().collection("designers").document(userAuth.currentDesignerID ?? "")
                    designerRef.updateData(["imageURLString": uploadedImageURL])
                } else {
                    // 이미지 업로드 실패 메시지 출력
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

