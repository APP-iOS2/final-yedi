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
    /// 유저 Auth 관리 뷰 모델
    @EnvironmentObject var userAuth: UserAuth
    /// 고객 프로필 뷰 모델
    @EnvironmentObject var profileViewModel: CMProfileViewModel
    
    @State private var clientName: String = ""
    @State private var clientGender: String = ""
    @State private var clientBirthDate: String = ""
    @State private var clientEmail: String = ""
    @State private var clientPhoneNumber: String = ""
    @State private var clientPhotoURL: String = ""
    
    @State private var selectedSegment: String = "찜한 게시물"
    
    private let segments: [String] = ["찜한 게시물", "팔로잉", "리뷰"]
    
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
                        Text(String(clientName.first ?? "U").capitalized)
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(width: 60, height: 60)
                            .background(Circle().fill(Color.quaternarySystemFill))
                            .foregroundColor(Color.primaryLabel)
                            .offset(y: -5)
                    } else {
                        AsnycCacheImage(url: clientPhotoURL)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                // MARK: - 프로필 수정 버튼
                NavigationLink {
                    CMProfileEditView(
                        clientName: $clientName,
                        clientGender: $clientGender,
                        clientBirthDate: $clientBirthDate,
                        clientEmail: $clientEmail,
                        clientPhoneNumber: $clientPhoneNumber,
                        clientPhotoURL: $clientPhotoURL
                    )
                } label: {
                    Text("프로필 수정")
                        .frame(width: screenWidth * 0.9, height: 40)
                        .background(Color.primaryLabel)
                        .foregroundStyle(Color.myColor)
                        .clipShape(.rect(cornerRadius: 5))
                        .padding(.bottom, 40)
                }
                
                // MARK: - 세그먼티드 컨트롤
                HStack(spacing: 0) {
                    ForEach(segments, id: \.self) { segment in
                        Button(action: {
                            selectedSegment = segment
                        }, label: {
                            VStack {
                                Text(segment)
                                    .fontWeight(selectedSegment == segment ? .semibold : .medium)
                                    .foregroundStyle(Color.primaryLabel)
                                Rectangle()
                                    .fill(selectedSegment == segment ? Color.primaryLabel : .gray6)
                                    .frame(width: screenWidth / 3, height: 3)
                            }
                        })
                    }
                }
                .padding(.bottom, 5)
                
                // MARK: - 선택한 세그먼트에 따른 뷰
                switch selectedSegment {
                case "찜한 게시물":
                    CMLikedPostListView()
                case "팔로잉":
                    CMFollowingListView()
                case "리뷰":
                    CMReviewListView()
                default:
                    Text("")
                }
                
                Spacer()
            }
        }
        .padding([.leading, .trailing], 5)
        .onAppear {
            Task {
                await profileViewModel.fetchClientProfile(userAuth: userAuth)
                
                clientName = profileViewModel.client.name
                clientGender = profileViewModel.client.gender
                clientBirthDate = profileViewModel.client.birthDate
                clientEmail = profileViewModel.client.email
                clientPhoneNumber = profileViewModel.client.phoneNumber
                clientPhotoURL = profileViewModel.client.profileImageURLString
            }
        }
    }
}

#Preview {
    NavigationStack {
        CMProfileView()
            .environmentObject(UserAuth())
            .environmentObject(CMProfileViewModel())
            .environmentObject(CMReviewViewModel())
    }
}
