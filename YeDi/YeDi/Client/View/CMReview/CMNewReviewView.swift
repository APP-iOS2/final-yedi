//
//  CMNewReviewView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI
import PhotosUI

/// 리뷰 작성 뷰
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
    
    var reservation: Reservation
    
    /// 업로드 상태에 따른 버튼 텍스트
    var buttonText: String {
        return isUploading ? "업로드 중..." : "리뷰 등록"
    }
    
    /// 리뷰 유효성 검사
    var isReadyToSave: Bool {
        return !selectedPhotoURLs.isEmpty && !selectedKeywords.isEmpty && !reviewContent.isEmpty
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            ScrollView {
                CMReservationInfoView(reservation: reservation)
                
                Spacer(minLength: 10)
                
                CMReviewSelectPhotosView(selectedPhotoURLs: $selectedPhotoURLs)
                
                CMReviewSelectKeywordsView(selectedKeywords: $selectedKeywords)
                
                CMReviewGiveScoreView(reviewScore: $reviewScore)
                
                CMReviewWriteContentView(reviewContent: $reviewContent)
                
                Spacer()
            }
            saveButton
        }
        .onDisappear {
            isUploading.toggle()
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton(color: nil, action: {})
            }
        }
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
                
                guard let reservationId = reservation.id else { return }
                
                var styles: [String] = []
                for hairStyle in reservation.hairStyle {
                    styles.append(hairStyle.name)
                }
                
                // MARK: - 리뷰 저장 로직
                if let clientId = userAuth.currentClientID {
                    let newReview = Review(
                        id: UUID().uuidString,
                        reviewer: clientId,
                        date: FirebaseDateFomatManager.sharedDateFommatter.firebaseDate(from: Date()),
                        keywordReviews: selectedKeywords,
                        designerScore: reviewScore,
                        content: reviewContent,
                        imageURLStrings: selectedPhotoURLs,
                        reservationId: reservationId,
                        style: styles.joined(separator: ", "),
                        designer: reservation.designerUID
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
        })
        .buttonModifier(.mainColor)
        .padding()
    }
}

#Preview {
    CMNewReviewView(reservation: Reservation(clientUID: "", designerUID: "", reservationTime: "", hairStyle: [], isFinished: true))
}
