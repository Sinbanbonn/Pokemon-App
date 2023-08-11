import Combine
import UIKit

final class RootCoordinator: BaseCoordinator {
    
    private var router: Routable
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(router: Routable) {
        self.router = router
        super.init()
    }
}

// MARK: - Coordinatable
extension RootCoordinator: Coordinatable {
    func start() {
        makeLoginFlowCoordinator().start()
    }
}

extension RootCoordinator {
    func makeLoginFlowCoordinator() -> AuthFlowCoordinator {
        let coordinator = AuthFlowCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            guard let self = self else { return }
            self.removeDependency(coordinator)
        }
        addDependency(coordinator)
        return coordinator
    }
}
