//
//  CommonBubble.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/26.
//

import Foundation

struct CommonBubble: Codable, Identifiable {
    var id: String = UUID().uuidString
    var content: String?
    var imagePath: String?
    var date: String
    var sender: String
    var isRead: Bool
    var messageType: MessageType
    
    enum CodingKeys: CodingKey {
        case id
        case content
        case imagePath
        case date
        case sender
        case isRead
        case messageType
    }
    
    init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy:CodingKeys.self)
        id = try values.decode(String.self, forKey:.id)
        date = try values.decode(String.self, forKey:.date)
        sender = try values.decode(String.self, forKey:.sender)
        isRead = try values.decode(Bool.self, forKey: .isRead)
        
        let typeString = try values.decode(String.self, forKey:.messageType)
        messageType = MessageType(rawValue:typeString) ?? .textBubble
        
        switch messageType {
        case .imageBubble:
            imagePath = try? values.decode(String.self, forKey:.imagePath)
        case .textBubble:
            content  =  try? values.decode(String.self, forKey:.content)
        case .boardBubble:
            imagePath = try? values.decode(String.self, forKey:.imagePath)
            content  =  try? values.decode(String.self, forKey:.content)
        }
    }
    
    init(content: String, date: String, sender: String, isRead: Bool) { //text bubble
        self.content = content
        self.date = date
        self.sender = sender
        self.isRead = isRead
        self.messageType = MessageType.textBubble
    }
    
    init(imagePath: String, date: String, sender: String, isRead: Bool) { //image bubble
        self.imagePath = imagePath
        self.date = date
        self.sender = sender
        self.isRead = isRead
        self.messageType = MessageType.imageBubble
    }

    init(content: String, imagePath: String, date: String, sender: String, isRead: Bool) { //board bubble
        self.content = content
        self.imagePath = imagePath
        self.date = date
        self.sender = sender
        self.isRead = isRead
        self.messageType = MessageType.boardBubble
    }

    
}
