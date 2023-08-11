import Foundation
import UIKit

enum AuthFlowRoute: Route {
    case main
    case shovDetail(id: Int)
    case base(BaseRoutes)
}

protocol AuthFlowCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: AuthFlowRoute)
}

final class AuthFlowCoordinator: BaseCoordinator, AuthFlowCoordinatorOutput {

    var finishFlow: CompletionBlock?
    
    fileprivate let router : Routable
    fileprivate let rootController: UIViewController?
    
    init(router: Routable) {
        self.router = router
        self.rootController = router.toPresent
    }
    
    func trigger(_ route: AuthFlowRoute) {
        switch route {
        case .main:
            let titlesVM = PreviewViewModel(router: self)
            let loginFlowVC = HomeViewController(viewModel: titlesVM )
            router.setRootModule(loginFlowVC)
        case .shovDetail(let id):
           let pokemonDetailVM = PokemonDetailViewModel(router: self, id: id)
            let pokemonDetailVC = PokemonViewController(viewModel: pokemonDetailVM)
            router.push(pokemonDetailVC, animated: true)
        case .base(let base):
            print()
            switch base {
            case .alert(let alert):
                router.present(alert)
            case .pop:
                break
            case .dismiss:
               break
            default: break
            }
        }
    }
}

// MARK: - Coordinatable
extension AuthFlowCoordinator: Coordinatable {
    func start() {
        trigger(.main)
    }
}
