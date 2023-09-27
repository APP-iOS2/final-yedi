//
//  ChatRoomView.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//

import SwiftUI

struct ChatRoomView: View {
    @ObservedObject var temp = TempChatbubbleStore(chatRoomID: "C314A8A6-A495-4023-882B-07D2902917C0")
    
    private var name: String = "customerUser1"
    @State private var inputText: String = ""
    @State private var isShowingUtilityMenu: Bool = false
    
    @State private var offset: CGFloat = .zero
    
    private var isInputTextEmpty: Bool {
        inputText.isEmpty ? true : false
    }
    
    var body: some View {
        VStack(spacing: 0) {
            chatScroll
            if isShowingUtilityMenu {
                ChatUtilityMenuView()
            }
            inputchatTextField
        }
        .navigationTitle("디자이너 수")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            temp.fetchChattingBubble(chatRomsId: "C314A8A6-A495-4023-882B-07D2902917C0")
        }
    }
    
    private var chatScroll: some View {
        ScrollView {
            ForEach(temp.chattings) { chat in
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
                        
                        switch chat.messageType {
                        case .textBubble:
                            Text(chat.content ?? "")
                                .chatBubbleModifier(isMyChat)
                        case .imageBubble:
                            ImageBubbleCell(imagePath: chat.imagePath ?? "")
                        case .boardBubble:
                            BoardBubbleCell(boardBubble: chat, isMyChat: isMyChat)
                        }
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
                withAnimation {
                    isShowingUtilityMenu.toggle()
                }
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.gray)
            })
            
            TextField("메시지를 입력해주세요.", text: $inputText)
                .textFieldStyle(.roundedBorder)
            
            Button(action: {
                if !isInputTextEmpty {
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
