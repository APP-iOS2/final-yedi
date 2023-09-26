//
//  ChattingViewModel.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class TempChatbubbleStore: ObservableObject {
    
    //let dbRef = Firestore.firestore().collection("") //채팅방 모음이 있는 파이어스토어 데이터베이스 이름
    @Published var userEmail: String = "None"
    @Published var chattings: [CommonBubble] = []
    
    var ref: DatabaseReference! = Database.database().reference()
    var chatRoomID: String //채팅방의 키값이 전달되어야 함
    //임시 채팅방 키 값
    
    init(chatRoomID: String) {
        self.chatRoomID = chatRoomID
        self.setUserEmail()
    }
    
    func setUserEmail() { //현재 사용자의 이메일을 세팅하는 함수
        self.userEmail = Auth.auth().currentUser?.email ?? "nil@gmail.com"
    }
    
    func fetchChattingBubble(chatRomsId: String) {
            self.ref.child("chatRooms").child(chatRomsId).child("chatBubbles").observe(.value) { snapshot  in
                guard let chatData = snapshot.value as? [String : Any] else {
                      print("Error reading data")
                      return
                }
                var bubbles: [CommonBubble] = []
                
                for (key, value) in chatData {
                    do {
                        var value = value as! [String : Any]
                        value["id"] = key
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: value)
                    
                        let bubble = try JSONDecoder().decode(CommonBubble.self, from: jsonData)
                        bubbles.append(bubble)
                    } catch {
                        print("Error decoding bubble data")
                    }
                }
                bubbles.sort(by: {$0.date < $1.date})
                self.chattings = bubbles
            }
        }
    
    func loadAndUpdateChatting() {
//
//        let chatbubbleRef = ref
//            .child("chatRooms")
//            .child(chatRoomID)
//            .child("chatBubbles") //채팅방 경로 (Firebae Realtime Database)
//            .queryOrdered(byChild: "date") //date 프로퍼티로 정렬
//
//        chatbubbleRef.observe(.value) { snapshot in
//
//            guard let value = snapshot.value as? [String: [String: Any]] else {
//                print("Error: Unable to parse snapshot data")
//                return
//            }
//
//            var tempBubbles = self.decodeToBubble(snapshotValue: value)
//
//            DispatchQueue.main.async { // UI 업데이트는 메인 스레드에서 실행되어야 합니다.
//                self.chats = tempBubbles
//                //print("==========chats")
//                //print(self.chats)
//            }
//
//        }
    }
    
    func sendBoardBubble(content: String, imagePath: String, sender: String) {
        let bubble = BoardBubble(
            content: content,
            imagePath: imagePath,
            date: "\(Date())",
            sender: sender)
        
        self.ref.child("chatRooms").child(chatRoomID).child("chatBubbles").child(bubble.id)
            .setValue([
                "content": bubble.content,
                "imagePath": bubble.imagePath,
                "date": bubble.date,
                "messageType": "boardBubble",
                "sender": bubble.sender
            ])
        loadAndUpdateChatting()
    }
    
    func sendTextBubble(content: String, sender: String) {
        let bubble = TextBubble(
            content: content,
            date: "\(Date())",
            sender: sender
        )
        
        self.ref.child("chatRooms").child(chatRoomID).child("chatBubbles").child(bubble.id)
            .setValue([
                "content": bubble.content,
                "date": bubble.date,
                "messageType": "boardBubble",
                "sender": bubble.sender
            ])
        loadAndUpdateChatting()
    }
    
    func sendImageBubble(imagePath: String, sender: String) {
        let bubble = ImageBubble(
            imagePath: imagePath,
            date: "\(Date())",
            sender: sender
        )
        
        self.ref.child("chatRooms").child(chatRoomID).child("chatBubbles").child(bubble.id)
            .setValue([
                "imagePath": bubble.imagePath,
                "date": bubble.date,
                "messageType": "boardBubble",
                "sender": bubble.sender
            ])
        loadAndUpdateChatting()
    }
    
    func decodeToBubble(snapshotValue: [String: [String: Any]]) -> [Any] {
        return snapshotValue.compactMap { key, value in
            guard
                let messageType = value["messageType"] as? String,
                let date = value["date"] as? String,
                let sender = value["sender"] as? String
            else {
                return nil // 필수 필드가 없는 경우는 무시
            }
            print("MT is : \(messageType)")
            switch messageType {
            case MessageType.boardBubble.rawValue:
                guard
                    let content = value["content"] as? String,
                    let imagePath = value["ImagePath"] as? String
                else {
                    return nil
                }
                return BoardBubble(id: key, content: content, imagePath: imagePath, date: date, sender: sender)
            case MessageType.textBubble.rawValue:
                guard let content = value["content"] as? String else {
                    return nil
                }
                return TextBubble(id: key, content: content, date: date, sender: sender)
            case MessageType.imageBubble.rawValue:
                guard let imagePath = value["ImagePath"] as? String else {
                    return nil
                }
                return ImageBubble(id: key, imagePath: imagePath, date: date, sender: sender)
            default:
                return nil // 알 수 없는 messageType인 경우 무시
            }
        }
    }
    
}

