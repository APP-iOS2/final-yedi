//
//  CMReservationHistoryDetailView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI
import MapKit
import FirebaseFirestore

/// 예약 내역 디테일 뷰
struct CMReservationHistoryDetailView: View {
    // MARK: - Properties
    @EnvironmentObject var cmHistoryViewModel: CMHistoryViewModel
    
    @State private var isShowingCancelSheet = false
    
    @State private var designerName: String = ""
    @State private var designerRank: String = ""
    @State private var designerShop: String = ""
    @State private var designerShopAddress: String = ""
    @State private var reservationDate: String = ""
    @State private var styles: [String] = []
    @State private var price: Int = 0
    
    @State private var region = MKCoordinateRegion()
    
    @State private var isShowingCopyAlert: Bool = false
    
    var reservation: Reservation
    
    var isUpcomingReservation: Bool {
        return reservation.isFinished ? true : false
    }
    
    /// 예약 상태에 따른 텍스트
    var reservationStatusText: String {
        return reservation.isFinished ? "지난 예약" : "다가오는 예약"
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 30) {
                Group {
                    // MARK: - 디자이너 정보 섹션
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(designerRank) \(designerName)")
                            .font(.title3)
                        ForEach(styles, id: \.self) { style in
                            Text("\(style)")
                                .font(.title)
                        }
                    }
                    .fontWeight(.semibold)
                    
                    // MARK: - 예약 정보 섹션
                    HStack {
                        Text(reservationDate)
                        Spacer()
                        Text(reservationStatusText)
                            .foregroundStyle(.white)
                            .padding(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
                            .background(
                                Capsule(style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.black)
                            )
                    }
                }
                .offset(y: 50)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .frame(height: 300)
                    .foregroundColor(.white)
                    .shadow(color: .gray3, radius: 5, x: 0, y: 5)
                    .opacity(0.2)
            )
            .offset(y: -50)
            
            Spacer(minLength: 30)
            
            // MARK: - 샵 정보 섹션
            VStack(alignment: .leading) {
                Text("샵 정보")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                
                Divider()
                    .frame(width: 360)
                    .background(Color.systemFill)
                    .padding(.bottom, 5)
                
                HStack {
                    Text("\(designerShopAddress)")
                    Spacer()
                    Image(systemName: "doc.on.doc")
                        .foregroundStyle(.sub)
                        .onTapGesture {
                            UIPasteboard.general.string = designerShopAddress
                            isShowingCopyAlert.toggle()
                        }
                        .alert("클립보드에 복사되었습니다.", isPresented: $isShowingCopyAlert) {
                            Button("확인", role: .cancel) {
                                isShowingCopyAlert.toggle()
                            }
                        }
                }
                
                Map(coordinateRegion: $region)
                    .frame(minHeight: 200)
            }
            .padding([.leading, .trailing])
            
            // MARK: - 결제 정보 섹션
            VStack(alignment: .leading) {
                Text("결제정보")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                
                Divider()
                    .frame(width: 360)
                    .background(Color.systemFill)
                
                HStack {
                    Text("결제수단")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    Text("카드 결제")
                }
                .padding(.top)
                
                HStack {
                    Text("결제금액")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    Text("\(price)원")
                }
                .padding(.top)
            }
            .padding()
            
            HStack {
                if isUpcomingReservation {
                    NavigationLink {
                        CMNewReviewView(reservation: reservation)
                    } label: {
                        HStack {
                            Spacer()
                            Text("리뷰 작성")
                            Spacer()
                        }
                        .buttonModifier(.main)
                    }
                }
            }
            .padding([.leading, .trailing])
            
            Spacer()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton(color: nil, action: {})
            }
        }
        .onAppear {
            Task {
                styles = []
                
                await cmHistoryViewModel.fetchDesigner(designerId: reservation.designerUID)
                
                let designer = cmHistoryViewModel.designer
                guard let shop = cmHistoryViewModel.designer.shop else { return }
                
                print("%%% \(designer)")
                
                designerName = designer.name
                designerRank = designer.rank.rawValue
                designerShop = shop.shopName
                designerShopAddress = "\(shop.headAddress) \(shop.subAddress) \(shop.detailAddress)"
                reservationDate = SingleTonDateFormatter.sharedDateFommatter.changeDateString(transition: "MM월 dd일 HH시 mm분", from: reservation.reservationTime)
                
                for hairStyle in reservation.hairStyle {
                    styles.append(hairStyle.name)
                    price += hairStyle.price
                }
                
                region.center = CLLocationCoordinate2D(
                    latitude: cmHistoryViewModel.designer.shop?.latitude ?? 0,
                    longitude: cmHistoryViewModel.designer.shop?.longitude ?? 0
                )
                
                region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            }
        }
    }
}

#Preview {
    CMReservationHistoryDetailView(reservation: Reservation(clientUID: "", designerUID: "", reservationTime: "", hairStyle: [], isFinished: true))
}
