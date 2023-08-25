//
//  Previsao.swift
//  DrawPath
//
//  Created by Pedro Boga on 24/08/23.
//

import Foundation

struct Previsao: Codable {
    let hr: String
    let p: PontoParada
}

// MARK: - P
struct PontoParada: Codable {
    let cp: Int
    let np: String
    let py, px: Double
    let l: [Linha]
}

// MARK: - L
struct Linha: Codable {
    let c: String
    let cl, sl: Int
    let lt0, lt1: String
    let qv: Int
    let vs: [Veiculo]
}

// MARK: - V
struct Veiculo: Codable {
    let p: String
    let t: String
    let a: Bool
    //let ta: Date
    let py, px: Double
    //let sv, vIs: NSNull
}
