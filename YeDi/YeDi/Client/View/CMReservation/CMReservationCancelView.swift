//
//  CMReservationCancelView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/26.
//

import SwiftUI

struct CMReservationCancelView: View {
    @Binding var isShowingCancelSheet: Bool
    @State private var isShowingCancelAlert = false
    @State private var selectedButton: Int? = nil
    let buttons = ["취소 사유 1", "취소 사유 2", "취소 사유 3", "취소 사유 4"]
    @State private var isCancelButtonEnabled = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("예약취소")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("취소 사유를 선택해주세요.")
                
                ForEach(0..<buttons.count, id: \.self) { index in
                    Button(action: {
                        self.selectedButton = index
                        self.isCancelButtonEnabled = true
                    }, label: {
                        HStack {
                            Spacer()
                            Text(buttons[index])
                            Spacer()
                        }
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(selectedButton == index ? Color.red : Color.gray)
                }
                Spacer()
                Button(action: {
                    if isCancelButtonEnabled {
                        isShowingCancelAlert = true
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text("예약 취소")
                        Spacer()
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .disabled(!isCancelButtonEnabled)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {isShowingCancelSheet = false}, label: {
                        Image(systemName: "xmark")
                    })
                    .buttonStyle(.plain)
                }
            }
            .alert(isPresented: $isShowingCancelAlert) {
                Alert(title: Text("예약이 취소됩니다"),
                      message: Text("이 작업은 되돌릴 수 없습니다"),
                      primaryButton: .cancel(Text("유지하기")),
                      secondaryButton: .destructive(Text("예약 취소")) {
                    isShowingCancelSheet = false
                }
                )
            }
        }
    }
}

#Preview {
    CMReservationCancelView(isShowingCancelSheet: .constant(false))
}
