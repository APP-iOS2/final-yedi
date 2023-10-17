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
import FirebaseFirestoreSwift


class ChattingViewModel: ObservableObject {

    @Published var userEmail: String = "None"
    @Published var chatRoomId: String = ""
    @Published var chattings: [CommonBubble] = []
    @Published var lastBubbleId: String = ""

    
    var ref: DatabaseReference! = Database.database().reference()
    var storageRef = Storage.storage().reference() ///스토리지 참조 생성
    let storeService = Firestore.firestore()
    init() {
        self.setUserEmail()
        self.storageRef = storageRef.child("chatRooms/\(chatRoomId)")
    }
    
    func setUserEmail() { //현재 사용자의 이메일을 세팅하는 함수
        self.userEmail = Auth.auth().currentUser?.email ?? "nil@gmail.com"
    }
    
    func fetchChattingBubble(chatRoomId: String) {
        self.ref.child("chatRooms").child(chatRoomId).child("chatBubbles")
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
                    
                    var bubble = try JSONDecoder().decode(CommonBubble.self, from: jsonData)
                    bubble.isRead = true
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
            sender: sender, 
            isRead: false
        )
        
        self.ref.child("chatRooms").child(chatRoomId).child("chatBubbles").child("\(bubble.date + bubble.id)")
            .setValue([
                "id": bubble.id,
                "content": bubble.content,
                "date": bubble.date,
                "messageType": bubble.messageType.rawValue,
                "sender": bubble.sender,
                "isRead": bubble.isRead
            ])
        
    }
    
    ///이미지 버블을 보내는 메소드
    func sendImageBubble(imageData: Data, sender: String) {
        
        var imageURL: String = ""
        var bubble: CommonBubble = CommonBubble(imagePath: "", date: "", sender: "", isRead: false)
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
                    sender: sender,
                    isRead: false
                )
                
                self.ref.child("chatRooms").child(self.chatRoomId).child("chatBubbles").child("\(bubble.date + bubble.id)")
                    .setValue([
                        "id": bubble.id,
                        "imagePath": bubble.imagePath,
                        "date": bubble.date,
                        "messageType": bubble.messageType.rawValue,
                        "sender": bubble.sender,
                        "isRead": bubble.isRead
                    ])
                
            }
        }
    }
    
    ///게시물 버블을 보내는 메소드
    func sendBoardBubble(content: String, imagePath: String, sender: String) {
        let bubble = CommonBubble(
            content: content,
            imagePath: imagePath,
            date: "\(Date())",
            sender: sender,
            isRead: false
        )
        
        self.ref.child("chatRooms").child(chatRoomId).child("chatBubbles").child("\(bubble.date + bubble.id)")
            .setValue([
                "id": bubble.id,
                "content": bubble.content,
                "imagePath": bubble.imagePath,
                "date": bubble.date,
                "messageType": bubble.messageType.rawValue,
                "sender": bubble.sender,
                "isRead": bubble.isRead
            ])
        
    }
    
    ///상담하기를 누르면 채팅방이 생성된 이후에 자동으로 고객에서 디자이너에게 "이 게시물을 보고 상담하러 왔습니다."
    ///매개변수 : 게시물 아이디 값
    func startingBoardBubble(postID: String, sender: String) {
        ///게시물들이 있는 파이어스토어 데이터베이스 이름
        let databasePosts = Firestore.firestore().collection("posts/\(postID)")
        
        ///게시물을 지정된 구조체형에 맞게 변환
        databasePosts.getDocuments { (snapshot, error) in
            let id = postID
            
            if let docData = snapshot?.documents as? [String:Any],
               let designerID = docData["designerID"] as? String,
               let location = docData["location"] as? String,
               let title = docData["title"] as? String,
               let description = docData["description"] as? String,
               let photosDataArray = docData["photos"] as? [[String:Any]] {
                
                // photos 필드 처리
                var photos: [Photo] = []
                
                for photoData in photosDataArray {
                    if let photoID = photoData["id"] as? String,
                       let imageURLString = photoData["imageURL"] as? String {
                        
                        // Photo 객체 생성 및 배열에 추가
                        let photo = Photo(id: photoID, imageURL: imageURLString)
                        photos.append(photo)
                    }
                }
                
                let post = Post(id: id, designerID: designerID, location: location, title: title, description: description, photos: photos, comments: 0, timestamp: "", hairCategory: .Cut)
                ///새로 생성된 채팅방에 바로 게시물 버블 보내기
                self.sendBoardBubble(content: "이 게시물 보고 상담하러 왔어요", imagePath: post.photos[0].imageURL, sender: sender)
            }
        }
    }
    
    
}

