//
//  ChattingListRoomView.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/26.
//

import SwiftUI
import Firebase

struct ChattingListRoomView: View {
    @ObservedObject var chattingListRoomViewModel = ChattingListRoomViewModel()
    var body: some View {
        VStack {
            Button(action: {chattingListRoomViewModel.fetchChattingList()}, label: {
                Text("Button")
            })
            List {
                ForEach(chattingListRoomViewModel.chattingRooms, id: \.id) { chattingRoom in
                    HStack(alignment: .center) {
                        NavigationLink { } label: {}
                            .opacity(0)
                            .frame(width: 0, height: 0)
                            .background()
                        Image(systemName: "person.circle")
                            .resizable()
                            .cornerRadius(10)
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("임시 닉네임")
                            if let recentMessage =  chattingListRoomViewModel.getLastMessage(chatRoom: chattingRoom){
                                Text(recentMessage.content ?? "메세지가 비어있습니다.")
                                Text("날짜 : \(recentMessage.date)")
                            }
                        }
                        Spacer()
                        
                    }
                }
                
            }
            .listStyle(.plain)
        }
        .navigationTitle("채팅")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
                chattingListRoomViewModel.fetchChattingList()
        }
    }
}

#Preview {
    ChattingListRoomView()
}
