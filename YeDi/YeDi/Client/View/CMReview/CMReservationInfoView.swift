//
//  CMReservationInfoView.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/13.
//

import SwiftUI
import FirebaseFirestore

struct CMReservationInfoView: View {
    // MARK: - Properties
    @State private var designerName: String = ""
    @State private var designerShop: String = ""
    @State private var styles: [String] = []
    @State private var reservationDate: String = ""
    
    var reservation: Reservation
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Group {
                VStack(alignment: .leading, spacing: 10) {
                    Text(designerName)
                        .font(.title3)
                    ForEach(styles, id: \.self) { style in
                        Text("\(style)")
                            .font(.title)
                    }
                }
                .fontWeight(.semibold)
                
                HStack {
                    Text("\(reservationDate) 예약")
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
                .foregroundColor(.systemBackground)
                .shadow(color: Color.systemFill, radius: 5, x: 0, y: 5)
                .opacity(0.2)
        )
        .offset(y: -80)
        .onAppear {
            Task {
                let collectionRef = Firestore.firestore().collection("designers")
                
                do {
                    let docSnapshot = try await collectionRef
                        .whereField("designerUID", isEqualTo: reservation.designerUID)
                        .getDocuments()
                    
                    for doc in docSnapshot.documents {
                        if let designer = try? doc.data(as: Designer.self) {
                            designerName = designer.name
                            designerShop = designer.shop?.shopName ?? "프리랜서"
                        }
                    }
                } catch {
                    print("Error fetching client reviews: \(error)")
                }
                
                for hairStyle in reservation.hairStyle {
                    styles.append(hairStyle.name)
                }
                
                reservationDate = "\(SingleTonDateFormatter.sharedDateFommatter.changeDateString(transition: "MM월 dd일 HH시 mm분", from: reservation.reservationTime)) 예약"
            }
        }
    }
}

#Preview {
    CMReservationInfoView(reservation: Reservation(clientUID: "", designerUID: "", reservationTime: "", hairStyle: [], isFinished: true))
}
