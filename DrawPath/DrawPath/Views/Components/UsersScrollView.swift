//
//  UsersScrollView.swift
//  DrawPath
//
//  Created by Pedro Boga on 24/08/23.
//

import SwiftUI

struct UsersScrollView: View {
    @ObservedObject var viewModel = UserViewModel()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewModel.users) { user in
                    AsyncImage(url: URL(string: user.avatar)) { phase in
                        switch phase {
                        case .empty: ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 45)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                        default:
                            EmptyView()
                        }
                    }
                }
                //                        Image(systemName: "person.fill")
                //                            .resizable()
                //                            .frame(width: 40, height: 40) // Adjust the size of the avatars as needed
                //                            .clipShape(Circle())
                //                            .padding(5) // Add padding around each avatar
            }
        }
        .padding() // Add overall padding for the ScrollView
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

struct UsersScrollView_Previews: PreviewProvider {
    static var previews: some View {
        UsersScrollView()
    }
}
