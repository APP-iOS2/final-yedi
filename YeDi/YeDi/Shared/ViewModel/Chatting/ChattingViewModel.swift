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
        self.ref.child("chatRooms").child(chatRomsId).child("chatBubbles")
            .queryOrdered(byChild: "date")
            .observe(.value) { snapshot  in
                
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
    
    func sendBoardBubble(content: String, imagePath: String, sender: String) {
        let bubble = CommonBubble(
            content: content,
            imagePath: imagePath,
            date: "\(Date())",
            sender: sender)
        
        self.ref.child("chatRooms").child(chatRoomID).child("chatBubbles").child("\(bubble.date + bubble.id)")
            .setValue([
                "id": bubble.id,
                "content": bubble.content,
                "imagePath": bubble.imagePath,
                "date": bubble.date,
                "messageType": bubble.messageType.rawValue,
                "sender": bubble.sender
            ])
        
        fetchChattingBubble(chatRomsId: chatRoomID)
    }
    
    func sendTextBubble(content: String, sender: String) {
        let bubble = CommonBubble(
            content: content,
            date: "\(Date())",
            sender: sender
        )
        
        self.ref.child("chatRooms").child(chatRoomID).child("chatBubbles").child("\(bubble.date + bubble.id)")
            .setValue([
                "id": bubble.id,
                "content": bubble.content,
                "date": bubble.date,
                "messageType": bubble.messageType.rawValue,
                "sender": bubble.sender
            ])
        
        fetchChattingBubble(chatRomsId: chatRoomID)
    }
    
    func sendImageBubble(imagePath: String, sender: String) {
        let bubble = CommonBubble(
            imagePath: imagePath,
            date: "\(Date())",
            sender: sender
        )
        
        self.ref.child("chatRooms").child(chatRoomID).child("chatBubbles").child("\(bubble.date + bubble.id)")
            .setValue([
                "id": bubble.id,
                "imagePath": bubble.imagePath,
                "date": bubble.date,
                "messageType": bubble.messageType.rawValue,
                "sender": bubble.sender
            ])
        
        fetchChattingBubble(chatRomsId: chatRoomID)
    }
    
    
    
}

