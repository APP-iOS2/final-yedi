//
//  CMProfileView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct CMProfileView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var profileViewModel: CMProfileViewModel
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(profileViewModel.client.name)님")
                        Text("오늘도 빛나는 하루 보내세요")
                    }
                    .font(.system(size: 20, weight: .bold))
                    Spacer()
                    
                    if profileViewModel.client.profileImageURLString == "" {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                    } else {
                        AsyncImage(url: URL(string: profileViewModel.client.profileImageURLString)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .id(profileViewModel.client.profileImageURLString)
                    }
                }
                .padding()
                
                NavigationLink {
                    CMProfileEditView()
                } label: {
                    Text("정보 수정")
                        .frame(width: 350, height: 40)
                        .background(.black)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 5))
                        .padding(.bottom, 40)
                }
                
                // TODO: 임시 리뷰 작성 버튼
                NavigationLink {
                    CMReviewCreateMainView()
                } label: {
                    Text("리뷰 작성하기")
                }
                
                CMSegmentedControl(profileViewModel: profileViewModel)
                
                Spacer()
            }
        }
        .padding([.leading, .trailing], 5)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CMNotificationView()
                } label: {
                    Image(systemName: "bell")
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CMSettingsView()
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            Task {
                await profileViewModel.fetchClientProfile(userAuth: userAuth)
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
