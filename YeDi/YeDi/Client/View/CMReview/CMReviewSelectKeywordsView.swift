//
//  CMReviewSelectKeywordsView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI

struct CMReviewSelectKeywordsView: View {
    // MARK: - Properties
    @Binding var selectedKeywords: [Keyword]
    
    let keywordCategories: [String] = KeywordCategory.allCases.map { $0.rawValue }
    
    // MARK: - Body
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
                                    KeywordButton(selectedKeywords: $selectedKeywords, index: index)
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                }
            })
            .scrollIndicators(.never)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 40, trailing: 0))
        } header: {
            VStack {
                HStack {
                    Text("어떤 점이 좋았나요?")
                        .fontWeight(.semibold)
                        .padding(.leading)
                    Spacer()
                }
                HStack {
                    Text("최대 5개까지 선택할 수 있어요.")
                        .foregroundStyle(.gray)
                        .padding(.leading)
                    Spacer()
                }
            }
            Divider()
                .frame(width: 360)
                .background(Color.systemFill)
                .padding(.bottom, 10)
        }
    }
}

struct KeywordButton: View {
    // MARK: - Properties
    @Binding var selectedKeywords: [Keyword]
    
    /// 키워드 선택에 따른 실시간 UI 처리용 배열
    @State private var displayingKeywords: [Keyword] = keywords
    @State private var isShowingCountLimitAlert: Bool = false
    
    var index: Int = 0
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            selectKeyword(index: index)
        }) {
            if displayingKeywords[index].isSelected {
                Text("\(keywords[index].keyword)")
                    .foregroundStyle(Color.primaryLabel)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray6)
                    )
            } else {
                Text("\(keywords[index].keyword)")
                    .foregroundStyle(Color.primaryLabel)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.systemFill, lineWidth: 1)
                    )
            }
        }
        .alert("최대 5개의 키워드 리뷰만 선택 가능합니다.", isPresented: $isShowingCountLimitAlert) {
            Button(role: .cancel) {
                isShowingCountLimitAlert.toggle()
            } label: {
                Text("확인")
            }
        }
    }
    
    // MARK: - Methods
    /// 키워드 선택 처리 함수
    func selectKeyword(index: Int) {
        if displayingKeywords[index].isSelected {
            selectedKeywords.removeAll(where: { $0 == keywords[index] })
            displayingKeywords[index].isSelected.toggle()
        } else {
            if selectedKeywords.count >= 5 {
                isShowingCountLimitAlert.toggle()
            } else {
                selectedKeywords.append(keywords[index])
                displayingKeywords[index].isSelected.toggle()
            }
        }
    }
}

#Preview {
    CMReviewSelectKeywordsView(selectedKeywords: .constant([]))
}
