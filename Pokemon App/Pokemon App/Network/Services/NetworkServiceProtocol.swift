protocol NetworkServiciable {
    /// Fetches a list of Pokemon from the network.
    ///
    /// - Parameters:
    ///   - offset: The offset for pagination.
    ///   - limit: The number of items to fetch.
    /// - Returns: A PokemonList containing fetched Pokemon.
    func getNetworkPokemonList(offset: Int, limit: Int) async throws -> PokemonList
    
    /// Fetches detailed information about a Pokemon from the network.
    ///
    /// - Parameter id: The ID of the Pokemon to fetch.
    /// - Returns: A PokemonDetailDTO containing detailed information about the Pokemon.
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
