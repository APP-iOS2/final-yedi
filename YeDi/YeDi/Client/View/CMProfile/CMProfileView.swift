//
//  CMProfileView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct CMProfileView: View {
    @EnvironmentObject var userAuth: UserAuth
    @StateObject var profileVM: CMProfileViewModel = CMProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(profileVM.client.name)님")
                        Text("오늘도 빛나는 하루 보내세요")
                    }
                    .font(.system(size: 20, weight: .bold))
                    Spacer()
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                }
                .padding()
                
                NavigationLink {
                    CMProfileEditView()
                        .environmentObject(profileVM)
                } label: {
                    Text("정보 수정")
                        .frame(width: 350, height: 40)
                        .background(.black)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 5))
                        .padding(.bottom, 40)
                }
                
                CMSegmentedControl()
                
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
                await profileVM.fetchClientProfile(userAuth: userAuth)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CMProfileView()
            .environmentObject(UserAuth())
    }
}
