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
    var limitLength = 5 ///queryLimit에 쓸 채팅버블 개수 제한 변수
    init() {
        self.setUserEmail()
        self.storageRef = storageRef.child("chatRooms/\(chatRoomId)")
    }
    
    func setUserEmail() { //현재 사용자의 이메일을 세팅하는 함수
        self.userEmail = Auth.auth().currentUser?.email ?? "nil@gmail.com"
    }
    
    func fetchChattingBubble(chatRoomId: String) {
        let db = Firestore.firestore()
        
        db.collection("chattingTest02") //채팅방의 위치
            .limit(toLast: 12)
            .order(by: "date")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                var bubbles: [CommonBubble] = []
                
                for document in documents {
                    do {
                        var bubbleData = document.data()
                        bubbleData["id"] = document.documentID
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: bubbleData)
                        
                        var bubble = try JSONDecoder().decode(CommonBubble.self, from: jsonData)
                        bubble.isRead = true
                        bubbles.append(bubble)
                    } catch {
                        print("Error decoding bubble data")
                    }
                }
                
                self.chattings = self.mergeCommonBubbles(first: self.chattings, second: bubbles)
                
                if let id = bubbles.last?.id {
                    self.lastBubbleId = id
                }
            }
    }
    
    func fetchMoreChattingBubble(){
        ///0번째 인덱스의 채팅 버블이 가장 오래된 버블이므로
        ///해당 버블의 date보다 작은 값의 채팅을 10개 불러오고
        ///해당 배열을 앞에 붙여주면 된다.
        let db = Firestore.firestore()

        db.collection("chattingTest02")   //채팅방의 위치
            .whereField("date", isLessThan: self.chattings[0].date) //최근 메시지보다 더 오래된 메시지를 불러온다.
            .limit(toLast: limitLength) //limitLength값에 맞게 길이 제한
            .order(by: "date")          //채팅의 순서 date 기준
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error))")
                    return
                }
                
                var moreBubbles: [CommonBubble] = []
                
                for document in documents {
                    do {
                        var bubbleData = document.data()
                        bubbleData["id"] = document.documentID
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: bubbleData)
                        
                        var bubble = try JSONDecoder().decode(CommonBubble.self, from: jsonData)
                        bubble.isRead = true
                        moreBubbles.append(bubble)
                    } catch {
                        print("Error decoding bubble data")
                    }
                }
                
                self.chattings = moreBubbles + self.chattings
            }
    }
    
    ///텍스트 버블을 보내는 메소드
    func sendTextBubble(content: String, sender: String) {
        let db = Firestore.firestore()
        
        let bubble = CommonBubble(
            content: content,
            date: "\(Date())",
            sender: sender,
            isRead: false
        )
        
        let collectionRef = db.collection("chattingTest02")
        
        let data: [String: Any] = [
            "id": bubble.id,
            "content": bubble.content,
            "date": bubble.date,
            "messageType": bubble.messageType.rawValue,
            "sender": bubble.sender,
            "isRead": bubble.isRead
        ]
        
        collectionRef.addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully.")
            }
        }
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
                
                let post = Post(id: id, designerID: designerID, location: location, title: title, description: description, photos: photos, comments: 0, timestamp: "")
                ///새로 생성된 채팅방에 바로 게시물 버블 보내기
                self.sendBoardBubble(content: "이 게시물 보고 상담하러 왔어요", imagePath: post.photos[0].imageURL, sender: sender)
            }
        }
    }
    
    /// 중복되지 않은 채팅버블을 뒤에 추가해주는 함수
    /// 10개의 길이한계로 불러오는 경우 뒤에 새로운 내용이 올 때마다 병합해주어야 하기 때문
    func mergeCommonBubbles(first: [CommonBubble], second: [CommonBubble]) -> [CommonBubble] {
        // 중복되는 CommonBubble을 찾아내는 Set을 생성합니다.
        let firstSet = Set(first)
        
        // 중복되지 않은 CommonBubble을 찾아내기 위해 second 배열을 필터링합니다.
        let uniqueSecond = second.filter { !firstSet.contains($0) }
        
        // first 배열과 중복되지 않은 second 배열을 합쳐 새로운 배열을 생성합니다.
        let mergedArray = first + uniqueSecond
        let sortedArray = mergedArray.sorted{$0.date < $1.date}
        
        return sortedArray
    }
    
}

