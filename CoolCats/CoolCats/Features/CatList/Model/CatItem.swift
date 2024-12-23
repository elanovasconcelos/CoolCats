//
//  CatItem.swift
//  CoolCats
//
//  Created by Elano Vasconcelos on 21/12/24.
//

import Foundation

struct CatItem: Identifiable {
    let id: String
    let name: String
    let lifeSpan: String
    let imageUrl: String?
    var isFavourite: Bool
}

extension CatItem {
    
    init(_ cat: Cat) {
        self.id = cat.id
        self.name = cat.name
        self.lifeSpan = cat.lifeSpan ?? ""
        self.imageUrl = cat.image?.url
        self.isFavourite = false
    }
    
    static var debug: CatItem {
        CatItem(
            id: "1",
            name: "the cat",
            lifeSpan: "1 - 2",
            imageUrl: nil,
            isFavourite: false
        )
    }
    
    static var debugFavourite: CatItem {
        CatItem(
            id: "1",
            name: "Big Big Big cat",
            lifeSpan: "1 - 2",
            imageUrl: nil,
            isFavourite: true
        )
    }
}
