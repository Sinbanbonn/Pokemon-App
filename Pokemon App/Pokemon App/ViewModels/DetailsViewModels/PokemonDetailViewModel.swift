import Foundation
import Combine

struct PokemonDetail {
    let imageURL: String
    let name: String
    let height: Int
    let weight: Int
    let type: String
}

class PokemonDetailViewModel: PokemonDetailViewModelProtocol, PokemonDetailViewModelInput, PokemonDetailViewModelOutput  {
    
    enum Input {
        case getPokemonsDetailt
    }
    
    enum Output {
        case setPokemonDetail(pokemonDetail: PokemonDetail)
    }
    
    internal var id: Int
    
    @Injected(\.pokemonManager) private var pokemonService: PokemonServiceable
    
    private var cancellableSet: Set<AnyCancellable> = []
    internal var pokemonDetailResult = PassthroughSubject<PokemonDetailViewModel.Output, Never>()
    
    private weak var router: AuthFlowCoordinatorOutput?
    
    init(router: AuthFlowCoordinatorOutput, id: Int) {
        self.router = router
        self.id = id
    }
    
    func fetchData(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>{
        input.sink { [unowned self] event in
            switch event{
            case .getPokemonsDetailt:
                Task {
                    let result = try await pokemonService.getPokemonDetails(id: id)
                    pokemonDetailResult.send(.setPokemonDetail(pokemonDetail: result))
                }
            }
        }
        .store(in: &cancellableSet)
        return pokemonDetailResult.eraseToAnyPublisher()
    }
}


