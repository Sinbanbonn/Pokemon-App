import Foundation
import Combine

/// Enum representing different states for the DetailViewModel
enum DetailViewModelState {
    case viewDidLoad
    case refreshData
}

final class DetailViewModel: DetailViewModelProtocol, DetailViewModelInput, DetailViewModelOutput  {
    
    // Inject the Pokemon service using property wrapper
    @Injected(\.pokemonManager) private var pokemonService: PokemonServiceable
    private weak var router: PreviewFlowCoordinatorOutput?
    
    // Property to store the ID of the Pokemon detail
    private(set) var id: Int
    
    // Property to hold the Pokemon detail information
    var detail: PokemonDetail = PokemonDetail(imageURL: "", name: "", height: 0, weight: 0, type: "")
    
    // Published property for the ViewModel's state
    @Published var detailViewModelState: DetailViewModelState = .viewDidLoad
    var viewModelState: Published<DetailViewModelState>.Publisher { $detailViewModelState }
    
    // PassthroughSubject to emit the result of the Pokemon detail request
    private(set) var detailModelResult = PassthroughSubject<Result<Void, Error>, Never>()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(router: PreviewFlowCoordinatorOutput, id: Int) {
        self.router = router
        self.id = id
        fetchData()
    }

    /// Function to fetch the Pokemon detail
    func fetchData() {
        $detailViewModelState
            .receive(on: DispatchQueue.main)
            .sink ( receiveValue: { state in
                switch state {
                case .viewDidLoad, .refreshData:
                    Task {
                        do {
                            // Fetch Pokemon detail from the service
                            let detail = try await self.pokemonService.getPokemonDetails(id: self.id)
                            self.detail = detail
                            // Send success result to the subject
                            self.detailModelResult.send(.success(()))
                        } catch {
                            // Send error result to the subject
                            self.detailModelResult.send(.failure(error))
                        }
                    }
                }
            }) .store(in: &cancellableSet)
    }
}
