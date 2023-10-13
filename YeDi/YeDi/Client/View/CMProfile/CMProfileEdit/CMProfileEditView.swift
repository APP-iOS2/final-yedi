//
//  CMProfileEditView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/26.
//

import SwiftUI
import PhotosUI

struct CMProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userAuth: UserAuth
    
    @EnvironmentObject var profileViewModel: CMProfileViewModel
    
    @State private var selectedPhotoURL: String = ""
    @State private var isShowingPhotoPicker: Bool = false
    
    @State private var clientName: String = ""
    @State private var clientGender: String = ""
    @State private var clientBirthDate: String = ""
    
    @State private var accountEmail: String = ""
    @State private var accountPhoneNumber: String = ""
    
    var body: some View {
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
            }
            
            Section {
                CMAccountInfoEditView(
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
                if let clientId = userAuth.currentClientID {
                    let newClient = Client(
                        id: clientId,
                        name: clientName,
                        email: accountEmail,
                        profileImageURLString: selectedPhotoURL,
                        phoneNumber: accountPhoneNumber,
                        gender: clientGender,
                        birthDate: clientBirthDate,
                        favoriteStyle: "",
                        chatRooms: []
                    )
                    Task {
                        await profileViewModel.updateClientProfile(userAuth: userAuth, client: newClient)
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
                await profileViewModel.fetchClientProfile(userAuth: userAuth)
            }
            
            selectedPhotoURL = profileViewModel.client.profileImageURLString
            
            clientName = profileViewModel.client.name
            clientGender = profileViewModel.client.gender
            clientBirthDate = profileViewModel.client.birthDate
            
            accountEmail = profileViewModel.client.email
            accountPhoneNumber = profileViewModel.client.phoneNumber
        }
        .sheet(isPresented: $isShowingPhotoPicker, content: {
            PhotoPicker { imageURL in
                selectedPhotoURL = imageURL.absoluteString
            }
        })
    }
}

#Preview {
    CMProfileEditView()
        .environmentObject(UserAuth())
        .environmentObject(CMProfileViewModel())
}
