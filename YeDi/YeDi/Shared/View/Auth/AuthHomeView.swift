//
//  AuthHomeView.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/06.
//

import SwiftUI

struct AuthHomeView: View {
    @State var selectedSegment: UserType = .client
    let segments: [UserType] = [.client, .designer]
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                welcomeMessage
                
                segmentedLoginView
                
                Divider()
                    .foregroundStyle(Color.separator)
                    .padding(.horizontal)
                
                navigationLinkView
                
                Spacer()
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var welcomeMessage: some View {
            HStack {
                VStack(alignment: .leading) {
                    YdIconView(height: 55)

                    switch selectedSegment {
                    case .client:
                        Text("안녕하세요, 회원님!")
                    case .designer:
                        Text("안녕하세요, 디자이너님!")
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.bottom, 80)
        }
    
    private var segmentedLoginView: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(segments, id: \.self) { segment in
                    Button {
                        selectedSegment = segment
                    } label: {
                        VStack {
                            Text(segment.rawValue)
                                .foregroundStyle(selectedSegment == segment ? Color.primaryLabel : Color.secondaryLabel)
                            Rectangle()
                                .fill(selectedSegment == segment ? Color.primary : Color.secondarySystemFill)
                                .frame(height: selectedSegment == segment ? 2 : 1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding([.bottom, .horizontal])
            
            LoginView(userType: selectedSegment)
        }
        .padding(.bottom, 50)
    }
    
    private var navigationLinkView: some View {
        HStack {
            NavigationLink {
                ResetPasswordView()
            } label: {
                Text("비밀번호 찾기")
            }
            
            Text("|")
                .foregroundStyle(Color.gray5)
            
            switch selectedSegment {
            case .client:
                NavigationLink {
                    RegisterView(userType: selectedSegment)
                } label: {
                    Text("고객 회원가입")
                }
            case .designer:
                NavigationLink {
                    RegisterView(userType: selectedSegment)
                } label: {
                    Text("디자이너 회원가입")
                }
            }
            
        }
        .padding(.vertical)
    }
}

#Preview {
    AuthHomeView()
}
