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
    @Published var isReadBubble: Bool = false
    @Published var receivedBubbleId: [String] = []
    
    var ref: DatabaseReference! = Database.database().reference()
    var storageRef = Storage.storage().reference()
    let storeService = Firestore.firestore() ///클라이언트와 디자이너 정보를 불러오기 위함
    var sotreListener: ListenerRegistration? ///채팅을 읽는 전용 리스너 => 제거하기 위함
    
    var limitLength = 5 ///더 불러오기에 쓸 채팅버블 개수 제한 변수
    var storePath: String {
        return "chatRooms/\(chatRoomId)/bubbles"
    }
    
    init() {
        self.setUserEmail()
        //self.storageRef = storageRef.child("chatRooms/\(chatRoomId)")
    }
    
    func setUserEmail() { //현재 사용자의 이메일을 세팅하는 함수
        self.userEmail = Auth.auth().currentUser?.email ?? "nil@gmail.com"
    }
    
    func firstChattingBubbles() {
        self.sotreListener = storeService.collection(storePath) //채팅방의 위치
        .limit(toLast: limitLength)
        .order(by: "date")
        .addSnapshotListener { [weak self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            var bubbles: [CommonBubble] = []
            
            querySnapshot?.documentChanges.forEach { diff in
                do {
                    let diffData = diff.document.data()
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: diffData)
                    
                    let bubble = try JSONDecoder().decode(CommonBubble.self, from: jsonData)
                    
                    if (diff.type == .added) {
                        ///채팅에 새로운 버블 추가
                        self?.chattings.append(bubble)
                    }

                    if (diff.type == .modified) {
                        ///채팅에 업데이트 된 내용으로 
                        self?.chattings = self!.updateChatting(chattings: self!.chattings, diff: bubble)
                    } else {
                        
                    }
                } catch {
                    print("Error decoding bubble data")
                }
            }
        }
    }
    
    ///리스너를 분리하는 함수
    func removeListener() {
        self.sotreListener?.remove()
    }
    
    func fetchMoreChattingBubble() {
        ///0번째 인덱스의 채팅 버블이 가장 오래된 버블이므로
        ///해당 버블의 date보다 작은 값의 채팅을 N개 불러오고
        ///해당 배열을 앞에 붙여주면 된다.
        storeService.collection(storePath)   //채팅방의 위치
            .whereField("date", isLessThan: self.chattings[0].date) //최근 메시지보다 더 오래된 메시지를 불러온다.
            .limit(toLast: limitLength) //limitLength값에 맞게 길이 제한
            .order(by: "date")          //채팅의 순서 date 기준
            .getDocuments { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error))")
                    return
                }
                
                var moreBubbles: [CommonBubble] = []
                
                for document in documents {
                    do {
                        let bubbleData = document.data()
                        ///bubbleData["id"] = document.documentID
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: bubbleData)
                        
                        let bubble = try JSONDecoder().decode(CommonBubble.self, from: jsonData)
                        
                        moreBubbles.append(bubble)
                    } catch {
                        print("Error decoding bubble data")
                    }
                }
                print("Add : \(moreBubbles.count)")
                self!.chattings = moreBubbles + self!.chattings
            }
    }
    
    /// 모든 상대방 버블을 조회하여 "isRead" 필드의 값을 변경하는 함수
    func updateChattingBubbleReadState() {
        for documentId in receivedBubbleId {
            storeService.collection(storePath).document(documentId).updateData(["isRead" : true])
        }
    }
    
    /// 채팅방에서 상대방 버블 아이디 가져오와서 배열(receivedBubbleId)로 저장하는 함수
    /// 마지막에 updateChattingBubbleReadState()를 실행한다.
    func getReceivedBubbleId(chatRoomId: String, sender: String) {
        storeService.collection(storePath).whereField("sender", isEqualTo: sender).getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            let data = documents.map { queryDocumentSnapshot in
                queryDocumentSnapshot.documentID
            }
            
            self.receivedBubbleId = data
            self.updateChattingBubbleReadState()
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
        
        let data: [String: Any] = [
            "id": bubble.id,
            "content": bubble.content!,
            "date": bubble.date,
            "messageType": bubble.messageType.rawValue,
            "sender": bubble.sender,
            "isRead": bubble.isRead
        ]
        
        storeService.collection(storePath).addDocument(data: data) { error in
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
                
                let data: [String: Any] = [
                    "id": bubble.id,
                    "imagePath": bubble.imagePath!,
                    "date": bubble.date,
                    "messageType": bubble.messageType.rawValue,
                    "sender": bubble.sender,
                    "isRead": bubble.isRead
                ]
                
                self.storeService.collection(self.storePath).addDocument(data: data) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully.")
                    }
                }
                
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
        
        let data: [String: Any] = [
            "id": bubble.id,
            "content": bubble.content!,
            "imagePath": bubble.imagePath!,
            "date": bubble.date,
            "messageType": bubble.messageType.rawValue,
            "sender": bubble.sender,
            "isRead": bubble.isRead
        ]
        
        storeService.collection(storePath).addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully.")
            }
        }
        
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
    func mergeChatting(first: [CommonBubble]?, second: [CommonBubble]) -> [CommonBubble] {
        let firstSet = Set(first!)
        let uniqueSecond = second.filter { !firstSet.contains($0) }
        let mergedArray = first! + uniqueSecond
        let sortedArray = mergedArray.sorted{$0.date < $1.date}
        
        return sortedArray
    }
    
    ///self.chattings의 채팅 내용을 업데이트 해주는 코드
    ///id로 찾아서 바꿔주기
    func updateChatting(chattings: [CommonBubble], diff: CommonBubble) -> [CommonBubble] {
        var tempchat = chattings
        
        if let index = tempchat.firstIndex(where: { $0.id == diff.id })
        {
            tempchat[index] = diff
        }
        
        return tempchat
    }
}

