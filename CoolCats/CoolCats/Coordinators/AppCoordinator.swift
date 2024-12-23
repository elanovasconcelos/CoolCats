//
//  AppCoordinator.swift
//  CoolCats
//
//  Created by Elano Vasconcelos on 21/12/24.
//

import UIKit
import SwiftUI

final class AppCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let viewFactory: ViewFactory
    
    init(navigationController: UINavigationController,
         viewFactory: ViewFactory = ViewFactory()) {
        self.navigationController = navigationController
        self.viewFactory = viewFactory
    }
    
    /// Starts the coordinator by displaying the Cat List
    func start() {
        let catListView = viewFactory.makeCatSearchView() { [weak self] action in
            switch action {
            case .didSelectItem(let catItem):
                break // TODO: open details
            case .showError(let string):
                self?.showError(message: string)
            }
        }
        
        let hostingController = UIHostingController(rootView: catListView)
        hostingController.title = "Cool Cats"
        
        navigationController.pushViewController(hostingController, animated: false)
    }
    
    func showError(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let topViewController = self.navigationController.topViewController else { return }
            
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
}
