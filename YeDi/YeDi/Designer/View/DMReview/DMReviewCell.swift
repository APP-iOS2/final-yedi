//
//  DMReviewCell.swift
//  YeDi
//
//  Created by 송성욱 on 10/5/23.
//

import SwiftUI

struct DMReviewCell: View {
    
    
    var body: some View {
            HStack {
                //사용자의 프로필 이미지가 올 예정
                RoundedRectangle(cornerRadius: 5)
                    .frame(width:120, height: 120)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                VStack(alignment: .leading) {
                    HStack {
                        //사용자가 부여한 별점 표시
                        //부여한 별점 designerScore에 반영
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    Text("김고객")
                        .padding(.top, 4)
                    Text("23.09.10 작성")
                        .padding(.bottom, 4)
                    //사용자가 쓴 리뷰가 올 예정 (3줄 이상 넘어갈 시... 표시 후 디테일 뷰에서 확인 )
                    Text("""
                    왜 이제야 쌤을 발견했을까요! 덕분에 정말 인생 머리를 해서 너무 기분이 좋습니다. 요즘 만나...
                    """)
                }
            }
        .padding(.horizontal)
    }
}

#Preview {
    DMReviewCell()
}
