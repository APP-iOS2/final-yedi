//
//  CMLastReservationView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/26.
//

import SwiftUI

struct CMLastReservationView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(1...3, id: \.self) { index in
                    // MARK: - 리뷰 작성 버튼 (삭제 예정)
                    NavigationLink(destination: CMNewReviewView()) {
                        Text("리뷰 작성하기")
                    }
                    
                    Button(action: {}, label: {
                        HStack {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("박명수 디자이너")
                                        .fontWeight(.semibold)
                                    Text("디자인 컷")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    Text("2023.09.25(월) 16: 00")
                                        .foregroundStyle(.gray)
                                }
                                Spacer()
                                Button(action: {}, label: {
                                    Image(systemName: "chevron.right")
                                })
                                .tint(.black)
                                
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(uiColor: .systemGray6))
                        )
                    })
                    .padding()
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    CMLastReservationView()
}
