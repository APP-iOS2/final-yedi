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
    
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    
    @State private var isShowingAlert: Bool = false
    
    @State private var myDate = Date()
    
    @State private var selectedPhotoURLs: [String] = []
    
    @State private var selectedKeywords: [Keyword] = []
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
            
            CMReviewCreatePhotosView(selectedPhotoURLs: $selectedPhotoURLs)
            
            CMReviewCreateKeywordsView(selectedKeywords: $selectedKeywords)
            
            CMReviewCreateDesignerScoreView(designerScore: $designerScore)
            
            CMReviewCreateContentView(reviewContent: $reviewContent)
            
            Spacer()
            
            Button(action: {
                if isOkayToSave() {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "YYYY.MM.dd."
                    let writtenDate = formatter.string(from: Date())
                    
                    let newReview = Review(
                        id: UUID().uuidString,
                        reviewer: userAuth.currentClientID ?? "",
                        date: writtenDate,
                        keywordReviews: selectedKeywords,
                        designerScore: designerScore,
                        content: reviewContent,
                        imageURLStrings: selectedPhotoURLs,
                        reservationId: UUID().uuidString,
                        style: "펌, 염색",
                        designer: UUID().uuidString
                    )
                    
                    Task {
                        await reviewViewModel.uploadReview(review: newReview)
                    }
                    
                    dismiss()
                } else {
                    isShowingAlert.toggle()
                }
            }, label: {
                Text("리뷰 등록")
                    .frame(width: 330, height: 30)
            })
            .buttonStyle(.borderedProminent)
            .tint(.black)
        }
        .toolbar(.hidden, for: .tabBar)
        .alert("모든 항목을 채워주세요", isPresented: $isShowingAlert) {
            Button(role: .cancel) {
                isShowingAlert.toggle()
            } label: {
                Text("확인")
            }
        }
    }
    
    func isOkayToSave() -> Bool {
        return !selectedPhotoURLs.isEmpty && !selectedKeywords.isEmpty && !reviewContent.isEmpty ? true : false
    }
}

#Preview {
    CMReviewCreateMainView()
}
