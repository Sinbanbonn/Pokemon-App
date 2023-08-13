import Foundation
import Combine

protocol NetworkServiciable {
    func getNetworkPokemonList(offset: Int, limit: Int) async throws ->  PokemonList
    func getNetworkPokemonInfo(id: Int) async throws -> PokemonDetailDTO
}

private struct NetworkServiceKey: InjectionKey {
    static var currentValue: NetworkServiciable = NetworkService()
}

extension InjectedValues {
    var networkService: NetworkServiciable {
        get { Self[NetworkServiceKey.self] }
        set { Self[NetworkServiceKey.self] = newValue }
    }
}
struct NetworkService: HTTPClient, NetworkServiciable {
    
    func getNetworkPokemonInfo(id: Int) async  throws -> PokemonDetailDTO {
        try await sendRequest(endpoint: PokemonEndpoint.pokemonDetails(id: id),
                          responseModel: PokemonDetailDTO.self)
    }
    
    func getNetworkPokemonList(offset: Int,  limit: Int) async throws -> PokemonList {
        try await sendRequest(endpoint: PokemonEndpoint.pokemonList(offset: 0,limit: limit),
                          responseModel: PokemonList.self)
    }
    
}
