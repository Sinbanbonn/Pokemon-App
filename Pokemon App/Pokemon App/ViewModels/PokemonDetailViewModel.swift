import Foundation

struct PokemonDetail {
    let imageURL: String
    let name: String
    let height: Int
    let weight: Int
    let type: String
}

class PokemonDetailViewModel {
    
    var viewModel: PokemonDetail?
    
    init(viewModel: PokemonDetail? = nil) {
        self.viewModel = viewModel
    }
    
    public func fetchData(with id: Int, completion: @escaping(() -> Void)) {
        PokemonManager.shared.getPokemonDetails(id: id) { [weak self] result in
            switch result {
            case .success(let pokemon):
                self?.viewModel = pokemon
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


