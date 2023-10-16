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
    static let mainColor = Color("mainColor")
    static let subColor = Color("subColor")
    static let pointColor = Color("pointColor")
    static let brightGrayColor = Color(hex: "F6F6F6")
}
