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
