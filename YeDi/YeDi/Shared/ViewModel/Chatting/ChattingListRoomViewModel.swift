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
    @Published var userProfile: [String: ChatListUserInfo] = [:]
    @Published var unReadCount: [String: Int] = [:]
    @Published var unReadTotalCount: Int = 0
    @Published var isEmptyChattingList: Bool = true
    
    let storeService = Firestore.firestore()
    
    var getUnReadTotalCount: Int {
        get {
            var totalCount = 0
            for key in unReadCount.keys {
                totalCount += unReadCount[key] ?? 0
            }
            return totalCount
        }
    }
    
    /// 채팅리스트 및 채팅방 메세지를 가지고오는 메소드
    func fetchChattingList(login type: UserType?) {
         guard let userId = fetchUserUID() else {
             debugPrint("로그인 정보를 찾을 수 없음")
             isEmptyChattingList = true
             return
         }
        
        guard let type else {
            debugPrint("화면정보가 없음")
            isEmptyChattingList = true
            return
        }
        
        fetchChattingRoomIdList(user: userId, loginType: type)
    }
    
    /// 로그인한 User토큰으로 UserUID를 가지고오는 메소드
    /// - returns: userUID
    private final func fetchUserUID() -> String? {
        return  Auth.auth().currentUser?.uid
    }
    
    /// 전달된 user UUID 값으로 채팅방 UUID리스트를 추출
    /// - 유저 Document의 이벤트 리스너가 채팅방 리스트가 추가 될 때마다 채팅방 정보를 갱신
    private final func fetchChattingRoomIdList(user uid: String, loginType: UserType) {
        let docRef: DocumentReference
        
        if loginType == .client {
            docRef = storeService.collection("clients").document(uid)
        } else {
            docRef = storeService.collection("designers").document(uid)
        }
        
        docRef.addSnapshotListener{[weak self] (snapshot, error) in
            if let error = error {
                debugPrint("Error getting cahtRooms: \(error)")
            } else if let document = snapshot, document.exists {
                guard var chatRooms = document.data()?["chatRooms"] as? [String] else { return }
                
                chatRooms = chatRooms.compactMap{ $0.trimmingCharacters(in: .whitespaces) }.filter({ !$0.isEmpty })
                self?.fetchUserInfo(login: loginType, chatRooms: chatRooms)
                if chatRooms.count < 1 {
                    self?.isEmptyChattingList = true
                } else {
                    self?.isEmptyChattingList = false
                    
                    for chatRoomId in chatRooms {
                        self?.fetchChattingBubble(chatRoom: chatRoomId)
                        self?.fetchUnReadMessageCount(chatRoom: chatRoomId, userId: uid)
                    }
                }
            } else {
                self?.isEmptyChattingList = true
            }
        }
    }
    
    /// 채팅방의 메세지 내역을 가지고오는 메소드
    /// - 채팅방에서 가장 최근 메세지 한 개만 조회
    private final func fetchChattingBubble(chatRoom id: String) {
        let bubblePath = "chatRooms/\(id)/bubbles"
        let ref = storeService.collection(bubblePath).order(by: "date", descending: true).limit(to: 1)
        
        ref.addSnapshotListener{[weak self] snapshot, error in
            var bubbles: [CommonBubble] = []
            
            if let error = error {
                debugPrint("Error getting bubbles: \(error)")
                return
            }
            
            if let snapshot = snapshot, !snapshot.isEmpty {
                do {
                    for document in snapshot.documents {
                        let bubble = try document.data(as: CommonBubble.self)
                        
                        bubbles.append(bubble)
                        
                        if let index = self?.chattingRooms.firstIndex(where: { $0.id == id}) {
                            self?.chattingRooms.remove(at: index)
                        }
                        
                        self?.chattingRooms.append(.init(id: id, chattingBubles: bubbles))
                        self?.chattingRooms.sort(by: {$0.chattingBubles?.first?.date ?? "" > $1.chattingBubles?.first?.date ?? ""})
                    }
                } catch {
                    debugPrint("bubble Document 변환 실패")
                }
            }
        }
    }
    
    /// 읽은 메세지 갯수를 가지고오는 메소드
    private final func fetchUnReadMessageCount(chatRoom id: String, userId receive: String) {
        let path = "chatRooms/\(id)/bubbles"
        //내가 안 읽은 메세지 버블 갯수를 새야하니까, sender는 상대방이 보낸거, isRead는 false인거
        let ref = storeService.collection(path).whereField("sender", isNotEqualTo: receive).whereField("isRead", isEqualTo: false)
        
        ref.addSnapshotListener {[weak self] snapshot, error in
            if let error = error {
                debugPrint("Error getting isRead: \(error)")
                return
            }
        
            if let snapshot = snapshot, !snapshot.isEmpty {
                self?.unReadCount[id] = snapshot.documents.count
            } else {
                self?.unReadCount[id] = 0
            }
        }
    }
    
    /// 채팅방마다 유저 닉네임, url사진을 userProfile variable에 저장하는 메소드
   private final func fetchUserInfo(login type: UserType, chatRooms id: [String]) {
        let colRef: CollectionReference
        
        // MARK: 상대방 유저정보가 필요 하므로 로그인한 계정과 반대인 Collection 탐색
        if type == .client{
            colRef = storeService.collection("designers")
        } else {
            colRef = storeService.collection("clients")
        }
        
        for chatRoomId in id {
            colRef.whereField("chatRooms", arrayContains: chatRoomId).addSnapshotListener {[weak self] snapshot, error in
                if let error = error {
                    debugPrint("Error getting userProfile: \(error)")
                    return
                }
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for document in snapshot.documents {
                        var userInfo: ChatListUserInfo
                        if type == .client {
                            userInfo = ChatListUserInfo(uid: document.documentID,
                                                        name: document.data()["name"] as? String ?? "",
                                                            profileImageURLString: document.data()["imageURLString"] as? String ?? "")
                        } else {
                            userInfo = ChatListUserInfo(uid: document.documentID,
                                                        name: document.data()["name"] as? String ?? "",
                                                        profileImageURLString: document.data()["profileImageURLString"] as? String ?? "")
                        }
                        self?.userProfile[chatRoomId] = userInfo
                    }
                }
            }
        }
    }
    
}
