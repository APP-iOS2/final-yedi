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
    
    @State private var isTappedOpenLicense: Bool = false
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
                    Text("1.0.0")
                }
                Divider()
                    .frame(width: 360)
                    .background(Color.systemFill)
                    .padding([.top, .bottom], 10)
                
                // MARK: - 개발자 정보 섹션
                VStack {
                    HStack {
                        Text("개발자 정보")
                        Spacer()
                    }
                }
                Divider()
                    .frame(width: 360)
                    .background(Color.systemFill)
                    .padding([.top, .bottom], 10)
                
                // MARK: - 오픈소스 라이선스 섹션
                VStack {
                    HStack {
                        Text("오픈소스 라이선스")
                        Spacer()
                    }
                    
                    if isTappedOpenLicense {
                        OpenLicenseView()
                    }
                }
                .onTapGesture {
                    isTappedOpenLicense.toggle()
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
                            Text("rofxnaos@gmail.com로 문의주세요.")
                                .font(.subheadline)
                                .accentColor(Color.primaryLabel)
                                .padding(.leading)
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
            .padding()
            
            Spacer()
            
            // MARK: - 로그아웃, 계정 삭제 버튼 섹션
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

/// 오픈소스 라이선스 섹션 컨텐츠
struct OpenLicenseView: View {
    // MARK: - Properties
    /// Firebase 라이선스 탭 여부를 나타내는 Bool타입 변수
    @State private var isTappedFirebaseLicense: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                Text("Firebase (10.15.0)")
                    .font(.subheadline)
                Spacer()
            }
            .onTapGesture {
                isTappedFirebaseLicense.toggle()
            }
            
            if isTappedFirebaseLicense {
                ScrollView {
                    Text("\(readTextFile(filename: "LICENSE.txt"))")
                        .font(.subheadline)
                }
            }
        }
        .padding([.top, .leading, .trailing])
    }
        
    /// .txt 파일을 읽어오는 함수
    /// - filename: 파일 이름을 String 타입으로 넘김
    func readTextFile(filename: String) -> String {
        guard let path = Bundle.main.path(forResource: filename, ofType: nil) else { return "" }
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            return "Error reading text file: \(error.localizedDescription)"
        }
    }
}

#Preview {
    NavigationStack {
        CMSettingsView()
    }
}
