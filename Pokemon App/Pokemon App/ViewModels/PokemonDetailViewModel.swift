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
    
    public func fetchData(with id: Int) async throws -> PokemonDetail {
        do {
            return try await PokemonManager.shared.getPokemonDetails(id: id)
        }
        catch {
            throw error
        }
    }
}


