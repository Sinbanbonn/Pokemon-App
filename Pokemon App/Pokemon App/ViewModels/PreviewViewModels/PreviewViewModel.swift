import Foundation
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
    
    private let networkService = NetworkService()
    
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
        //        let alert = AlertManager.createAlert(title: title, message: message, actions: [.ok(nil)], style: .alert)
        //        DispatchQueue.main.async { [weak self] in
        //            //self?.router?.trigger(.base(.alert(alert)))
        //        }
    }
    
    func showDetail(id: Int) {
        router?.trigger(.shovDetail(id: id))
    }
    
    func fetchData(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>{
        input.sink { [unowned self] event in
            switch event{
            case .viewDidLoad, .refreshData:
                Task {
                    let result = try await networkService.getNetworkPokemonList(offset: 0, limit: limit)
                    let titles: [PokemonViewModel] = result.results.map { pokemon in
                        PokemonViewModel(titleName: pokemon.name)
                    }
                    pokemonListResult.send(.setPokemons(pokemons: titles))
                }
            }
        }
        .store(in: &cancellableSet)
        return pokemonListResult.eraseToAnyPublisher()
    }
    
}
