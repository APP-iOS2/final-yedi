//
//  CMProfileView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

/// 고객 프로필 메인 뷰
struct CMProfileView: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var profileViewModel: CMProfileViewModel
    
    @State private var clientPhotoURL: String = ""
    @State private var clientName: String = ""
    @State private var clientGender: String = ""
    @State private var clientBirthDate: String = ""
    @State private var clientPhoneNumber: String = ""
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    // MARK: - 프로필 정보
                    VStack(alignment: .leading) {
                        Text("\(clientName)님")
                        Text("오늘도 빛나는 하루 보내세요")
                    }
                    .font(.system(size: 21, weight: .bold))
                    Spacer()
                    
                    // MARK: - 프로필 이미지
                    if clientPhotoURL.isEmpty {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                    } else {
                        DMAsyncImage(url: clientPhotoURL)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                // MARK: - 프로필 수정 버튼
                NavigationLink {
                    CMProfileEditView(
                        clientPhotoURL: $clientPhotoURL,
                        clientName: $clientName,
                        clientGender: $clientGender,
                        clientBirthDate: $clientBirthDate,
                        clientPhoneNumber: $clientPhoneNumber
                    )
                } label: {
                    Text("정보 수정")
                        .frame(width: 350, height: 40)
                        .background(.black)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 5))
                        .padding(.bottom, 40)
                }
                
                // MARK: - 고객 세그먼티드 컨트롤 뷰
                CMSegmentedControl()
            }
        }
        .padding([.leading, .trailing], 5)
        .onAppear {
            // MARK: - 프로필 정보 패치
            Task {
                await profileViewModel.fetchClientProfile(userAuth: userAuth)
                
                clientPhotoURL = profileViewModel.client.profileImageURLString
                clientName = profileViewModel.client.name
                clientGender = profileViewModel.client.gender
                clientBirthDate = profileViewModel.client.birthDate
                clientPhoneNumber = profileViewModel.client.phoneNumber
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CMSettingsView()
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CMProfileView()
            .environmentObject(UserAuth())
            .environmentObject(CMProfileViewModel())
    }
}
