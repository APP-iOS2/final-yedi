//
//  CMHistoryCellView.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/24.
//

import SwiftUI
import FirebaseFirestore

/// 예약 내역 셀 뷰
struct CMHistoryCellView: View {
    // MARK: - Properties
    @EnvironmentObject var cmHistoryViewModel: CMHistoryViewModel
    
    @State private var designer: Designer = Designer(
        name: "",
        email: "",
        phoneNumber: "",
        designerScore: 0,
        reviewCount: 0,
        followerCount: 0,
        skill: [],
        chatRooms: [],
        birthDate: "",
        gender: "",
        rank: Rank.Designer,
        designerUID: ""
    )
    @State private var shop: Shop = Shop(
        shopName: "",
        headAddress: "",
        subAddress: "",
        detailAddress: "",
        openingHour: "",
        closingHour: "",
        closedDays: []
    )
    @State private var review: Review = Review(
        reviewer: "",
        date: "",
        keywordReviews: [],
        designerScore: 0,
        content: "",
        imageURLStrings: [],
        reservationId: "",
        style: "",
        designer: ""
    )
    @State private var reservationDate: String = ""
    
    
    var reservation: Reservation
    
    /// 디데이 텍스트
    var dDayText: String {
        let currentDateString = FirebaseDateFomatManager.sharedDateFommatter.firebaseDate(from: Date())
        let currentDate = FirebaseDateFomatManager.sharedDateFommatter.changeDateString(transition: "MM-dd", from: currentDateString)
        let reservationDate = FirebaseDateFomatManager.sharedDateFommatter.changeDateString(transition: "MM-dd", from: reservation.reservationTime)
        
        let startDate = FirebaseDateFomatManager.sharedDateFommatter.changeStringToDate(dateString: currentDate)
        let endDate = FirebaseDateFomatManager.sharedDateFommatter.changeStringToDate(dateString: reservationDate)
        let offsetComps = Calendar.current.dateComponents(
            [.year, .month, .day], from: startDate, to: endDate
        )
        
        let dDay = offsetComps.day ?? 0
        
        return dDay == 0 ? "D-Day" : "D-\(dDay)"
    }
    
    /// 리뷰 작성 여부를 나타내는 Bool타입 변수
    var isReviewExist: Bool {
        return review.reviewer.isEmpty ? false : true
    }
    
    /// 리뷰 작성 여부에 따른 텍스트
    var reviewStatusText: String {
        return isReviewExist ? "리뷰 작성 완료" : "리뷰 작성 전"
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - 뱃지 섹션
            HStack {
                Spacer()
                if reservation.isFinished {
                    Text("\(reviewStatusText)")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isReviewExist ? Color.gray3 : .sub)
                        )
                        .padding([.top, .trailing], 10)
                } else {
                    Text("\(dDayText)")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(dDayText == "D-Day" ? .sub : .black)
                        )
                        .padding([.top, .trailing], 10)
                }
            }
            
            Divider()
            
            Group {
                // MARK: - 디자이너 정보 섹션
                HStack {
                    Text("디자이너 정보")
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(designer.name)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primaryLabel)
                }
                .padding([.top, .horizontal])
                
                // MARK: - 샵 정보 섹션
                HStack {
                    Text("샵 정보")
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(shop.shopName)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primaryLabel)
                }
                .padding([.top, .horizontal])
                
                // MARK: - 예약 일시 섹션
                HStack {
                    Text("예약일시")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    Spacer()
                    Text("\(reservationDate) 예약")
                        .fontWeight(.bold)
                        .font(.subheadline)
                        .foregroundStyle(Color.primaryLabel)
                }
                .padding([.top, .horizontal])
                
                // MARK: - 스타일 섹션
                HStack(alignment: .top) {
                    Text("스타일")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Group {
                            ForEach(reservation.hairStyle) { hairStyle in
                                VStack(alignment: .trailing) {
                                    Text("\(hairStyle.name)")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.primaryLabel)
                                    
                                    Text("\(hairStyle.price)원")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                .padding([.top, .horizontal])
            }
            .onAppear {
                Task {
                    let dCollectionRef = Firestore.firestore().collection("designers")
                    let rvCollectionRef = Firestore.firestore().collection("reviews")
                    
                    guard let reservationId = reservation.id else { return }
                    
                    // MARK: - 디자이너 및 샵 정보 패치
                    do {
                        let docRef = dCollectionRef.document(reservation.designerUID)
                        let document = try await docRef.getDocument()
                        if let _ = document.data() {
                            
                            self.designer = try document.data(as: Designer.self)
                            
                            let shopRef = docRef.collection("shop")
                            let shopSnapshot = try await shopRef.getDocuments()
                            let shopData = shopSnapshot.documents.compactMap { document in
                                return try? document.data(as: Shop.self)
                            }
                            
                            if let shop = shopData.first {
                                self.shop = shop
                            }
                        }
                    } catch {
                        print("Error fetching designer info: \(error)")
                    }
                    
                    // MARK: - 예약건에 해당하는 리뷰 패치
                    do {
                        let docSnapshot = try await rvCollectionRef
                            .whereField("reviewer", isEqualTo: reservation.clientUID)
                            .whereField("reservationId", isEqualTo: reservationId)
                            .getDocuments()
                        
                        for doc in docSnapshot.documents {
                            if let review = try? doc.data(as: Review.self) {
                                self.review = review
                            }
                        }
                    } catch {
                        print("Error fetching reservation list: \(error)")
                    }
                    
                    reservationDate = FirebaseDateFomatManager.sharedDateFommatter.changeDateString(transition: "MM월 dd일 HH시 mm분", from: reservation.reservationTime)
                }
            }
        }
    }
}

#Preview {
    CMHistoryCellView(reservation: Reservation(clientUID: "", designerUID: "", reservationTime: "", hairStyle: [], isFinished: false))
}
