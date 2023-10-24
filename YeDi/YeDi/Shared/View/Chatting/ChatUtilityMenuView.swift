//
//  ChatUtilityMenuView.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/25.
//

import SwiftUI
import PhotosUI

struct ChatUtilityMenuView: View {
    var chattingVM : ChattingViewModel
    var userID: String
    var designerID: String
    
    @StateObject var postDetailViewModel: PostDetailViewModel = PostDetailViewModel()
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var isPresentedAlert: Bool = false
    @State private var isPresentedNavigation: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                VStack {
                    VStack{
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .foregroundStyle(Color.white)
                    }
                    .padding(13)
                    .background {
                        Circle()
                            .fill(Color.pointColor)
                    }
                    Text("사진")
                        .font(.caption)
                }
            }
            .onChange(of: selectedItem) { newItem in ///사진앱에서 선택된 사진이 저장되고 Data로 형변환 되는 코드
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        ///형변환이 완료 되면 바로 사진 보내기
                        chattingVM.sendImageBubble(imageData: data, sender: userID)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                isPresentedNavigation.toggle()
                isPresentedAlert.toggle()
            }, label: {
                VStack {
                    VStack{
                        Image(systemName: "clock.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .foregroundStyle(Color.white)
                    }
                    .padding(13)
                    .background {
                        Circle()
                            .fill(Color.indigo)
                    }
                    Text("바로예약")
                        .font(.caption)
                }
            })
            .navigationDestination(isPresented: $isPresentedNavigation, destination: {
                CMReservationDateTimeView(designerID: designerID, isPresentedAlert: $isPresentedAlert, isPresentedNavigation: $isPresentedNavigation)
                    .environmentObject(postDetailViewModel)
            })
            .buttonStyle(.automatic)
            
            Spacer()
        }
        .padding(.top)
        .padding(.bottom, 30)
        .background(Color.tertiarySystemBackground)
        .foregroundStyle(.primary)
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}
