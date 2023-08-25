//
//  MapViewModel.swift
//  DrawPath
//
//  Created by Pedro Boga on 23/08/23.
//

import Foundation

@MainActor final class MapViewModel: ObservableObject {
    @Published var dados: [Busca] = []
    
    func buscaDados() {
        Task {
            do {
                //dados = try await NetworkManager.shared.buscaDados()
            }
        }
    }
}
