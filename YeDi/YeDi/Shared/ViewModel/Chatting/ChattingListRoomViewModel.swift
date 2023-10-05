//
//  ChattingListRoomViewModel.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/26.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ChattingListRoomViewModel: ObservableObject {
    @Published var chattingRooms: [ChatRoom] = []
    let realTimeService = Database.database().reference()
    let storeService = Firestore.firestore()
    /// 채팅리스트 및 채팅방 메세지를 가지고오는 메소드
    func fetchChattingList() {
        // MARK: 로그인 구현시 사용할 메소드
        // guard let userId = fetchUserUID() else {
        //     return
        // }
        
        // MARK: 유저ID 임시값
        let userId = "CR3Ld8rMseTsgBkz2VgH3YTRmeI2"
        fetchChattingRoomIdList(user: userId)
        
    }
    
    /// 로그인한 User토큰으로 UserUID를 가지고오는 메소드
    /// - returns: userUID
    final func fetchUserUID() -> String? {
        return  Auth.auth().currentUser?.uid
    }
    
    /// 전달된 user UUID 값으로 채팅방 UUID리스트를 추출
    /// - 유저 Document의 이벤트 리스너가 채팅방 리스트가 추가 될 때마다 채팅방 정보를 갱신
    private final func fetchChattingRoomIdList(user uid: String) {
        storeService.collection("chattingUserTest").whereField("userId", isEqualTo: uid)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    debugPrint("Error fetching chatting List id: \(error!)")
                    return
                }
                let chattingList = documents.flatMap({ document in
                    document["chattingList"] as? [String] ?? []
                })
                
                for chatRoomId in chattingList {
                    self.fetchChattingBubble(chatRooms: chatRoomId)
                }
            }
    }
    
    /// 채팅방의 메세지 내역을 가지고오는 메소드
    /// - 채팅방에서 가장 최근 메세지 한 개만 조회
    private final func fetchChattingBubble(chatRooms id: String) {
        let query = self.realTimeService.child("chatRooms").child(id).child("chatBubbles").queryOrdered(byChild: "date").queryLimited(toLast: 1)
        query.observe(.value) { snapshot  in
            var bubbles: [CommonBubble] = []
            guard let chatData = snapshot.value as? [String : Any] else {
                  debugPrint("Error bubble reading data")
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
