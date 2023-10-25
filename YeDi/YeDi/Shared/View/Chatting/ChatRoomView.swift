//
//  ChatRoomView.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//

import SwiftUI

struct ChatRoomView: View {
    var chatRoomId: String
    
    @StateObject var chattingVM = ChattingViewModel()
    @ObservedObject var chattingListRoomViewModel = ChattingListRoomViewModel()
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var inputText: String = ""
    @State private var isShowingUtilityMenu: Bool = false
    @State private var lastBubbleId: String = ""
    
    @FocusState private var inputTextIsFocused: Bool
    
    private var userId: String {
        switch userAuth.userType {
        case .designer:
            return userAuth.currentDesignerID!
        case .client:
            return userAuth.currentClientID!
        case .none:
            return ""
        }
    }
    
    private var userProfile: ChatListUserInfo {
        if let profile = chattingVM.userProfile[chatRoomId] {
            return profile
        }
        return ChatListUserInfo(uid: "", name: "닉네임 오류", profileImageURLString: "")
    }
    
    private var isInputTextEmpty: Bool {
        inputText.isEmpty ? true : false
    }
    
    var body: some View {
        let _ = print("============= chat room : \(chatRoomId)")
        VStack(spacing: 0) {
            chatScroll
            inputchatTextField
            if isShowingUtilityMenu {
                ChatUtilityMenuView(userID: userId, designerID: userProfile.uid, chatRoomId: chatRoomId)
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            chattingVM.chatRoomId = chatRoomId
            chattingVM.fetchFirstChattingBubbles()
            chattingVM.fetchUserInfo(login: userAuth.userType!, chatRooms: chatRoomId)
        }
        .onChange(of: isShowingUtilityMenu) { _ in
            if isShowingUtilityMenu {
                hideKeyboard()
            }
        }
        .onChange(of: inputTextIsFocused) { _ in
            if inputTextIsFocused {
                isShowingUtilityMenu = false
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                toolbarProfileInfo
            }
        }
    }
    
    private var toolbarProfileInfo: some View {
        HStack {
            DismissButton(color: nil) {
                chattingVM.removeListener()
            }
            HStack(alignment: .center) {
                if userProfile.profileImageURLString.isEmpty {
                    Text(String(userProfile.name.first ?? " ").capitalized)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(Color.quaternarySystemFill))
                        .foregroundColor(Color.primaryLabel)
                } else {
                    DMAsyncImage(url: userProfile.profileImageURLString)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
                
                Text(userProfile.name)
                    .lineLimit(1)
            }
        }
    }
    
    private var chatScroll: some View {
        ScrollView {
            VStack{
                if chattingVM.anyMoreChats {
                    ZStack {
                        Divider()
                            .background(Color.separator.opacity(0.8))
                        
                        VStack {
                            Button {
                                chattingVM.fetchMoreChattingBubble()
                            } label: {
                                Text("지난 대화 보기")
                                    .font(.caption)
                                    .foregroundStyle(Color.tertiaryLabel)
                                    .padding(.horizontal)
                                    .padding(.vertical, 3)
                                    .background {
                                        Capsule()
                                            .fill(Color.tertiarySystemBackground.opacity(0.5))
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .background(Color.secondarySystemBackground)
                    }
                    .padding(.vertical)
                }
                
                ForEach(chattingVM.chattings) { chat in
                    var isMyBubble: Bool {
                        chat.sender == userId ? true : false
                    }
                    BubbleCell(chat: chat, isMyBubble: isMyBubble)
                        .id(chat.id)
                        .padding(.bottom, lastBubbleId == chat.id ? 10 : 0)
                        .onAppear {
                            if !isMyBubble {
                                chattingVM.getReceivedBubbleId(chatRoomId: chatRoomId, sender: chat.sender)
                            }
                        }
                }
                .onChange(of: chattingVM.chattings.count) { _ in
                    lastBubbleId = chattingVM.chattings.last?.id ?? ""
                }
            }
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        }
        .rotationEffect(Angle(degrees: 180))
        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        .background(Color.secondarySystemBackground)
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            hideKeyboard()
            withAnimation {
                isShowingUtilityMenu = false
            }
        }
    }
    
    private var inputchatTextField: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isShowingUtilityMenu.toggle()
                }
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.gray)
            })
            
            HStack {
                TextField("메시지를 입력해주세요.", text: $inputText, axis: .vertical)
                    .focused($inputTextIsFocused)
                
                Button(action: {
                    if !isInputTextEmpty {
                        chattingVM.sendTextBubble(content: inputText, sender: userId)
                        inputText = ""
                    }
                }, label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundColor(isInputTextEmpty ? .tertiarySystemFill : .subColor)
                })
                .disabled(isInputTextEmpty)
            }
            .padding(.leading, 5)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.secondarySystemBackground)
            }
            
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(Color.tertiarySystemBackground)
    }
}
