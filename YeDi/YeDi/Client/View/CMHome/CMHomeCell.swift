//
//  CMHomeCell.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI

struct CMHomeCell: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text("디자이너 이름")
                    Text("디저이너 근무 지점")
                }
                Spacer()
                Button(action: {}, label: {
                    Text("팔로잉")
                })
                .buttonStyle(.borderedProminent)
                .tint(.black)

            }
            .padding(.horizontal)
            ScrollView(.horizontal) {
                LazyHStack(content: {
                    ForEach(1...5, id: \.self) { image in
                        Image(systemName: "square.fill")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .padding()
                    }
                })
            }
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.black)
                })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack {
                        Spacer()
                        Text("상담하기")
                        Spacer()
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(.black)
            }
            .padding()
        }
    }
}

#Preview {
    CMHomeCell()
}
