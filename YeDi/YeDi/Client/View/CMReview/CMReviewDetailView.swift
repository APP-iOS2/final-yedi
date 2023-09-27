//
//  CMReviewDetailView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/27.
//

import SwiftUI

struct CMReviewDetailView: View {
    @State private var myDate = Date()
    
    var body: some View {
            NavigationStack {
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
                            Text("\(formatDate(date: myDate)) 예약")
                                .onAppear {
                                    self.myDate = createDate(year: 2023, month: 10, day: 10, hour: 14, minute: 45)
                                }
                            
                            Spacer()
                            Button(action: {
                                
                            }, label: {
                                Text("팔로우하기")
                                    .foregroundStyle(.white)
                                    .padding(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
                                    .background(
                                        Capsule(style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(.black)
                                    )
                            })
                        }
                    }
                    .offset(y: 50)
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .frame(height: 300)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)
                        .opacity(0.3)
                )
                .offset(y: -10)
                
                Spacer()
            }
            .toolbar(.hidden, for: .tabBar)
        }
        
        func formatDate(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
            return dateFormatter.string(from: date)
        }
        
        func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let calendar = Calendar.current
            return calendar.date(from: dateComponents) ?? Date()
        }
}

#Preview {
    CMReviewDetailView()
}
