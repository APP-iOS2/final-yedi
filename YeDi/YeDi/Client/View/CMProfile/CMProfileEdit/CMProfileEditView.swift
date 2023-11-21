//
//  CMProfileEditView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/26.
//

import SwiftUI
import PhotosUI

/// 고객 프로필 편집 메인 뷰
struct CMProfileEditView: View {
    // MARK: - Properties
    /// 현재 프레젠테이션 dismiss용 환경 변수
    @Environment(\.dismiss) var dismiss
    
    /// 유저 Auth 관리 뷰 모델
    @EnvironmentObject var userAuth: UserAuth
    /// 고객 프로필 뷰 모델
    @EnvironmentObject var profileViewModel: CMProfileViewModel
    
    @Binding var clientName: String
    @Binding var clientGender: String
    @Binding var clientBirthDate: String
    @Binding var clientEmail: String
    @Binding var clientPhoneNumber: String
    @Binding var clientPhotoURL: String
    
    /// 포토 피커용 Bool 타입 변수
    @State private var isShowingPhotoPicker: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - 프로필 이미지 수정
            Group {
                if clientPhotoURL.isEmpty {
                    Text(String(clientName.first ?? "U").capitalized)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(width: 80, height: 80)
                        .background(Circle().fill(Color.quaternarySystemFill))
                        .foregroundColor(Color.primaryLabel)
                        .padding([.top, .bottom])
                } else {
                    AsnycCacheImage(url: clientPhotoURL)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding([.top, .bottom])
                }
            }
            .overlay {
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
            }
            .onTapGesture(perform: {
                isShowingPhotoPicker.toggle()
            })
            
            // MARK: - 회원 정보 수정
            Section {
                CMClientInfoEditView(
                    clientName: $clientName,
                    clientGender: $clientGender,
                    clientBirthDate: $clientBirthDate
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
                    .background(Color.systemFill)
            }
            
            // MARK: - 계정 정보 수정
            Section {
                CMAccountInfoEditView(
                    clientEmail: $clientEmail,
                    clientPhoneNumber: $clientPhoneNumber
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
                    .background(Color.systemFill)
            }
            
            Spacer()
            
            // MARK: - 고객 프로필 저장 버튼
            Button(action: {
                if let clientId = userAuth.currentClientID {
                    let updatedClient = Client(
                        id: clientId,
                        name: clientName,
                        email: profileViewModel.client.email,
                        profileImageURLString: clientPhotoURL,
                        phoneNumber: clientPhoneNumber,
                        gender: clientGender,
                        birthDate: clientBirthDate,
                        favoriteStyle: profileViewModel.client.favoriteStyle,
                        chatRooms: profileViewModel.client.chatRooms
                    )
                    
                    Task {
                        await profileViewModel.updateClientProfile(userAuth: userAuth, client: updatedClient)
                        dismiss()
                    }
                }
            }, label: {
                Text("저장")
                    .frame(width: screenWidth * 0.85, height: 30)
            })
            .buttonStyle(.borderedProminent)
            .tint(.mainColor)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton(color: nil, action: {})
            }
        }
        .sheet(isPresented: $isShowingPhotoPicker, content: {
            PhotoPicker { imageURL in
                clientPhotoURL = imageURL.absoluteString
            }
        })
    }
}

#Preview {
    CMProfileEditView(
        clientName: .constant(""),
        clientGender: .constant(""),
        clientBirthDate: .constant(""),
        clientEmail: .constant(""),
        clientPhoneNumber: .constant(""),
        clientPhotoURL: .constant("")
    )
    .environmentObject(UserAuth())
    .environmentObject(CMProfileViewModel())
}
