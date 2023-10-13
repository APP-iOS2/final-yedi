//
//  DesignerStyle.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import Foundation

struct Keyword: Identifiable, Equatable, Codable {
    var id: String = UUID().uuidString
    var keyword: String
    var isSelected: Bool
    var category: KeywordCategory
}

enum KeywordCategory: String, CaseIterable, Codable {
    case style = "스타일"
    case service = "시술/서비스"
    case etc = "가격/기타"
}

var keywords: [Keyword] = [
    Keyword(keyword: "🙌 스타일 추천을 잘해줘요", isSelected: false, category: .style),
    Keyword(keyword: "😎 트렌디해요", isSelected: false, category: .style),
    Keyword(keyword: "💚 원하는 스타일로 잘해줘요", isSelected: false, category: .style),
    Keyword(keyword: "🌹 고급스러워요", isSelected: false, category: .style),
    Keyword(keyword: "💪 손상이 적어요", isSelected: false, category: .style),
    Keyword(keyword: "✂️ 시술이 꼼꼼해요", isSelected: false, category: .service),
    Keyword(keyword: "🪄 관리법을 잘 알려줘요", isSelected: false, category: .service),
    Keyword(keyword: "🫶 손이 빨라요", isSelected: false, category: .service),
    Keyword(keyword: "💬 상담이 자세해요", isSelected: false, category: .service),
    Keyword(keyword: "😀 친절해요", isSelected: false, category: .service),
    Keyword(keyword: "✨ 매장이 청결해요", isSelected: false, category: .etc),
    Keyword(keyword: "🧴 좋은 제품을 사용해요", isSelected: false, category: .etc),
    Keyword(keyword: "💲 가격이 합리적이에요", isSelected: false, category: .etc),
    Keyword(keyword: "🚘 주차하기 편해요", isSelected: false, category: .etc),
    Keyword(keyword: "🪑 대기공간이 잘 되어있어요", isSelected: false, category: .etc),
]
