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


class ConsultationViewModel: ChattingViewModel {
    @Published var showChattingRoom: Bool = false
    
    /// 상담처리 메소드
    ///  - 상담시 디자이너와 채팅할 수 있는 채팅방 생성 및 채팅 뷰로 이동할 수 있게 showChattingRoom 변수를 true로 할당해 트리거 발생시킴
    func proccessConsulation(post: Post) {
        // TODO: 접속한 아이디 가지고오고
        // TODO: 디자이너 ID가지고오고
        // TODO: RTDB에 구조 생성하고
        // TODO: Store Coustomer, Designer ChatRoom에 채팅방 ID Insert
        // TODO: showChattingRoom = true로 할당해 뷰가 sheet로 채팅방 입장
        
        // MARK: 로그인 구현시 사용할 메소드
        // guard let userId = fetchUserUID() else {
        //     return
        // }
        
        let userId = "client1"
        let designerId = "desinger2"
        
        setChatRoomList(customerId: userId, designerId: designerId, post: post)
    }
    
        // TODO: 데이터 Insert후에 결과를 보고 안될시에는 showChattingRoom = false, 그 반대는 true로
    /// 채팅방 생성 메소드
    ///  - FireStore에 Customer, Designer마다 채팅방에 접근할 수 있는 ID 데이터를 apeend
    ///   FireStore작업이 완료되면 RealTimeDatabase에 채팅방 데이터 생성
    private final func setChatRoomList(customerId: String, designerId: String, post content: Post) {
        let chatRoom: ChatRoom = ChatRoom()
        let colRef = storeService.collection("clients")

        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let customerDocument = try transaction.getDocument(colRef.document(customerId))

                transaction.updateData(["chatRooms": FieldValue.arrayUnion([chatRoom.id])], forDocument: customerDocument.reference)

                let designerDocument = try transaction.getDocument(colRef.document(designerId))

                transaction.updateData(["chatRooms": FieldValue.arrayUnion([chatRoom.id])], forDocument: designerDocument.reference)
                
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
            }
            
            self.sendBoardBubble(content: "이 게시물 보고 상담하러 왔어요", imagePath: content.photos[0].imageURL, sender: customerId)
            
            return
        }) { (object, error) in
            if let error = error {
               debugPrint("Transaction failed: \(error)")
            } else {
               debugPrint("Transaction successfully committed!")
            }
        }
    }
}
