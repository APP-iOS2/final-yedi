//
//  TextBubble.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/25.
//

import Foundation

struct TextBubble: Codable {
    /// 구조체 ID
    var id: String
    /// 내용
    var content: String
    /// 보낸시간
    var date: String
    /// 보낸사람 UserID
    var sender: String
    
    var messageType: MessageType = MessageType.textBubble
    
    init(id: String = UUID().uuidString, content: String, date: String, sender: String) {
        self.id = id
        self.content = content
        self.date = date
        self.sender = sender
    }
}
