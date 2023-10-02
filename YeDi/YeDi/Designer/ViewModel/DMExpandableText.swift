//
//  DMExpandableText.swift
//  YeDi
//
//  Created by 박찬호 on 2023/10/03.
//

import SwiftUI

// MARK: - DMExpandableText 뷰
struct DMExpandableText: View {
    @State private var expanded: Bool = false  // 텍스트 확장 여부
    @State private var isTruncated: Bool = false  // 텍스트가 생략되는지 여부
    
    var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // MARK: - 확장된 상태
            if expanded {
                Text(text)
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 5)
                
                // 접기 버튼
                HStack {
                    Spacer()
                    Button("접기") {
                        withAnimation {
                            self.expanded.toggle()
                        }
                    }
                    .foregroundColor(Color.gray)
                    .font(.caption)
                }
            } else {
                // MARK: - 축소된 상태
                HStack {
                    Text(text)
                        .lineLimit(1)  // 한 줄로 제한
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(key: ViewWidthKey.self, value: proxy.size.width)
                            }
                        )
                        .foregroundColor(Color.black)
                    
                    // 텍스트가 생략되면 더보기 버튼 표시
                    if isTruncated {
                        Button("...더보기") {
                            withAnimation {
                                self.expanded.toggle()
                            }
                        }
                        .foregroundColor(Color.gray)
                        .font(.caption)
                    }
                }
                .onPreferenceChange(ViewWidthKey.self) { width in
                    let textWidth = text.widthOfString(usingFont: .systemFont(ofSize: 14))
                    self.isTruncated = textWidth > width  // 생략 여부 판단
                }
                .lineLimit(1)
                .padding(.horizontal, 5)
            }
        }
        .animation(.easeInOut, value: expanded)  // 확장/축소 애니메이션
    }
}

// MARK: - 문자열 확장
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

// MARK: - ViewWidthKey
struct ViewWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
