//
//  UserViewModel.swift
//  DrawPath
//
//  Created by Pedro Boga on 24/08/23.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [User] = []

    func fetchUsers() {
        if let url = URL(string: "https://reqres.in/api/users") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(UsersResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.users = result.data
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

struct UsersResponse: Codable {
    let data: [User]
}
