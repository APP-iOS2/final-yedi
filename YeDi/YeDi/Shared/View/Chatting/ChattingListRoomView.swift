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
    @EnvironmentObject var chattingListRoomViewModel : ChattingListRoomViewModel
    @State private var isEmptyChatRooms: Bool = false

    
    var body: some View {
        VStack {
            if isEmptyChatRooms {
                ProgressView()
                Text("채팅 내역이 없습니다.")
                    .foregroundStyle(.gray)
            } else {
                List {
                    ForEach(chattingListRoomViewModel.chattingRooms, id: \.id) { chattingRoom in
                        HStack(alignment: .center) {
                            NavigationLink(destination: ChatRoomView(chatRoomId: chattingRoom.id), label: {
                                Text("")
                            })
                            .opacity(0)
                            .frame(width: 0, height: 0)
                            .background()
                            
                            DMAsyncImage(url: chattingListRoomViewModel.userProfile[chattingRoom.id]?.profileImageURLString ?? "")
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(chattingListRoomViewModel.userProfile[chattingRoom.id]?.name ?? "닉네임 오류")
                                    .font(.title3.bold())
                                
                                if let recentMessage =  chattingRoom.chattingBubles?.first {
                                    Text(recentMessage.content ?? "메세지가 비어있습니다.")
                                        .foregroundStyle(.gray)
                                        .lineLimit(1)
                                    
                                    Text(changetoDateFormat(recentMessage.date))
                                        .font(.caption2)
                                        .foregroundStyle(.gray)
                                        .badge(chattingListRoomViewModel.unReadCount[chattingRoom.id] ?? 0)
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
            isEmptyChatRooms = chattingListRoomViewModel.fetchChattingList(login: userAuth.userType)
        }
    }
    
    private func changetoDateFormat(_ messageDate: String) -> String {
        let instance = SingleTonDateFormatter.sharedDateFommatter
        let date = instance.changeDateString(transition: "yyyy년 MM월 dd일 HH:mm", from: messageDate)
        return date
    }
    
}

#Preview {
    ChattingListRoomView()
        .environmentObject(ChattingListRoomViewModel())
}
