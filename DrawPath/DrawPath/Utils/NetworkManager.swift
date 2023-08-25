//
//  NetworkManager.swift
//  DrawPath
//
//  Created by Pedro Boga on 23/08/23.
//

import Foundation

import Foundation
import UIKit

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
}

enum APITokens: String {
    case spTransToken = " "
    case fourSquareToken = ""
}

final class NetworkManager {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    let baseURL = "http://api.olhovivo.sptrans.com.br/v2.1"
    let token = APITokens.spTransToken.rawValue
    //private let login = baseURL + "/appetizers"
    
    private init() {}
    
//    func getAppetizers(completed: @escaping (Result<[Appetizer], APError>) -> Void) {
//        guard let url = URL(string: appetizerURL) else {
//            completed(.failure(.invalidURL))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//            if let _ = error {
//                completed(.failure(.unableToComplete))
//                return
//            }
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                return
//            }
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let decodedResponse = try decoder.decode(AppetizerResponse.self, from: data)
//                completed(.success(decodedResponse.request))
//            } catch {
//                completed(.failure(.invalidData))
//            }
//        }
//        task.resume()
//    }
    
//    func autenticar() async throws -> Void {
//        guard let url = URL(string: "\(baseURL)/Login/Autenticar?token=\(token)") else {
//            throw APIError.invalidURL
//        }
//
//        let (_, response) = try await URLSession.shared.data(from: url)
//
//        do {
//            let decoder = JSONDecoder()
//            guard let response = response as? HTTPURLResponse else { return }
//            print(response.statusCode)
//            return
//        } catch {
//            throw APIError.invalidData
//        }
//    }
//
//    func busca() async throws -> [Busca] {
//        guard let url = URL(string: "\(baseURL)/Linha/Buscar?termosBusca=\("Aclimacao")") else {
//            throw APIError.invalidURL
//        }
//
//        let (data, _) = try await URLSession.shared.data(from: url)
//
//        do {
//            let decoder = JSONDecoder()
//            return try decoder.decode([Busca].self, from: data)
//        } catch {
//            throw APIError.invalidData
//        }
//    }
//
//    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void) {
//        let cacheKey = NSString(string: urlString)
//        if let image = cache.object(forKey: cacheKey) {
//            completed(image)
//            return
//        }
//        guard let url = URL(string: urlString) else {
//            completed(nil)
//            return
//        }
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//            guard let data = data, let image = UIImage(data: data) else {
//                completed(nil)
//                return
//            }
//
//            self.cache.setObject(image, forKey: cacheKey)
//            completed(image)
//        }
//        task.resume()
//    }
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true // permitir acesso por rede de dados móveis
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()

    private let session = URLSession(configuration: configuration)

    func autenticar(onComplete: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/Login/Autenticar?token=\(token)") else {
            onComplete(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return
                }
                onComplete(true)
            } else {
                onComplete(false)
            }
        }
        dataTask.resume()
    }
    
    func buscarLinhas(_ termosBusca: String, onComplete: @escaping ([Busca]) -> Void, onError: @escaping (APIError) -> Void) {
        guard let url = URL(string: "\(baseURL)/Linha/Buscar?termosBusca=\(termosBusca)") else {
            onError(.invalidURL)
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.invalidResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do {
                        let buses = try JSONDecoder().decode([Busca].self, from: data)
                        onComplete(buses)
                    } catch {
                        print(error.localizedDescription)
                        onError(.invalidData)
                    }
                } else {
                    print("Algum status inválido pelo servidor!!")
                    onError(.unableToComplete)
                }
            } else {
                onError(.unableToComplete)
            }
        }
        dataTask.resume()
    }
    
    func buscarParadas(_ termosBusca: Int, onComplete: @escaping ([Parada]) -> Void, onError: @escaping (APIError) -> Void) {
        guard let url = URL(string: "\(baseURL)/Parada/BuscarParadasPorLinha?codigoLinha=\(termosBusca)") else {
            onError(.invalidURL)
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.invalidResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do {
                        let paradas = try JSONDecoder().decode([Parada].self, from: data)
                        onComplete(paradas)
                    } catch {
                        print(error.localizedDescription)
                        onError(.invalidData)
                    }
                } else {
                    print("Algum status inválido pelo servidor!!")
                    onError(.unableToComplete)
                }
            } else {
                onError(.unableToComplete)
            }
        }
        dataTask.resume()
    }
    
    func buscarChegadas(parada: Int, linha: Int, onComplete: @escaping (Previsao) -> Void) {
        guard let url = URL(string: "\(baseURL)/Previsao?codigoParada=\(parada)&codigoLinha=\(linha)") else {
            //onError(.invalidURL)
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    //onError(.invalidResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do {
                        let previsao = try JSONDecoder().decode(Previsao.self, from: data)
                        onComplete(previsao)
                    } catch {
                        print(error.localizedDescription)
                        //onError(.invalidData)
                    }
                } else {
                    print("Algum status inválido pelo servidor!!")
                    //onError(.unableToComplete)
                }
            } else {
                //onError(.unableToComplete)
            }
        }
        dataTask.resume()
    }
    
    func getPlaces(lat: Double, long: Double, onComplete: @escaping (Lugar) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": APITokens.fourSquareToken.rawValue
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.foursquare.com/v3/places/search?ll=\(lat),\(long)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                guard let response = response as? HTTPURLResponse else {
                    //onError(.invalidResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do {
                        let lugares = try JSONDecoder().decode(Lugar.self, from: data)
                        onComplete(lugares)
                    } catch {
                        print(error.localizedDescription)
                        //onError(.invalidData)
                    }
                } else {
                    print("Algum status inválido pelo servidor!!")
                    //onError(.unableToComplete)
                }
            }
        })
        
        dataTask.resume()
    }
}
