//
//  StartView.swift
//  DrawPath
//
//  Created by Pedro Boga on 24/08/23.
//

import SwiftUI

struct StartView: View {
    @State private var searchText = ""
    @State private var buscas: [Busca] = []
    @State private var linhaSelecionada: Busca?
    @State private var paradas: [Parada] = []
    @State private var previsao: Previsao?
    @State private var isNavigationActive = false
    @State private var showNavigationBar = true
    
    var body: some View {
        VStack {
            Text(buscas.count > 0 ? "Linhas:" : "")
                .font(.title3)
                .padding(.top, 10)
            List(buscas, id: \.cl) { dado in
                
                VStack (alignment: .leading) {
                    Text("\(dado.lt)-\(dado.tl)")
                        .font(.caption)
                    Text("De: \(dado.tp)")
                        .font(.headline)
                    Text("Sentido: \(dado.ts)")
                    
                }
                .padding(2)
                .onTapGesture {
                    buscaParadas(por: dado)
                }
                
            }
            .listStyle(.sidebar)
            .navigationTitle(showNavigationBar ? "BusInfoSP" : "")
            .searchable(text: $searchText, prompt: "Digite uma linha ou parada de ônibus")
            .onSubmit(of: .search, realizaBusca)
            .disableAutocorrection(true)
            
            Text(paradas.count > 0 ? "Paradas:" : "")
                .font(.title3)
                .padding(.top, 10)
            List(paradas, id: \.cp) { parada in
                NavigationLink {
                    ContentView2(parada: parada, linha: linhaSelecionada ?? Busca(cl: 0, lc: true, lt: "", sl: 0, tl: 0, tp: "", ts: ""))
                } label: {
                    VStack (alignment: .leading) {
                        Text(parada.np)
                            .font(.headline)
                        Text(parada.ed)
                            .font(.subheadline)
                        
                    }
                }
            }
            .listStyle(.sidebar)
            .toolbar(.visible, for: .navigationBar)
            Rectangle()
                .frame(width: 800, height: 10)
                .foregroundColor(.clear)
        }
        .toolbar(showNavigationBar ? .visible : .hidden, for: .navigationBar)
        
        .onAppear {
            buscas = []
            paradas = []
            searchText = ""
            showNavigationBar = true
        }
    }
    
    func realizaBusca() {
        paradas = []
        NetworkManager.shared.autenticar { (response) in
            NetworkManager.shared.buscarLinhas(searchText, onComplete: { dados in
                self.buscas = dados
            }, onError: { error in
                //
            })
        }
    }
    
    func buscaParadas(por linha: Busca) {
        NetworkManager.shared.autenticar { (response) in
            NetworkManager.shared.buscarParadas(linha.cl, onComplete: { paradas in
                self.linhaSelecionada = linha
                self.paradas = paradas
            }, onError: { error in
                //
            })
        }
    }
    
    func buscaChegadas(parada: Int, linha: Int, onComplete: @escaping (Bool) -> Void) {
        NetworkManager.shared.autenticar { (response) in
            NetworkManager.shared.buscarChegadas(parada: parada, linha: linha) { (previsao) in
                //
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
