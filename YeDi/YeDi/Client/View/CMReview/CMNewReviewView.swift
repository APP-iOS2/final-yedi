//
//  CMNewReviewView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI
import PhotosUI

struct CMNewReviewView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    
    @State private var selectedPhotoURLs: [String] = []
    @State private var selectedKeywords: [Keyword] = []
    @State private var reviewScore: Int = 0
    @State private var reviewContent: String = ""
    
    @State private var isShowingValidationAlert: Bool = false
    @State private var isUploading: Bool = false
    
    var buttonText: String {
        return isUploading ? "업로드 중..." : "리뷰 등록"
    }
    
    /// 리뷰 유효성 검사
    var isReadyToSave: Bool {
        return !selectedPhotoURLs.isEmpty && !selectedKeywords.isEmpty && !reviewContent.isEmpty
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            CMReservationInfoView()
            
            Spacer(minLength: 55)
            
            CMReviewSelectPhotosView(selectedPhotoURLs: $selectedPhotoURLs)
            
            CMReviewSelectKeywordsView(selectedKeywords: $selectedKeywords)
            
            CMReviewGiveScoreView(reviewScore: $reviewScore)
            
            CMReviewWriteContentView(reviewContent: $reviewContent)
            
            Spacer()
            
            saveButton
        }
        .onDisappear {
            isUploading.toggle()
        }
        .toolbar(.hidden, for: .tabBar)
        .alert("모든 항목을 채워주세요", isPresented: $isShowingValidationAlert) {
            Button(role: .cancel) {
                isShowingValidationAlert.toggle()
            } label: {
                Text("확인")
            }
        }
    }
    
    // MARK: - Custom Save Button
    private var saveButton: some View {
        Button(action: {
            if isReadyToSave {
                isUploading.toggle()
                
                if let clientId = userAuth.currentClientID {
                    let newReview = Review(
                        id: UUID().uuidString,
                        reviewer: clientId,
                        date: SingleTonDateFormatter.sharedDateFommatter.firebaseDate(from: Date()),
                        keywordReviews: selectedKeywords,
                        designerScore: reviewScore,
                        content: reviewContent,
                        imageURLStrings: selectedPhotoURLs,
                        reservationId: UUID().uuidString,
                        style: "펌, 염색",
                        designer: UUID().uuidString
                    )
                    
                    Task {
                        await reviewViewModel.uploadReview(review: newReview)
                        dismiss()
                    }
                }
            } else {
                isShowingValidationAlert.toggle()
            }
        }, label: {
            Text(buttonText)
                .frame(width: 330, height: 30)
        })
        .buttonStyle(.borderedProminent)
        .tint(.black)
    }
}

#Preview {
    CMNewReviewView()
}
