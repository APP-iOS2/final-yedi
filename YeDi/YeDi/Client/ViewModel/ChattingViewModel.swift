//
//  ChattingViewModel.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/25.
//

import Foundation
import Firebase
//import FirebaseAuth


final class ChattingViewModel: ObservableObject {
    let realTimeDataBase = Database.database().reference()
    
    func tempset() {
        realTimeDataBase.child("isOn").observe(.value) { DataSnapshot in
            print(DataSnapshot)
        }
    }
    
    func setDataStructure() {
        for index in 0 ..< chatRoomsampleData[0].textBubbles!.count {
            if let textBubble = chatRoomsampleData[0].textBubbles?[index]{
                realTimeDataBase.child("chatRooms").child(chatRoomsampleData[0].id).child(textBubble.id).setValue(["content": "\(textBubble.content)"])
//                realTimeDataBase.child("chatRooms").child(chatRoomsampleData[0].id).child(textBubble.id).setValue(["date": "\(textBubble.date)"])
//                realTimeDataBase.child("chatRooms").child(chatRoomsampleData[0].id).child(textBubble.id).setValue(["sender": "\(textBubble.sender)"])
//                realTimeDataBase.child("chatRooms").child(chatRoomsampleData[0].id).child(textBubble.id).setValue(["messageType": "\(textBubble.messageType.rawValue)"])
            }
        }
        for index in 0 ..< chatRoomsampleData[0].imageBubbles!.count {
            if let imageBubble = chatRoomsampleData[0].imageBubbles?[index]{
                realTimeDataBase.child("chatRooms").child(chatRoomsampleData[0].id).child(imageBubble.id).setValue(["content": "\(imageBubble.imagePath)"])
//                realTimeDataBase.child("chatRooms").child(chatRoomsampleData[0].id).child(imageBubble.id).setValue(["date": "\(imageBubble.date)"])
//                realTimeDataBase.child("chatRooms").child(chatRoomsampleData[0].id).child(imageBubble.id).setValue(["sender": "\(imageBubble.sender)"])
//                realTimeDataBase.child("chatRooms").child(chatRoomsampleData[0].id).child(imageBubble.id).setValue(["messageType": "\(imageBubble.messageType.rawValue)"])
            }
        }
    }
}

let chatRoomsampleData: [ChatRoom] = [
    .init(
        textBubbles: [
            TextBubble(content: "안녕하세요! 궁금한 게 있어서 연락 드려요",
                       date: "20230925133501",
                       sender: "customerUser1"),
            TextBubble(content: "안녕하세요! 혹시 스타일 첨부 가능하신가요!?",
                       date: "20230925133502",
                       sender: "designerUserId1"),
            TextBubble(content: "혹시 이런 스타일 보고왔는데 가능한가요?",
                       date: "20230925133504",
                       sender: "customerUser1")],
        imageBubbles: [
            ImageBubble(ImagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNhuWEw7jWxwly899FoiaMMxuWQa6YfGuo6Q&usqp=CAU",
                        date: "20230925133503",
                        sender: "customerUser1")]
    )
]
