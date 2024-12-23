//
//  CatListView.swift
//  CoolCats
//
//  Created by Elano Vasconcelos on 21/12/24.
//

import SwiftUI

struct CatListView: View {

    typealias ListAction = (Action) -> Void
    
    enum Action {
        case image(CatItem)
        case favourite(CatItem)
        case lastItem(CatItem)
    }
    
    let items: [CatItem]
    let onActionSelected: ListAction
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(items: [CatItem], onActionSelected: @escaping ListAction = { _ in }) {
        self.items = items
        self.onActionSelected = onActionSelected
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    
                    CatItemView(item: item) { action in //TODO: extract to a viewModel?
                        switch action {
                        case .favourite: onActionSelected(.favourite(item))
                        case .image: onActionSelected(.image(item))
                        }
                    }
                        .onAppear {
                            if index == items.count - 1 { // last item
                                onActionSelected(.lastItem(item))
                            }
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    CatListView(items: [.debug, .debugFavourite])
}
