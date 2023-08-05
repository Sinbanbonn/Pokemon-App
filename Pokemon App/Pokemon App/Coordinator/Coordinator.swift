import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    
    func startCoordinator()
    
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController = UINavigationController()
    
    func startCoordinator() {
        let initialViewController =  HomeViewController()
        initialViewController.mainCoordinator = self
        navigationController.pushViewController(initialViewController, animated: false )
    }
    
    func showDetails(id: Int) {
        DispatchQueue.main.async {
            let vc = PokemonViewController()
            vc.configure(with: id)
            self.navigationController.pushViewController(vc, animated: true)
        }
        
    }
}


