//
//  ChatRoomView.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//

import SwiftUI

struct ChatRoomView: View {

    // temp properties
    @ObservedObject var chattingVM = ChattingViewModel()
    var name: String = "customerUser1"
    var chatRoomId: String
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var inputText: String = ""
    @State private var isShowingUtilityMenu: Bool = false
    
    private var userId: String {
//        userAuth.currentDesignerID ?? "customerUser1" // issue
        "customerUser1"
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
        .navigationTitle("디자이너 수")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            chattingVM.chatRoomId = chatRoomId
            chattingVM.fetchChattingBubble(chatRoomId: chatRoomId)
        }
    }
    
    private var chatScroll: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(chattingVM.chattings) { chat in
                    var isMyBubble: Bool {
                        chat.sender == userId ? true : false
                    }
                    BubbleCell(chat: chat, messageType: chat.messageType, isMyBubble: isMyBubble)
                }
                .rotationEffect(Angle(degrees: 180))
                .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            }
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            .onReceive(chattingVM.$lastBubbleId) { id in
                withAnimation {
                    proxy.scrollTo(id, anchor: .bottom)
                }
            }
        }
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
                RoundedRectangle(cornerRadius: 4)
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

#Preview {
    NavigationStack {
        ChatRoomView(chatRoomId: "C314A8A6-A495-4023-882B-07D2902917C0")
    }
}
