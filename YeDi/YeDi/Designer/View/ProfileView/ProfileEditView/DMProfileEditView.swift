//
//  DMProfileEditView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/10/05.
//

import SwiftUI
import PhotosUI
import Firebase

struct DMProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var profileViewModel: DMProfileViewModel
    
    @State private var selectedPhotoURL: String = ""
    @State private var isShowingPhotoPicker: Bool = false
    @State private var isShowingDatePicker: Bool = false
    
    @State private var designerName: String = ""
    @State private var designerRank: Rank = .Designer
    @State private var designerGender: String = ""
    @State private var designerBirthDate: String = ""
    
    @State private var accountEmail: String = ""
    @State private var accountPhoneNumber: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                if selectedPhotoURL == "" {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .padding([.top, .bottom])
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
                } else {
                    AsyncImage(url: URL(string: selectedPhotoURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding([.top, .bottom])
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
                    } placeholder: {
                        ProgressView()
                    }
                }
                
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
                
                Button(action: {
                    if let designerId = userAuth.currentDesignerID {
                        let newDesigner = Designer(
                            id: designerId,
                            name: designerName,
                            email: accountEmail,
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
                            await profileViewModel.updateDesignerProfile(userAuth: userAuth, designer: newDesigner)
                        }
                    }
                    dismiss()
                }, label: {
                    Text("저장")
                        .frame(width: 330, height: 30)
                })
                .buttonStyle(.borderedProminent)
                .tint(.black)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                Task {
                    await profileViewModel.fetchDesignerProfile(userAuth: userAuth)
                }
                
                selectedPhotoURL = profileViewModel.designer.imageURLString ?? ""
                
                designerName = profileViewModel.designer.name
                designerRank = profileViewModel.designer.rank
                designerGender = profileViewModel.designer.gender
                designerBirthDate = profileViewModel.designer.birthDate
                
                accountEmail = profileViewModel.designer.email
                accountPhoneNumber = profileViewModel.designer.phoneNumber
            }
            .sheet(isPresented: $isShowingPhotoPicker, content: {
                PhotoPicker { imageURL in
                    selectedPhotoURL = imageURL.absoluteString
                }
            })
        }
    }
}

#Preview {
    DMProfileEditView()
        .environmentObject(UserAuth())
        .environmentObject(DMProfileViewModel())
}
