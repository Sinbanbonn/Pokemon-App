import Foundation
import UIKit
import Combine

enum PreviewViewModelState {
    case initial
    case refreshData
}

final class PreviewViewModel: PreviewViewModelProtocol,
                              PreviewViewModelInput,
                              PreviewViewModelOutput {
    
    // Inject the Pokemon service using property wrapper
    @Injected(\.pokemonManager) private var pokemonService: PokemonServiceable
    
    // Reference to the router for navigation
    private weak var router: PreviewFlowCoordinatorOutput?
    
    var titles: [PokemonPreviewModel] = []
    private var limit: Int = 20
    
    // Published property to represent the current state of the ViewModel
    @Published var previewViewModelState: PreviewViewModelState = .initial
    var viewModelState: Published<PreviewViewModelState>.Publisher { $previewViewModelState }
    
    // PassthroughSubject to emit the result of the Pokemon list request
    private(set) var pokemonListResult = PassthroughSubject<Result<Void, Error>, Never>()
    
    private var cancellableSet: Set<AnyCancellable> = []
   
    init(router: PreviewFlowCoordinatorOutput) {
        self.router = router
        fetchData()
    }
    
    
    deinit {}
}

extension PreviewViewModel {
    
    /// Function to fetch data based on the current state
    func fetchData() {
        $previewViewModelState.sink { [weak self] _ in
            self?.showAlert("Error", "Error in fetching data")
        } receiveValue: { state in
            switch state {
            case .initial, .refreshData:
                Task {
                    do {
                        // Fetch Pokemon list from the service
                        let titles = try await self.pokemonService.getPokemonList(offset: 0, limit: self.limit)
                        self.titles = titles
                        // Send success result to the subject
                        self.pokemonListResult.send(.success(()))
                    } catch {
                        // Handle error by showing an alert
                        self.showAlert("Error", error.localizedDescription)
                    }
                }
            }
        } .store(in: &cancellableSet)
    }
    
    /// Function to show an alert with the given title and message
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            // Trigger showing the alert using the router
            self?.router?.trigger(.base(.alert(alertController)))
        }
    }
    
    /// Function to show Pokemon detail view
    func showDetail(id: Int) {
        router?.trigger(.showDetail(id: id))
    }
}
