//
//  CatItemView.swift
//  CoolCats
//
//  Created by Elano Vasconcelos on 21/12/24.
//

import SwiftUI

struct CatItemView: View {

    typealias CatAction = (Action) -> Void
    
    enum Action {
        case favourite
        case image
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    let item: CatItem
    let onActionSelected: CatAction
    
    init(item: CatItem, onActionSelected: @escaping CatAction = { _ in }) {
        self.item = item
        self.onActionSelected = onActionSelected
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                onActionSelected(.image)
            } label: {
                VStack {
                    ImageView(url: item.imageUrl)
                        .frame(height: 100)
                        .cornerRadius(8)
                    Text(item.name)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .frame(height: 50)
                        .foregroundStyle(colorScheme != .dark ? .black : .white)
                }
            }

            Button {
                onActionSelected(.favourite)
            } label: {
                Image(systemName: item.isFavourite ? "star.fill" : "star")
                    .foregroundColor(item.isFavourite ? .yellow : .gray)
                    .padding(8)
                    .background(Color.white.opacity(0.7))
                    .clipShape(Circle())
            }
            .padding([.top, .trailing], 8)

        }
        
    }
}

#Preview {
    VStack {
        CatItemView(item: .debug)
        CatItemView(item: .debugFavourite)
    }
    
}
