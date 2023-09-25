//
//  CMHomeView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct CMHomeView: View {
    var regions = ["서울", "경기", "인천"]
    @State private var selectedRegion = ""
    
    var body: some View {
        NavigationStack {
            HStack {
                Picker("Choose a color", selection: $selectedRegion) {
                    ForEach(regions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .font(.largeTitle)
                Spacer()
            }
            .padding(.horizontal)
            ScrollView {
                LazyVStack(content: {
                    ForEach(1...10, id: \.self) { count in
                        CMHomeCell()
                    }
                })
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("YeDi")
                        .font(.title)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    })
                }
            }
        }
    }
}

#Preview {
    CMHomeView()
}
