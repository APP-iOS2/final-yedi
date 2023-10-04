//
//  ChatRoomView.swift
//  YeDi
//
//  Created by yunjikim on 2023/09/25.
//

import SwiftUI
import Combine

struct ChatRoomView: View {
    // temp properties
    @ObservedObject var temp = TempChatbubbleStore(chatRoomID: "C314A8A6-A495-4023-882B-07D2902917C0")
    private var name: String = "customerUser1"
    
    @State private var inputText: String = ""
    @State private var isShowingUtilityMenu: Bool = false
    
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
        .onAppear {
            temp.fetchChattingBubble(chatRomsId: "C314A8A6-A495-4023-882B-07D2902917C0")
        }
    }
    
    private var chatScroll: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(temp.chattings) { chat in
                    var isMyBubble: Bool {
                        chat.sender == name ? true : false
                    }
                    BubbleCell(chat: chat, messageType: chat.messageType, isMyBubble: isMyBubble)
                }
                .rotationEffect(Angle(degrees: 180))
                .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            }
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            .onReceive(temp.$lastBubbleId) { id in
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
                        temp.sendTextBubble(content: inputText, sender: name)
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
        ChatRoomView()
    }
}
