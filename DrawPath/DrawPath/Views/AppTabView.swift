//
//  AppTabView.swift
//  DrawPath
//
//  Created by Pedro Boga on 24/08/23.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            StartView()
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
            Spacer()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
            .badge(3)
            SobreView()
                .tabItem {
                    Label("Sobre", systemImage: "questionmark.circle.fill")
                }
        }
        .tint(.red)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
