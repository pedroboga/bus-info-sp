//
//  SobreView.swift
//  DrawPath
//
//  Created by Pedro Boga on 24/08/23.
//

import SwiftUI

struct SobreView: View {
    var body: some View {
        VStack (spacing: 8) {
            Text("Grupo 6")
                .font(.title2)
                .fontWeight(.bold)
            Text("João Guilherme da Silva Kita")
            Text("Lucas Borges Rondon")
            Text("Luis Ricardo Benhossi")
            Text("Pedro de Bernardo Freire Boga ")
            Text("Renan Ribeiro Cunha")
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct SobreView_Previews: PreviewProvider {
    static var previews: some View {
        SobreView()
    }
}
