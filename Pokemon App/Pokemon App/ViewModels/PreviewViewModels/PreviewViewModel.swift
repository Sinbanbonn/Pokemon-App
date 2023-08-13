import Foundation
import UIKit
import Combine


final class PreviewViewModel: PreviewViewModelProtocol,
                              PreviewViewModelInput,
                              PreviewViewModelOutput {
    enum Input {
        case viewDidLoad
        case refreshData
    }
    
    enum Output {
        case setPokemons(pokemons: [PokemonViewModel])
        case updateView
    }
    
    @Injected(\.pokemonManager) private var pokemonService: PokemonServiceable
    
    private weak var router: AuthFlowCoordinatorOutput?
    
    private(set) var pokemonListResult = PassthroughSubject<PreviewViewModel.Output, Never>()
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var limit: Int = 20
    
    init(router: AuthFlowCoordinatorOutput) {
        self.router = router
    }
    
    deinit {}
    
}

extension PreviewViewModel {
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.router?.trigger(.base(.alert(alertController)))
        }
    }
    
    func showDetail(id: Int) {
        router?.trigger(.shovDetail(id: id))
    }
    
    func fetchData(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>{
        input.sink { [unowned self] event in
            switch event{
            case .viewDidLoad, .refreshData:
                Task {
                    do{
                    let titles = try await pokemonService.getPokemonList(offset: 0, limit: limit)
                    pokemonListResult.send(.setPokemons(pokemons: titles))
                }
                    catch {
                        showAlert("Error", error.localizedDescription)
                        
                    }
                }
            }
            
        }
        .store(in: &cancellableSet)
        return pokemonListResult.eraseToAnyPublisher()
    }
    
}
