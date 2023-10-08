//
//  CMReviewCreateKeywordsView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI

struct CMReviewCreateKeywordsView: View {
    @Binding var selectedKeywords: [Keyword]
    
    @State private var displayedKeywords: [Keyword] = keywords
    @State private var isShowingAlert: Bool = false
    
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
                                        selectKeyword(index: index)
                                    }) {
                                        if displayedKeywords[index].isSelected {
                                            Text("\(keywords[index].keyword)")
                                                .foregroundStyle(.white)
                                                .padding(10)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(Color.subColor)
                                                )
                                        } else {
                                            Text("\(keywords[index].keyword)")
                                                .foregroundStyle(.black)
                                                .padding(10)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color(white: 0.9), lineWidth: 1)
                                                )
                                        }
                                    }
                                    .alert("최대 5개의 키워드 리뷰만 선택 가능합니다.", isPresented: $isShowingAlert) {
                                        Button(role: .cancel) {
                                            isShowingAlert.toggle()
                                        } label: {
                                            Text("확인")
                                        }

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
            VStack {
                HStack {
                    Text("어떤 점이 좋았나요?")
                        .padding(.leading)
                        .fontWeight(.semibold)
                    Spacer()
                }
                HStack {
                    Text("최대 5개까지 선택할 수 있어요.")
                        .padding(.leading)
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
            Divider()
                .frame(width: 360)
                .padding(.bottom, 10)
        }
    }
    
    func selectKeyword(index: Int) {
        if displayedKeywords[index].isSelected {
            selectedKeywords.removeAll(where: { $0 == keywords[index] })
            displayedKeywords[index].isSelected.toggle()
        } else {
            if selectedKeywords.count >= 5 {
                isShowingAlert.toggle()
            } else {
                selectedKeywords.append(keywords[index])
                displayedKeywords[index].isSelected.toggle()
            }
        }
    }
}

#Preview {
    CMReviewCreateKeywordsView(selectedKeywords: .constant([]))
}
