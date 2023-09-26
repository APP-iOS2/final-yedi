//
//  ChatRoomView.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//

import SwiftUI

struct ChatRoomView: View {
    private var name: String = "김윤지"
    @State private var inputText: String = ""
    
    private var isInputTextEmpty: Bool {
        inputText.isEmpty ? true : false
    }
    
    var sampleChattingList: ChatRoom = ChatRoom(
        textBubbles: [
            TextBubble(content: "안녕하세요.", date: "2023.01.01", sender: "김윤지"),
            TextBubble(content: "안녕하세요. 상대방이 보낸 텍스트 버블 테스트입니다. 텍스트 버블 테스트입니다.", date: "2023.01.01", sender: "디자이너 수"),
        ],
        imageBubbles: [
            ImageBubble(imagePath: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2370&q=80", date: "2023.01.02", sender: "김윤지"),
            ImageBubble(imagePath: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2487&q=80", date: "2023.01.02", sender: "디자이너 수")
        ],
        boardBubbles: [
            BoardBubble(content: "게시물 버블 테스트", imagePath: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2487&q=80", date: "2023.01.04", sender: "김윤지")
        ]
    )
    
    var body: some View {
        VStack(spacing: 0) {
            chatScroll
            inputchatTextField
        }
        .navigationTitle("디자이너 수")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var chatScroll: some View {
        ScrollView {
            ForEach(sampleChattingList.boardBubbles!, id: \.sender) { chat in
                var isMyChat: Bool {
                    chat.sender == name ? true : false
                }
                
                HStack {
                    isMyChat ? Spacer() : nil
                    
                    HStack(alignment: .top) {
                        if !isMyChat {
                            VStack {
                                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2487&q=80")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .background(.gray)
                                        .clipShape(Circle())
                                        .frame(height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        
//                        Text("\(chat.content)")
//                            .chatBubbleModifier(isMyChat)
                        
//                        ImageBubbleCell(imageBubble: chat)
                        
                        BoardBubbleCell(boardBubble: chat, isMyChat: isMyChat)
                    }
                    
                    isMyChat ? nil: Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
            }
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        }
        .rotationEffect(Angle(degrees: 180))
        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
    }
    
    private var inputchatTextField: some View {
        HStack {
            Button(action: {
                // action...
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.gray)
            })
            
            TextField("메시지를 입력해주세요.", text: $inputText)
                .textFieldStyle(.roundedBorder)
            
            Button(action: {
                if !isInputTextEmpty {
                    let newTextBubble = TextBubble(content: inputText, date: Date().description, sender: name)
                    inputText = ""
                }
            }, label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(isInputTextEmpty ? .gray : .primary)
            })
            .disabled(isInputTextEmpty)
        }
        .padding()
        .background(.gray.opacity(0.4))
    }
}

#Preview {
    NavigationStack {
        ChatRoomView()
    }
}
