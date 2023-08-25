//
//  EmbarqueView.swift
//  DrawPath
//
//  Created by Pedro Boga on 24/08/23.
//

import SwiftUI

struct EmbarqueView: View {
    
    
    var body: some View {
        VStack {
            //DriverCardView()
            Spacer()
                .frame(height: 20)
            Text("Compartilhando a mesma viagem:")
            UsersScrollView()
            ChatView()
            Spacer()
            HStack {
                button156()
                button190()
            }
        }
    }
    
    fileprivate func button156() -> Button<some View> {
        return Button {
            if let url = URL(string: "tel://\(156)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } label: {
            HStack {
                Image(systemName: "phone.fill")
                Text("Problemas ou sugestões?")
            }
            .padding()
            .font(.caption)
            .background(Color.mint)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
    
    fileprivate func button190() -> Button<some View> {
        return Button {
            if let url = URL(string: "tel://\(190)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } label: {
            HStack {
                Image(systemName: "eyes.inverse")
                Text("Fazer uma denúncia")
            }
            .padding()
            .font(.caption)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct EmbarqueView_Previews: PreviewProvider {
    static var previews: some View {
        EmbarqueView()
    }
}
