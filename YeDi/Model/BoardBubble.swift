//
//  BoardBubble.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/25.
//

import Foundation

struct BoardBubble: Codable {
    /// 구조체 ID
    var id: String
    /// 텍스트내용
    var content: String
    /// 내용
    var ImagePath: String
    /// 보낸시간
    var date: String
    /// 보낸사람 UserID
    var sender: String
    
    var messageType: MessageType = MessageType.boardBubble
    
    init(id: String = UUID().uuidString, content: String, ImagePath: String, date: String, sender: String) {
        self.id = id
        self.content = content
        self.ImagePath = ImagePath
        self.date = date
        self.sender = sender
    }
}
