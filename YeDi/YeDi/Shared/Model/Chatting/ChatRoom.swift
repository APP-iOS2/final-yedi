//
//  ChatRoom.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/25.
//

import Foundation

struct ChatRoom: Codable, Equatable {
    var id: String = UUID().uuidString
    var chattingBubles: [CommonBubble]?
    var totalUnReadCount: Int?
}

