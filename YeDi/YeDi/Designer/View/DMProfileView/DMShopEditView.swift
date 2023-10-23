//
//  DMShopEditView.swift
//  YeDi
//
//  Created by 김성준 on 10/18/23.
//


// TODO: 휴무일 설정 필요

import SwiftUI

struct DMShopEditView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    @Binding var shop: Shop
    @Binding var rank: Rank
    @Binding var isShowDesignerShopEditView: Bool
    
    @State private var isNotEmptyDescription: Bool = true
    @State private var isPhoneNumberValid: Bool = false
    @State private var closedDay: String = ""
    @State private var openingHour: Date = Date()
    @State private var closingHour: Date = Date()
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userAuth: UserAuth
    private let ranks: [Rank] = [.Owner, .Principal, .Designer, .Intern]
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 5){
                    HStack(alignment: .center) {
                        Text("직급 *")
                        
                        Spacer()
                        
                        Menu(rank.rawValue) {
                            Picker("select your rank", selection: $rank) {
                                ForEach(ranks, id: \.self) { rank in
                                    Text(rank.rawValue)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(11)
                            .foregroundStyle(Color.primary)
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.quaternarySystemFill)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(11)
                        .foregroundStyle(Color.primary)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.quaternarySystemFill)
                        }
                        
                    }
                    
                    Group {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("샵 이름")
                            TextField("이름", text: $shop.shopName)
                                .signInTextFieldStyle(isTextFieldValid: $isNotEmptyDescription)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            DatePicker("오픈 시간", selection: $openingHour, displayedComponents: .hourAndMinute)
                            DatePicker("마감 시간", selection: $closingHour, displayedComponents: .hourAndMinute)
                                .padding(.bottom, 7)
                            VStack(alignment: .leading) {
                                Text("휴무일")
                                TextField("요일", text: $closedDay)
                                    .signInTextFieldStyle(isTextFieldValid: $isNotEmptyDescription)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("시/군/구")
                            TextField("시/군/구", text: $shop.headAddress)
                                .textFieldModifier()
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("도로명")
                            TextField("도로명", text: $shop.subAddress)
                                .textFieldModifier()
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("상세주소")
                            TextField("상세주소 ", text: $shop.detailAddress)
                                .textFieldModifier()
                        }
                        
                      
                    }
                    .padding(.vertical, 8)
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .onDisappear(perform: {
                    setCordinate()
                    convertDateString()
                })
                .onAppear(perform: {
                    let dateFomatter = SingleTonDateFormatter.sharedDateFommatter.firebaseDateFormat()
                    
                    closedDay = shop.closedDays.first ?? ""
                    openingHour = dateFomatter.date(from: shop.openingHour) ?? Date()
                    closingHour = dateFomatter.date(from: shop.closingHour) ?? Date()
                })
                .onTapGesture(perform: {
                    hideKeyboard()
                })
                .toolbar(content: {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button(role: .cancel, action: {
                            convertDateString()
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                        })
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(role: .destructive, action: {
                            convertDateString()
                        }, label: {
                           Text("완료")
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                        })
                    }
                })
            }
        }
    }
    private func setCordinate() {
        if !shop.headAddress.isEmpty && !shop.subAddress.isEmpty {
            let address = shop.headAddress + shop.subAddress
            let _: () = locationManager.getCoordinate(addressString: address) { coordinate, error in
                guard error == nil else { return }
                
                shop.latitude = coordinate.latitude
                shop.longitude = coordinate.longitude
            }
        }
    }
    private func convertDateString() {
        let fomatter = SingleTonDateFormatter.sharedDateFommatter
        
        shop.openingHour = fomatter.firebaseDate(from: openingHour)
        shop.closingHour = fomatter.firebaseDate(from: closingHour)
        shop.closedDays = [closedDay]
        
        isShowDesignerShopEditView = false
    }
}

#Preview {
    NavigationStack {
        DMShopEditView(
            shop: .constant(.init(
                shopName: "",
                headAddress: "",
                subAddress: "",
                detailAddress: "",
                openingHour: "",
                closingHour: "",
                closedDays: [])),
            rank: .constant(Rank.Owner),
            isShowDesignerShopEditView: .constant(false)
        )
        .environmentObject(LocationManager())
    }
}
