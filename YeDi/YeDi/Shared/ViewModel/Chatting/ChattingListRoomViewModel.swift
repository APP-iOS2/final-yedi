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
                debugPrint("Error getting cahtRooms: \(error)")
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
    final func fetchChattingBubble(chatRooms id: String) {
        
        let bubblePath = "chatRooms/\(id)/bubbles"
        let ref = storeService.collection(bubblePath).order(by: "date", descending: true).limit(to: 1)
        
        ref.addSnapshotListener{ snapShot, error in
            
            var bubbles: [CommonBubble] = []
            
            if let error = error {
                debugPrint("Error getting bubbles: \(error)")
                return
            }
            
            if let snapShot = snapShot, !snapShot.isEmpty {
                do {
                    for document in snapShot.documents {
                        let bubble = try document.data(as: CommonBubble.self)
                        bubbles.append(bubble)
                        if let index = self.chattingRooms.firstIndex(where: { $0.id == id}) {
                            self.chattingRooms.remove(at: index)
                        }
                        self.chattingRooms.append(.init(id: id, chattingBubles: bubbles))
                        self.chattingRooms.sort(by: {$0.chattingBubles?.first?.date ?? "" > $1.chattingBubles?.first?.date ?? ""})
                    }
                } catch {
                    debugPrint("bubble Document 변환 실패")
                }
            }
        }
    }
    
}
