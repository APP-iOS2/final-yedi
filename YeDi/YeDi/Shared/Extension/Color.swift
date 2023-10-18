//
//  Color.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/08.
//

import SwiftUI

extension Color {
    /// 16진수 String 색상코드로 Color 설정
    /// - Parameters:
    ///   - hex: 16진수 색상코드
    ///   - alpha: 투명도
    init(hex: String, alpha: Double = 1.0) {
        var formattedHex = hex
        if formattedHex.hasPrefix("#") {
            formattedHex.removeFirst()
        }

        let scanner = Scanner(string: formattedHex)
        var rgb: UInt64 = 0

        scanner.scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension Color {
    // MARK: - custom color
    static let mainColor = Color("mainColor")
    static let subColor = Color("subColor")
    static let pointColor = Color("pointColor")
    static let brightGrayColor = Color(hex: "F6F6F6")
    
    // MARK: - gray
    static let gray1 = Color(UIColor.systemGray)
    static let gray2 = Color(UIColor.systemGray2)
    static let gray3 = Color(UIColor.systemGray3)
    static let gray4 = Color(UIColor.systemGray4)
    static let gray5 = Color(UIColor.systemGray5)
    static let gray6 = Color(UIColor.systemGray6)
    
    // MARK: - label
    /// 주요 콘텐츠 레이블 컬러
    static let primaryLabel = Color(UIColor.label)
    /// 보조 콘텐츠 레이블 컬러
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    /// 3차 콘텐츠 레이블 컬러
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    /// 4차 콘텐츠 레이블 컬러
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)
    
    // MARK: - text
    /// placceholder 콘텐츠 레이블 컬러
    static let placeholderText = Color(UIColor.placeholderText)
    
    // MARK: - separator
    /// Divider 같은 구분선 컬러
    static let separator = Color(UIColor.separator)
    
    // MARK: - fill
    static let systemFill = Color(UIColor.systemFill)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
    
    // MARK: - standard content system background
    /// 기본 인터페이스 배경색
    static let systemBackground = Color(UIColor.systemBackground)
    /// 메인 배경 위에 레이어되는 콘텐츠 배경색 (보조)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    /// secondarySystemBackground 위에 겹쳐진 콘텐츠 배경색
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    // MARK: - grouped content backgorund
    /// 그룹화된 인터페이스 기본 배경색
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    /// 그룹화된 인터페이스 기본 배경 위에 겹쳐진 콘텐츠 배경색 (보조)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    /// secondarySystemGroupedBackground 위에 겹쳐진 콘텐츠 배경색
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
}

