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

final class ChattingListRoomViewModel: ObservableObject {
    @Published var chattingRooms: [ChatRoom] = []
    let realTimeService = Database.database().reference()
    let storeService = Firestore.firestore()
    
    /// 채팅리스트 및 채팅방 메세지를 가지고오는 메소드
    func fetchChattingList(login type: UserType?) -> Bool{
         guard let userId = fetchUserUID() else {
             debugPrint("로그인 정보를 찾을 수 없음")
             return true
         }
        
        guard let type else {
            debugPrint("로그인 정보를 찾을 수 없음")
            return true
        }
        
        fetchChattingRoomIdList(user: userId, loginType: type)
        return false
    }
    
    /// 로그인한 User토큰으로 UserUID를 가지고오는 메소드
    /// - returns: userUID
    final func fetchUserUID() -> String? {
        return  Auth.auth().currentUser?.uid
    }
    
    /// 전달된 user UUID 값으로 채팅방 UUID리스트를 추출
    /// - 유저 Document의 이벤트 리스너가 채팅방 리스트가 추가 될 때마다 채팅방 정보를 갱신
    private final func fetchChattingRoomIdList(user uid: String, loginType: UserType) {
        
        let docRef: DocumentReference
        
        if loginType == UserType.client{
            docRef = storeService.collection("clients").document(uid)
        } else {
            docRef = storeService.collection("designers").document(uid)
        }
        
        docRef.addSnapshotListener{ (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = document, document.exists {
                guard var chatRooms = document.data()?["chatRooms"] as? [String] else { return }
                chatRooms = chatRooms.compactMap{ $0.trimmingCharacters(in: .whitespaces) }.filter({ !$0.isEmpty })
                
                for chatRoomId in chatRooms {
                    self.fetchChattingBubble(chatRooms: chatRoomId)
                }
            }
        }
    }
    
    /// 채팅방의 메세지 내역을 가지고오는 메소드
    /// - 채팅방에서 가장 최근 메세지 한 개만 조회
    private final func fetchChattingBubble(chatRooms id: String) {
        let query = self.realTimeService.child("chatRooms").child(id).child("chatBubbles").queryOrdered(byChild: "date").queryLimited(toLast: 1)
        query.observe(.value) { [weak self] snapshot, _    in
            var bubbles: [CommonBubble] = []
            guard let chatData = snapshot.value as? [String : Any] else {
                  debugPrint("Error bubble reading data")
                  return
            }
            
            guard let self = self else {
                debugPrint("No References")
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
    
    /// 채팅방의 최근 메세지 기준 정렬하는 함수
    /// - returns: Array<T: ChatRoom>
    final func getOrderedChatRooms() -> [ChatRoom] {
        guard chattingRooms.count > 0 else {
            return []
        }
        
        let sortedChatRooms = chattingRooms.sorted {
            return $0.chattingBubles?.first?.date ?? ""  > $1.chattingBubles?.first?.date ?? ""
        }
        
        return sortedChatRooms
    }
}
