//
//  DriverCardView.swift
//  DrawPath
//
//  Created by Pedro Boga on 24/08/23.
//

import SwiftUI

struct DriverCardView: View {
    var body: some View {
        HStack(spacing: 0) { // Add spacing between columns
                    // Left Column
                    VStack(alignment: .leading, spacing: 4) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                        Text("João Mário")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .frame(width: 80) // Make left column take up 1/3 of the width
                    .padding()
                    
                    // Right Column
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Seu motorista:")
                            .font(.title3)
                            .fontWeight(.bold)
                        Divider()
                        Group {
                            Text("Registro: DL12345")
                            Text("Motorista desde: 01/15/1985")
                            HStack(spacing: 2) {
                                Text("Avaliação:")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.leadinghalf.filled")
                            }
                        }
                        .font(.caption)
                    }
                    .frame(maxWidth: .infinity) // Make right column take up 2/3 of the width
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
    }
}

struct DriverCardView_Previews: PreviewProvider {
    static var previews: some View {
        DriverCardView()
    }
}
