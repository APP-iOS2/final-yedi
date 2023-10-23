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
                                
                            VStack(alignment: .leading, spacing: 8) {
                                Text(chattingListRoomViewModel.userProfile[chattingRoom.id]?.name ?? "UnKown")
                                    .font(.title3.bold())
                                HStack {
                                    VStack(alignment: .leading) {
                                        if let recentMessage =  chattingRoom.chattingBubles?.first {
                                            if recentMessage.messageType == MessageType.imageBubble {
                                                Text("사진")
                                                    .foregroundStyle(.gray)
                                                    .lineLimit(1)
                                            } else {
                                                Text(recentMessage.content ?? "메세지가 비어있습니다.")
                                                    .foregroundStyle(.gray)
                                                    .lineLimit(1)
                                            }
                                            
                                            Text(changetoDateFormat(recentMessage.date))
                                                .font(.caption2)
                                                .foregroundStyle(.gray)
                                            
                                        } else {
                                            Text("메세지가 존재하지 않습니다")
                                                .foregroundStyle(.gray)
                                                .lineLimit(1)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if chattingListRoomViewModel.unReadCount[chattingRoom.id] ?? 0 != 0 {
                                        UnReadCountCircle(unreadCount: chattingListRoomViewModel.unReadCount[chattingRoom.id] ?? 0)
                                    }
                                }
                            }
                            .padding(.leading, 8)
                        }
                    }
                }
                .animation(.easeInOut, value: chattingListRoomViewModel.chattingRooms)
                .listStyle(.plain)
                .navigationTitle("")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        YdIconView(height: 30)
                    }
                }
            }
        }
        .onAppear {
            isEmptyChatRooms = chattingListRoomViewModel.fetchChattingList(login: userAuth.userType)
        }
    }
    
    private func changetoDateFormat(_ messageDate: String) -> String {
        let dateFomatter = SingleTonDateFormatter.sharedDateFommatter.firebaseDateFormat()
        let date = dateFomatter.date(from: messageDate) ?? Date()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            dateFomatter.dateFormat = "HH:mm"
            return dateFomatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "어제"
        } else {
            let currentYear = calendar.component(.year, from: Date())
            let messageYear = calendar.component(.year, from: date)
                // 올해 년도의 메세지인 경우 월/일 반환
            if currentYear == messageYear {
                dateFomatter.dateFormat = "MM/dd"
                return dateFomatter.string(from: date)
            } else {
                // 그 외 올해가 아닌 데이터 날짜는 년.월, 일 형식의 String을 반환
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                return formatter.string(from: date)
            }
        }
    }

}

#Preview {
    ChattingListRoomView()
        .environmentObject(ChattingListRoomViewModel())
        .environmentObject(UserAuth())
}
