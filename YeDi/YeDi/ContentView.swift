//
//  ContentView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/22.
//

import SwiftUI
struct ContentView: View {
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        VStack{
            if userAuth.isClientLogin {
                ClientMainTabView()
                    .environmentObject(userAuth)
            } else if userAuth.isDesignerLogin {
                DesignerMainTabView()
                    .environmentObject(userAuth)
            } else {
                AuthHomeView()
            }
        }
    }
}

/*
 c1@gmail.com / 111111
 c2@gmail.com / 111111
 c3@gmail.com / 111111
 d1@gmail.com / 111111
 d2@gmail.com / 111111
 d3@gmail.com / 111111
 */

#Preview {
    ContentView()
        .environmentObject(UserAuth())
}
