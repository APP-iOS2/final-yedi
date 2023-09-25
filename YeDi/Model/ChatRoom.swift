//
//  ChatRoom.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/25.
//

import Foundation

struct ChatRoom: Codable {
    var id: String = UUID().uuidString
    var textBubbles: [TextBubble]?
    var imageBubbles: [ImageBubble]?
    var boardBubbles: [BoardBubble]?
}

