//
//  ConsultationViewModel.swift
//  YeDi
//
//  Created by 김성준 on 2023/10/05.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

enum ChattingRommCRUD: Error {
    case documentNotFounded
}

class ConsultationViewModel: ChattingViewModel {
    @Published var showChattingRoom: Bool = false
    
    /// 상담처리 메소드
    ///  - 상담시 디자이너와 채팅할 수 있는 채팅방 생성 및 채팅 뷰로 이동할 수 있게 showChattingRoom 변수를 true로 할당해 트리거 발생시킴
    func proccessConsulation(designerId: String, post: Post?) {
         guard let customerId = Auth.auth().currentUser?.uid else {
             return
         }
        
        // TODO: post에 designerId 정상 구현시 바꿔야함
        let designerId = "XI2akegeOOOUvaHWgbbxqVD3N683"
        
        setChatRoomList(customerId: customerId, designerId: designerId, post: post)
    }
    
    /// 채팅방 생성 메소드
    ///  - FireStore에 Customer, Designer마다 채팅방에 접근할 수 있는 ID 데이터를 apeend
    ///   FireStore작업이 완료되면 RealTimeDatabase에 채팅방 데이터 생성
    private final func setChatRoomList(customerId: String, designerId: String, post: Post?) {
        let chatRoom: ChatRoom = ChatRoom()
        
        let clientColRef = storeService.collection("clients")
        let designerColRef = storeService.collection("designers")
        
        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let customerDocument = try transaction.getDocument(clientColRef.document(customerId))
                let designerDocument = try transaction.getDocument(designerColRef.document(designerId))
                
                // 채팅방 생성 전 기존 채팅내역이 있는지 확인
                let customerChatRooms = customerDocument.get("chatRooms") as? [String] ?? []
                let designerChatRooms = designerDocument.get("chatRooms") as? [String] ?? []
                
                guard customerDocument.exists && designerDocument.exists else {
                    throw ChattingRommCRUD.documentNotFounded
                }
                
                let commonChatRooms = customerChatRooms.compactMap { $0.trimmingCharacters(in: .whitespaces) }.filter {
                    !$0.isEmpty && designerChatRooms.contains($0)
                }
                
                // 채팅방 생성
                if commonChatRooms.count > 0 {
                    super.chatRoomId = commonChatRooms.first ?? ""
                } else {
                    super.chatRoomId = chatRoom.id
                    transaction.updateData(["chatRooms": FieldValue.arrayUnion([chatRoom.id])], forDocument: customerDocument.reference)
                    transaction.updateData(["chatRooms": FieldValue.arrayUnion([chatRoom.id])], forDocument: designerDocument.reference)
                }
                self.sendBoardBubble(content: "이 게시물 보고 상담하러 왔어요", imagePath: post?.photos[0].imageURL ?? "", sender: customerId)
            } catch let fetchError as NSError {
                debugPrint(fetchError.description)
                errorPointer?.pointee = fetchError
            }
            return
        })
        { (object, error) in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
                self.showChattingRoom = false
            } else {
                debugPrint("Transaction successfully committed!")
                self.showChattingRoom = true
            }
        }
        
    }
}
