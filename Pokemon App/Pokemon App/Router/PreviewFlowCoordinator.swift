import Foundation
import UIKit

enum PreviewFlowRoute: Route {
    case main
    case showDetail(id: Int)
    case base(BaseRoutes)
}

protocol PreviewFlowCoordinatorOutput: AnyObject {
    var finishFlow: CompletionBlock? { get set }
    func trigger(_ route: PreviewFlowRoute)
}

final class PreviewFlowCoordinator: BaseCoordinator, PreviewFlowCoordinatorOutput {
    
    var finishFlow: CompletionBlock?
    
    fileprivate let router : Routable
    fileprivate let rootController: UIViewController?
    
    init(router: Routable) {
        self.router = router
        self.rootController = router.toPresent
    }
    
    func trigger(_ route: PreviewFlowRoute) {
        switch route {
        case .main:
            let titlesVM = PreviewViewModel(router: self)
            let previewFlowVC = PreviewViewController(viewModel: titlesVM )
            router.setRootModule(previewFlowVC)
        case .showDetail(let id):
            let pokemonDetailVM = DetailViewModel(router: self, id: id)
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
extension PreviewFlowCoordinator: Coordinatable {
    func start() {
        trigger(.main)
    }
}
