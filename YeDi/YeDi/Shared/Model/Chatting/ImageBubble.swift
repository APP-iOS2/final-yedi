//
//  ImageBubble.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/25.
//

import Foundation

struct ImageBubble: Codable {
    /// 구조체 ID
    var id: String
    /// 이미지경로
    var imagePath: String
    /// 보낸시간
    var date: String
    /// 보낸사람 UserID
    var sender: String
    
    var messageType: MessageType = MessageType.imageBubble
    
    init(id: String = UUID().uuidString, imagePath: String, date: String, sender: String) {
        self.id = id
        self.imagePath = imagePath
        self.date = date
        self.sender = sender
    }
}
