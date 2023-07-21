import Foundation

protocol PokemonServiciable {
    func getNetworkPokemonList(offset: Int, limit: Int, completion: @escaping (Result<PokemonList, RequestError>) -> Void)
    func getNetworkPokemonInfo(id: Int, completion: @escaping (Result<PokemonPreview, RequestError>) -> Void)
}

struct NetworkService: HTTPClient, PokemonServiciable {
    func getNetworkPokemonList(offset: Int, limit: Int, completion: @escaping (Result<PokemonList, RequestError>) -> Void) {
        sendRequest(endpoint: PokemonEndpoint.pokemonList(offset: offset, limit: limit),
                    responseModel: PokemonList.self,
                    completion: completion)
    }
    
    func getNetworkPokemonInfo(id: Int, completion: @escaping (Result<PokemonPreview, RequestError>) -> Void) {
        sendRequest(endpoint: PokemonEndpoint.pokemonDetails(id: id),
                    responseModel: PokemonPreview.self,
                    completion: completion)
    }
    
    

}
