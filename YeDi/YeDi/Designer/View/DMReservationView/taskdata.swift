//
//  taskdata.swift
//  YeDi
//
//  Created by 송성욱 on 10/13/23.
//

import SwiftUI

struct Tasks: Identifiable {
    var id: UUID = .init()
    var dateAdded: Date
    var reservationName: String
    var reservationDC: String
    
}

var sampleTasks: [Tasks] = [
    .init(dateAdded: Date(timeIntervalSince1970: 1650022160), reservationName: "송성욱", reservationDC: "hello test")
]
