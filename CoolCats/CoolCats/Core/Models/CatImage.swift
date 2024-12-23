//
//  Image.swift
//  CoolCats
//
//  Created by Elano Vasconcelos on 21/12/24.
//

import Foundation

struct CatImage: Decodable {
    let id: String
    let width: Int
    let height: Int
    let url: String
}
