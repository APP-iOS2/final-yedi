//
//  ChatRoomView.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//

import SwiftUI

struct ChatRoomView: View {
    var chatRoomId: String
//    var userProfile: ChatListUserInfo
    
    @StateObject var chattingVM = ChattingViewModel()
    @ObservedObject var chattingListRoomViewModel = ChattingListRoomViewModel()
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.dismiss) var dismiss
    
    @State private var inputText: String = ""
    @State private var isShowingUtilityMenu: Bool = false
    
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
        return ChatListUserInfo(name: "닉네임 오류", profileImageURLString: "")
    }
    
    private var isInputTextEmpty: Bool {
        inputText.isEmpty ? true : false
    }
    
    var body: some View {
        VStack(spacing: 0) {
            chatScroll
            if isShowingUtilityMenu {
                ChatUtilityMenuView(chattingVM: chattingVM, userID: userId)
            }
            inputchatTextField
        }
        .onAppear {
            chattingVM.chatRoomId = chatRoomId
            chattingVM.firstChattingBubbles()
            chattingVM.fetchUserInfo(login: userAuth.userType!, chatRooms: chatRoomId)
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
            Button {
                self.chattingVM.removeListener()
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.black)
            }
            HStack(alignment: .center) {
                DMAsyncImage(url: userProfile.profileImageURLString, placeholder: Image(systemName: "person.circle.fill"))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 20)
                Text(userProfile.name)
                    .lineLimit(1)
            }
        }
    }
    
    private var chatScroll: some View {
        ScrollView {
            VStack{
                Button {
                    chattingVM.fetchMoreChattingBubble()
                } label: {
                    Text("지난 대화보기")
                }
                ForEach(chattingVM.chattings) { chat in
                    var isMyBubble: Bool {
                        chat.sender == userId ? true : false
                    }
                    BubbleCell(chat: chat, isMyBubble: isMyBubble)
                        .onAppear {
                            if !isMyBubble {
                                chattingVM.getReceivedBubbleId(chatRoomId: chatRoomId, sender: chat.sender)
                            }
                        }
                }
            }
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        }
        .rotationEffect(Angle(degrees: 180))
        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        .onTapGesture {
            hideKeyboard()
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
                
                Button(action: {
                    if !isInputTextEmpty {
                        chattingVM.sendTextBubble(content: inputText, sender: userId)
                        inputText = ""
                    }
                }, label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundColor(isInputTextEmpty ? .gray : .black)
                })
                .disabled(isInputTextEmpty)
            }
            .padding(.leading)
            .padding([.trailing, .vertical], 8)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
            }
            
        }
        .padding()
        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
