//
//  ChattingListRoomView.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/26.
//

import SwiftUI
import Firebase

struct ChattingListRoomView: View {
    @EnvironmentObject var userAuth: UserAuth
    @ObservedObject var chattingListRoomViewModel = ChattingListRoomViewModel()
    
    var body: some View {
        VStack {
            if chattingListRoomViewModel.chattingRooms.isEmpty {
                Text("채팅 내역이 없습니다.")
                    .foregroundStyle(.gray)
            } else {
                List {
                    ForEach(chattingListRoomViewModel.getOrderedChatRooms(), id: \.id) { chattingRoom in
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
                                
                                if let recentMessage =  chattingRoom.chattingBubles?.first {
                                    Text(recentMessage.content ?? "메세지가 비어있습니다.")
                                        .foregroundStyle(.gray)
                                        .lineLimit(1)
                                    
                                    Text("날짜 : \(recentMessage.date)")
                                        .font(.caption2)
                                        .foregroundStyle(.gray)
                                } else {
                                    Text("메세지가 존재하지 않습니다")
                                        .foregroundStyle(.gray)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("채팅")
               
            }
        }
        .onAppear {
            chattingListRoomViewModel.fetchChattingList(login: userAuth.userType)
        }
    }
}

#Preview {
    ChattingListRoomView()
}
