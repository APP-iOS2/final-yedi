//
//  ChattingListRoomViewModel.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/26.
//

import Foundation
import FirebaseAuth
import Firebase

final class ChattingListRoomViewModel: ObservableObject {
    @Published var chattingRooms: [ChatRoom] = []
    let realTimeService = Database.database().reference()

    /// 채팅리스트 및 채팅방 메세지를 가지고오는 메소드
    func fetchChattingList() {
        // MARK: 로그인 구현시 사용할 메소드
        // guard let userId = fetchUserUID() else {
        //     return
        // }
        
        // MARK: 채팅방 임시 ID
        let tempChatRoomId = "C314A8A6-A495-4023-882B-07D2902917C0"
        
        fetchChattingBubble(chatRooms: tempChatRoomId)
    }
    
    /// 로그인한 User토큰으로 UserUID를 가지고오는 메소드
    /// - returns: userUID
    private func fetchUserUID() -> String? {
        return  Auth.auth().currentUser?.uid
    }
    
    /// 채팅방의 메세지 내역을 가지고오는 메소드
    private func fetchChattingBubble(chatRooms id: String) {
        self.realTimeService.child("chatRooms").child(id).child("chatBubbles").observe(.value) { snapshot  in
            var bubbles: [CommonBubble] = []
            guard let chatData = snapshot.value as? [String : Any] else {
                  debugPrint("Error reading data")
                  return
            }
            
            for (key, value) in chatData {
                do {
                    var value = value as! [String : Any]
                    value["id"] = key
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                
                    let bubble = try JSONDecoder().decode(CommonBubble.self, from: jsonData)
                    bubbles.append(bubble)
                    
                    if let index = self.chattingRooms.firstIndex(where: { $0.id == id}) {
                        self.chattingRooms.remove(at: index)
                    }
                    
                    self.chattingRooms.append(.init(id: id, chattingBubles: bubbles))
                    
                } catch {
                    debugPrint("Error decoding bubble data")
                }
            }
        }
    
    }
    
    /// 채팅방의 가장 최근 메세지를 가지고오는 함수
    /// - 채팅리스트 fetch시점에 이미 정렬된 메세지가 전달되므로 chattingBubble 배열의 가장 마지막 Element를 반환한다.
    /// - Parameters:
    ///   - chatRoom: 채팅리스트의 인스턴스
    /// - returns: CommonBubble or nil
    final func getLastMessage(chatRoom: ChatRoom) -> CommonBubble? {
        guard var bubbles = chatRoom.chattingBubles else {
            return nil
        }

        guard bubbles.count > 1 else {
            return bubbles.last
        }
        
        bubbles.sort(by: {$0.date < $1.date})
        return bubbles.last
    }
}
