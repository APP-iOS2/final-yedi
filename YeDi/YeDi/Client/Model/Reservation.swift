//
//  Reservation.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/10/19.
//

import Foundation
import FirebaseFirestoreSwift

struct Reservation: Codable, Identifiable {
    @DocumentID var id: String?
    var clientUID: String
    let designerUID: String
    let reservationTime: String
    let hairStyle: [HairStyle]
    var isFinished: Bool
    
    enum CodingKeys: CodingKey {
        case clientUID
        case designerUID
        case reservationTime
        case hairStyle
        case isFinished
    }
}

enum HairType: String, CaseIterable, Codable {
    case cut = "커트"
    case perm = "펌"
    case color = "염색"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        switch rawValue {
        case "커트":
            self = .cut
        case "펌":
            self = .perm
        case "염색":
            self = .color
        default:
            self = .cut
        }
    }
}

struct HairStyle: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    let name: String
    let type: HairType
    let price: Int
}

extension HairStyle {
    static let data: [HairStyle] = [
        HairStyle(name: "레이어드컷", type: .cut, price: 45000),
        HairStyle(name: "허쉬컷", type: .cut, price: 46000),
        HairStyle(name: "가일컷", type: .cut, price: 48000),
        HairStyle(name: "원랭스컷", type: .cut, price: 49000),
//        HairStyle(name: "리프컷", type: .cut, price: 47000),
//        HairStyle(name: "픽시컷", type: .cut, price: 46000),
//        HairStyle(name: "보브컷", type: .cut, price: 48000),
//        HairStyle(name: "뱅헤어", type: .cut, price: 47000),
//        HairStyle(name: "리프컷", type: .cut, price: 46000),
//        HairStyle(name: "아이비리그컷", type: .cut, price: 48000),
//        HairStyle(name: "포마드컷", type: .cut, price: 49000),
//        HairStyle(name: "울프컷", type: .cut, price: 48000),
//        HairStyle(name: "크롭컷", type: .cut, price: 47000),
//        HairStyle(name: "가일컷", type: .cut, price: 46000),
//        HairStyle(name: "투블럭컷", type: .cut, price: 49000),
//        HairStyle(name: "댄디컷", type: .cut, price: 48000),
        HairStyle(name: "애즈펌", type: .perm, price: 85000),
        HairStyle(name: "리프펌", type: .perm, price: 86000),
        HairStyle(name: "포마드펌", type: .perm, price: 80000),
        HairStyle(name: "가르마펌", type: .perm, price: 85000),
        HairStyle(name: "쉐도우펌", type: .perm, price: 92000),
//        HairStyle(name: "아이롱펌", type: .perm, price: 53000),
//        HairStyle(name: "가일펌", type: .perm, price: 55000),
//        HairStyle(name: "볼륨펌", type: .perm, price: 51000),
//        HairStyle(name: "베이비펌", type: .perm, price: 49000),
//        HairStyle(name: "히피펌", type: .perm, price: 54000),
//        HairStyle(name: "스왈로펌", type: .perm, price: 56000),
//        HairStyle(name: "레이어드펌", type: .perm, price: 53000),
//        HairStyle(name: "빌드펌", type: .perm, price: 57000),
//        HairStyle(name: "젤리펌", type: .perm, price: 55000),
//        HairStyle(name: "허쉬펌", type: .perm, price: 58000),
//        HairStyle(name: "내츄럴펌", type: .perm, price: 52000),
//        HairStyle(name: "바디펌", type: .perm, price: 53000),
        HairStyle(name: "뿌리염색", type: .color, price: 85000),
        HairStyle(name: "전체염색", type: .color, price: 115000),
        HairStyle(name: "부분염색", type: .color, price: 95000),
    ]
}
