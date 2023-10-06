//
//  CMReviewCreateMainView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI
import PhotosUI

struct CMReviewCreateMainView: View {
    @Environment(\.dismiss) var dismiss
    @State private var myDate = Date()
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedPhotoData: [Data] = []
    
    @State private var selectedKeywords: [String] = []
    @State private var designerScore: Int = 0
    @State private var reviewContent: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Group {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("박채영 디자이너")
                            .font(.title3)
                        Text("디자인 컷")
                            .font(.title)
                    }
                    .fontWeight(.semibold)
                    
                    HStack {
                        Text("2023년 7월 11일 12:30 예약")
                        Spacer()
                    }
                }
                .offset(y: 65)
                
                Spacer()
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .frame(height: 300)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    .opacity(0.3)
            )
            .offset(y: -20)
            
            Spacer(minLength: 55)
            
            CMReviewCreatePhotosView(selectedPhoto: $selectedPhoto, selectedPhotoData: $selectedPhotoData)
            
            CMReviewCreateKeywordsView(selectedKeywords: $selectedKeywords)
            
            CMReviewCreateDesignerScoreView(designerScore: $designerScore)
            
            CMReviewCreateContentView(reviewContent: $reviewContent)
            
            Spacer()
            
            Button(action: {
                // TODO: 리뷰 작성 백엔드 추가하기
                dismiss()
            }, label: {
                Text("리뷰 등록")
                    .frame(width: 330, height: 30)
            })
            .buttonStyle(.borderedProminent)
            .tint(.black)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    CMReviewCreateMainView()
}
