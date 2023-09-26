//
//  CommonBubble.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/26.
//

import Foundation

struct CommonBubble: Codable, Identifiable {
    var id: String
    var content: String?
    var imagePath: String?
    var date: String
    var sender: String
    var messageType: MessageType
    
     enum CodingKeys: String, CodingKey {
        case id
        case content
        case imagePath
        case date
        case sender
        case messageType
     }

     init(from decoder : Decoder) throws {
         let values = try decoder.container(keyedBy:CodingKeys.self)
         id = try values.decode(String.self, forKey:.id)
         date = try values.decode(String.self, forKey:.date)
         sender = try values.decode(String.self, forKey:.sender)
         
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
    
}
