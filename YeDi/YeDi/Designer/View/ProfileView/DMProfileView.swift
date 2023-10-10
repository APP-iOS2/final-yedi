//
//  DMProfileView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct DMProfileView: View {
    @EnvironmentObject var userAuth: UserAuth  // 사용자 인증 정보
    @StateObject var profileVM: DMProfileViewModel = DMProfileViewModel()  // 프로필 뷰 모델
    
    var body: some View {
        NavigationStack {
            VStack {
                // 디자이너 이름과 자기소개
                VStack(alignment: .leading) {
                    Text("원장 \(profileVM.designer.name)")  // 디자이너 이름
                        .font(.system(size: 20, weight: .bold))
                    Text(profileVM.designer.description ?? "자기소개가 없습니다.")  // 자기소개
                        .font(.subheadline)
                    Text("팔로워: \(profileVM.designer.followerCount)")  // 팔로워 수
                        .font(.subheadline)
                }
                .padding()
                
                // 샵 정보
                VStack(alignment: .leading) {
                    Text(profileVM.shop.shopName)  // 샵 이름
                        .font(.headline)
                    Text(profileVM.shop.headAddress)  // 샵 위치
                        .font(.subheadline)
                    Divider()
                    Text("휴무일: 월요일")  // 휴무일 정보
                        .font(.subheadline)
                }
                .padding()
                
                // 프로필 편집으로 이동하는 버튼
                NavigationLink {
                    DMProfileEditView()  // 프로필 편집 뷰로 이동
                        .environmentObject(profileVM)
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
                Task {
                    await profileVM.fetchDesignerProfile(userAuth: userAuth)  // 디자이너 프로필 정보 가져오기
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DMProfileView()
            .environmentObject(UserAuth())
    }
}
