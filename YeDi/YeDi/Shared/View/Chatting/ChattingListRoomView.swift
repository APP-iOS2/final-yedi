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
        if chattingListRoomViewModel.chattingRooms.isEmpty {
            Text("채팅이 없습니다.")
                .foregroundStyle(.gray)
        } else {
            List {
                ForEach(chattingListRoomViewModel.chattingRooms, id: \.id) { chattingRoom in
                    HStack(alignment: .center) {
                        NavigationLink(destination: ChatRoomView(chatRoomId: chattingRoom.id), label: {
                            EmptyView()
                        })
                        .opacity(0)
                        .frame(width: 0, height: 0)
                        .background()
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .cornerRadius(10)
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("디자이너 수")
                                .font(.title3.bold())
                            
                            if let recentMessage =  chattingListRoomViewModel.getLastMessage(chatRoom: chattingRoom){
                                Text(recentMessage.content ?? "메세지가 비어있습니다.")
                                    .foregroundStyle(.gray)
                                    .lineLimit(1)
                                
                                Text("날짜 : \(recentMessage.date)")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("채팅")
            .onAppear {
                chattingListRoomViewModel.fetchChattingList()
                print("============= chatting list")
                print(chattingListRoomViewModel.chattingRooms)
            }
        }
    }
}

#Preview {
    ChattingListRoomView()
}
