//
//  ContentView.swift
//  DrawPath
//
//  Created by Rion on 24.4.22.
//

import SwiftUI
import MapKit





struct ContentView2: View {
    @State var parada: Parada
    @State var linha: Busca
    @State var buscas: [Busca]?
    @State var previsao: Previsao?
    @State var selectedBus: String?
    @State var lugares: [Result] = []
    @State private var showEmbarqueView: Bool = false
//
    @State var requestLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State var destinationLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var body: some View {
        VStack(alignment: .center) {
            MyMapView(requestLocation: $requestLocation, destinationLocation: $destinationLocation, places: $lugares)
                .edgesIgnoringSafeArea(.all)

            Text("Próximo(s) ônibus:")
                .font(.title)
            List(previsao?.p.l.first?.vs ?? [], id: \.p) { dado in
                VStack(alignment: .center) {
                    HStack {
                        Image(systemName: "bus")
                        Text("\(dado.p)")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Text("Hora prevista de chegada: \(dado.t)")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listStyle(.plain)
            Spacer()
            List(lugares ?? [], id: \.fsqID) { lugar in
                VStack {
                    Text(lugar.name)
                }
            }
            Spacer()
            Button {
                showEmbarqueView.toggle()
            } label: {
                Text("Embarquei")
            }
            
    }
        .onAppear {
            NetworkManager.shared.autenticar { (response) in
                NetworkManager.shared.buscarLinhas("aclimacao", onComplete: { dados in
                    self.buscas = dados
                }, onError: { error in
                    //
                })
                NetworkManager.shared.buscarChegadas(parada: parada.cp, linha: linha.cl) { chegadas in
                    self.previsao = chegadas
                    requestLocation = CLLocationCoordinate2D(latitude: previsao?.p.py ?? 0.0, longitude:  previsao?.p.px ?? 0.0)
                    destinationLocation = CLLocationCoordinate2D(latitude: previsao?.p.l.first?.vs.first?.py ?? 0.0, longitude: previsao?.p.l.first?.vs.first?.px ?? 0.0)
                    
                    NetworkManager.shared.getPlaces(lat: parada.py, long: parada.px) { response in
                        self.lugares = response.results
                    }
                }

            }
            
            
        }
        .sheet(isPresented: $showEmbarqueView) {
            EmbarqueView()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2(parada: Parada(cp: 0, np: "", ed: "", py: 0.0, px: 0.0), linha: Busca(cl: 0, lc: true, lt: "", sl: 0, tl: 0, tp: "", ts: ""), buscas: [])
    }
}
