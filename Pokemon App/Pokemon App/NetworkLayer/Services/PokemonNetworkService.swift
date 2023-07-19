import Foundation

protocol RepoServiciable {
    func getPokemonList(offset: Int, completion: @escaping (Result<PokemonList, RequestError>) -> Void)
    func getPokemonInfo(id: Int, completion: @escaping (Result<PokemonPreview, RequestError>) -> Void)
}

struct RepoService: HTTPClient, RepoServiciable {
    func getPokemonList(offset: Int, completion: @escaping (Result<PokemonList, RequestError>) -> Void) {
        sendRequest(endpoint: PokemonEndpoint.pokemonList(offset: offset),
                    responseModel: PokemonList.self,
                    completion: completion)
    }
    
    func getPokemonInfo(id: Int, completion: @escaping (Result<PokemonPreview, RequestError>) -> Void) {
        sendRequest(endpoint: PokemonEndpoint.pokemonDetails(id: id),
                    responseModel: PokemonPreview.self,
                    completion: completion)
    }
    
    

}
