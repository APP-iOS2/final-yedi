//
//  CMReviewCreateKeywordsView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI

struct CMReviewCreateKeywordsView: View {
    @Binding var selectedKeywords: [String]
    
    let keywordCategories: [String] = KeywordCategory.allCases.map { $0.rawValue }
    
    var body: some View {
        Section {
            ScrollView(.horizontal, content: {
                HStack {
                    ForEach(keywordCategories, id: \.self) { category in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(category)")
                                .fontWeight(.semibold)
                            ForEach(0..<keywords.count, id: \.self) { index in
                                if keywords[index].category.rawValue == category {
                                    Button(action: {
                                        selectedKeywords.append(keywords[index].keyword)
                                    }) {
                                        Text("\(keywords[index].keyword)")
                                            .foregroundStyle(keywords[index].isSelected ? .red : .black)
                                            .padding(10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 2)
                                                    .stroke(Color(white: 0.9), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                }
            })
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 40, trailing: 0))
            .scrollIndicators(.never)
        } header: {
            HStack {
                Text("어떤 점이 좋았나요?")
                    .padding(.leading)
                    .fontWeight(.semibold)
                Spacer()
            }
            Divider()
                .frame(width: 360)
                .padding(.bottom, 10)
        }
    }
}

#Preview {
    CMReviewCreateKeywordsView(selectedKeywords: .constant([]))
}
