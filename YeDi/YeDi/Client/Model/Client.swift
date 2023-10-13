//
//  Client.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/10/04.
//

import Foundation

struct Client: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    var profileImageURLString: String
    let phoneNumber: String
    let gender: String
    let birthDate: String
    let favoriteStyle: String
    var chatRooms: [String]
    
}
