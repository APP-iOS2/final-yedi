//
//  DateDividerCell.swift
//  YeDi
//
//  Created by 이승준 on 10/18/23.
//

import SwiftUI

struct DateDeviderCell: View {
    
    var chat: CommonBubble
    var chattingVM: ChattingViewModel
    @Binding var devideDate: String
    
    private var chatDate: String {
        let instance = SingleTonDateFormatter.sharedDateFommatter
        let date = instance.changeDateString(transition: "yyyy-MM-dd", from: chat.date)
        return date
    }
    
    var body: some View {
        VStack{
            if chatDate == devideDate { //다른 경우
                Text("\(chatDate)")
            } else {
                if !chattingVM.anyMoreChats && chatDate != devideDate {
                    Text("\(chatDate)")
                        .onAppear{
                        devideDate = chatDate
                    }
                }
            }
        }
    }
}

