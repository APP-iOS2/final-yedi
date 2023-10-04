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
import FirebaseStorage

class TempChatbubbleStore: ObservableObject {
    
    @Published var userEmail: String = "None"
    @Published var chattings: [CommonBubble] = []
    @Published var lastBubbleId: String = ""
    
    var ref: DatabaseReference! = Database.database().reference()
    var chatRoomID: String ///채팅방의 키값이 전달되어야 함
    var storageRef = Storage.storage().reference() ///스토리지 참조 생성
    
    init(chatRoomID: String) {
        self.chatRoomID = chatRoomID
        self.setUserEmail()
        self.storageRef = storageRef.child("chatRooms/\(chatRoomID)")
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
            
            if let id = bubbles.last?.id {
                self.lastBubbleId = id
            }
            
        }
    }
    
    ///텍스트 버블을 보내는 메소드
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
    
    ///이미지 버블을 보내는 메소드
    func sendImageBubble(imageData: Data, sender: String) {
        
        var imageURL: String = ""
        var bubble: CommonBubble = CommonBubble(imagePath: "", date: "", sender: "")
        self.storageRef = storageRef.child("\(bubble.id).jpg")
        
        let uploadTask = storageRef.putData(imageData, metadata: nil) {
            (metadata, error) in
            
            guard let metadata = metadata else {
                print("이미지 업로드 중 에러 발생")
                return
            }
            
            ///You can also access to download URL after upload.
            self.storageRef.downloadURL { (url, error) in
                
                guard let downloadURL = url else {
                    print("이미지 URL생성 중 에러 발생")
                    return
                }
                
                imageURL = "\(String(describing: url!))"
                
                bubble = CommonBubble(
                    imagePath: "\(imageURL)",
                    date: "\(Date())",
                    sender: sender
                )
                
                self.ref.child("chatRooms").child(self.chatRoomID).child("chatBubbles").child("\(bubble.date + bubble.id)")
                    .setValue([
                        "id": bubble.id,
                        "imagePath": bubble.imagePath,
                        "date": bubble.date,
                        "messageType": bubble.messageType.rawValue,
                        "sender": bubble.sender
                    ])
                
                self.fetchChattingBubble(chatRomsId: self.chatRoomID)
            }
        }
    }
    
    ///게시물 버블을 보내는 메소드
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
    
    ///상담하기를 누르면 채팅방이 생성된 이후에 자동으로 고객에서 디자이너에게 "이 게시물을 보고 상담하러 왔습니다."
    ///매개변수 : 게시물 아이디 값
    func startingBoardBubble(postID: String) {
        ///게시물들이 있는 파이어스토어 데이터베이스 이름
        let databasePosts = Firestore.firestore().collection("posts/\(postID)")	
        
        ///게시물을 지정된 구조체형에 맞게 변환
        databasePosts.getDocuments { (snapshot, error) in
            
        }
        
        ///새로 생성된 채팅방에 바로 게시물 버블 보내기
        //sendBoardBubble(content: "위 게시물을 보고 상담신청했어요~")
    }
    
    private func loadImage() {
        
    }
    
}

