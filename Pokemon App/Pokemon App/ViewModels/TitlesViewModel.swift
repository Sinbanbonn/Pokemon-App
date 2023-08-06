import Foundation


final class TitlesViewModel {
    var titles: [PokemonViewModel] = [PokemonViewModel]()
    private let pokSer = NetworkService()

    public func fetchData() async throws -> [PokemonViewModel] {
        do {
            let results = try await PokemonManager.shared.getPokemonList(offset: 0)
            titles += results
            return titles
        }
        catch {
            throw error
        }
    }
}
