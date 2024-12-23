//
//  ViewFactory.swift
//  CoolCats
//
//  Created by Elano Vasconcelos on 21/12/24.
//

import UIKit

final class ViewFactory {
    
    private let repository: CatRepository
    
    init(repository: CatRepository = CatRepositoryImpl()) {
        self.repository = repository
    }
    
    func makeCatSearchView(onActionSelected: @escaping CatSearchView.SearchAction) -> CatSearchView {
        let viewModel = CatSearchView.ViewModel(repository: repository, onActionSelected: onActionSelected)
        
        return CatSearchView(viewModel: viewModel)
    }
    
    
}
