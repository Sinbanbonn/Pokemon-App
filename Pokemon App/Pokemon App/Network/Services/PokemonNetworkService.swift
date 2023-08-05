import Foundation

protocol PokemonServiciable {
    func getNetworkPokemonList(offset: Int, limit: Int, completion: @escaping (Result<PokemonList, RequestError>) -> Void)
    func getNetworkPokemonInfo(id: Int, completion: @escaping (Result<PokemonDetailDTO, RequestError>) -> Void)
}

struct NetworkService: HTTPClient, PokemonServiciable {
    func getNetworkPokemonList(offset: Int, limit: Int, completion: @escaping (Result<PokemonList, RequestError>) -> Void) {
        sendRequest(endpoint: PokemonEndpoint.pokemonList(offset: offset, limit: limit),
                    responseModel: PokemonList.self,
                    completion: completion)
    }
    
    func getNetworkPokemonInfo(id: Int, completion: @escaping (Result<PokemonDetailDTO, RequestError>) -> Void) {
        sendRequest(endpoint: PokemonEndpoint.pokemonDetails(id: id),
                    responseModel: PokemonDetailDTO.self,
                    completion: completion)
    }
    
    

}
