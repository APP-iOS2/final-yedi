//
//  CMSettingsView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

/// 고객 설정 뷰
struct CMSettingsView: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var isTappedDeveloperInfo: Bool = false
    @State private var isTappedEmailInquiry: Bool = false
    
    @State private var isShowingSignOutAlert: Bool = false
    @State private var isShowingDeleteClientAccountAlert: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            VStack(spacing: 5) {
                // MARK: - 앱 버전 섹션
                HStack {
                    Text("앱 버전")
                    Spacer()
                    Text("1.0.0.")
                }
                Divider()
                    .frame(width: 360)
                    .background(Color.systemFill)
                    .padding([.top, .bottom], 10)
                // MARK: - 개발자 정보 섹션
                VStack {
                    HStack {
                        Text("저작권자 정보")
                        Spacer()
                    }
                    
                    if isTappedDeveloperInfo {
                        HStack {
                            Text("Copyright 2023. 루예삐오 all rights deserved.")
                            Spacer()
                        }
                        .padding(.top, 5)
                    }
                }
                .onTapGesture {
                    isTappedDeveloperInfo.toggle()
                }
                Divider()
                    .frame(width: 360)
                    .padding([.top, .bottom], 10)
                // MARK: - 오픈소스 라이선스 섹션
                HStack {
                    Text("오픈소스 라이선스")
                    Spacer()
                }
                Divider()
                    .frame(width: 360)
                    .background(Color.systemFill)
                    .padding([.top, .bottom], 10)
                // MARK: - 이메일 문의 섹션
                VStack {
                    HStack {
                        Text("이메일 문의")
                        Spacer()
                    }
            
                    if isTappedEmailInquiry {
                        HStack {
                            Text("rofxnaos@gmail.com")
                                .onTapGesture {
                                    let clipboard = UIPasteboard.general
                                    clipboard.string = "rofxnaos@gmail.com"
                                }
                            Spacer()
                        }
                        .padding(.top, 5)
                    }
                }
                .onTapGesture {
                    isTappedEmailInquiry.toggle()
                }
                Divider()
                    .frame(width: 360)
                    .padding([.top, .bottom], 10)
            }
            .padding([.leading, .trailing, .bottom])
            
            Spacer()
            
            Group {
                Button {
                    isShowingSignOutAlert.toggle()
                } label: {
                    Text("로그아웃")
                }
                .buttonModifier(.mainColor)
                
                Button(role: .destructive) {
                    isShowingDeleteClientAccountAlert.toggle()
                } label: {
                    Text("계정 삭제")
                }
                .buttonModifier(.red)
            }
            .padding([.leading, .trailing])
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton(color: nil, action: {})
            }
        }
        .alert("로그아웃하시겠습니까?", isPresented: $isShowingSignOutAlert) {
            Button(role: .cancel) {
                isShowingSignOutAlert.toggle()
            } label: {
                Text("취소")
            }
            Button(role: .destructive) {
                userAuth.signOut()
                isShowingSignOutAlert.toggle()
            } label: {
                Text("로그아웃")
            }
        }
        .alert("계정을 삭제하시겠습니까?", isPresented: $isShowingDeleteClientAccountAlert) {
            Button(role: .cancel) {
                isShowingDeleteClientAccountAlert.toggle()
            } label: {
                Text("취소")
            }
            Button(role: .destructive) {
                userAuth.deleteClientAccount()
                isShowingDeleteClientAccountAlert.toggle()
            } label: {
                Text("삭제")
            }
        }
    }
}

#Preview {
    NavigationStack {
        CMSettingsView()
    }
}
