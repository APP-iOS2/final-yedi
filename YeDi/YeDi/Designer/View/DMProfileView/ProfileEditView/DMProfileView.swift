//
//  DMProfileView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct DMProfileView: View {
    @EnvironmentObject var userAuth: UserAuth
    @StateObject var profileVM: DMProfileViewModel = DMProfileViewModel.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    // 디자이너 프로필 사진
                    if let url = URL(string: profileVM.designer.imageURLString ?? "") {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            case .failure(_):
                                defaultProfileImage()
                            case .empty:
                                ProgressView()
                            @unknown default:
                                defaultProfileImage()
                            }
                        }
                        .padding(.trailing, 20)  // 사진과 텍스트 간의 간격을 조절
                    } else {
                        defaultProfileImage()
                            .padding(.trailing, 20)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(profileVM.designer.rank.rawValue) \(profileVM.designer.name)")  // 디자이너 이름과 직급
                            .font(.system(size: 20, weight: .bold))
                        Text(profileVM.designer.description ?? "자기소개가 없습니다.")  // 자기소개
                            .font(.subheadline)
                        Text("팔로워: \(profileVM.designer.followerCount)")  // 팔로워 수
                            .font(.subheadline)
                    }
                    
                    Spacer()
                }
                .padding([.leading], 20)  // HStack의 전체 왼쪽 패딩을 조절
                
                
                // 샵 정보
                VStack(alignment: .leading) {
                    Text(profileVM.shop.shopName)  // 샵 이름
                        .font(.headline)
                    Text(profileVM.shop.headAddress)  // 샵 위치
                        .font(.subheadline)
                    Divider()
                    Text("휴무일: \(profileVM.shop.closedDays.joined(separator: ", "))")  // 휴무일 정보
                        .font(.subheadline)
                }
                .padding()
                
                // 프로필 편집으로 이동하는 버튼
                NavigationLink {
                    DMProfileEditView()
                        .environmentObject(profileVM)  // ViewModel 전달
                } label: {
                    Text("프로필 편집")
                        .frame(width: 350, height: 40)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
            .padding([.leading, .trailing], 5)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        // TODO: 알림 뷰로 이동
                        Text("Notifications")
                    } label: {
                        Image(systemName: "bell")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        // TODO: 설정 뷰로 이동 & 임시 로그아웃 버튼
                        Button {
                            userAuth.signOut()
                        } label: {
                            Text("로그아웃")
                        }
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.black)
                    }
                }
            }
            .onAppear {
                // 디자이너 정보가 변경되지 않았다면 로딩하지 않음
                if profileVM.designer.id == nil {
                    Task {
                        await profileVM.fetchDesignerProfile(userAuth: userAuth)
                    }
                }
                
                // 샵 정보가 변경되지 않았다면 로딩하지 않음
                if profileVM.shop.shopName.isEmpty {
                    Task {
                        await profileVM.fetchShopInfo(userAuth: userAuth)
                    }
                }
                
                // 현재 사용자의 유형에 따라 적절한 ID를 가져옵니다.
                let designerUID: String?
                switch userAuth.userType {
                case .client:
                    designerUID = userAuth.currentClientID
                case .designer:
                    designerUID = userAuth.currentDesignerID
                case .none:
                    designerUID = nil
                }

                // UID 확인 후 팔로워 수 업데이트
                if let designerUID = designerUID, !designerUID.isEmpty {
                    Task {
                        await profileVM.updateFollowerCountForDesigner(designerUID: designerUID)
                    }
                } else {
                    print("디자이너 UID가 유효하지 않습니다.")
                }
            }
        }
    }
     
     // 기본 프로필 이미지를 반환하는 함수
     func defaultProfileImage() -> some View {
         return Image(systemName: "person.circle.fill")
             .resizable()
             .aspectRatio(contentMode: .fill)
             .frame(width: 80, height: 80)
             .clipShape(Circle())
     }
 }

 #Preview {
     NavigationView {
         DMProfileView()
             .environmentObject(UserAuth())
     }
 }
