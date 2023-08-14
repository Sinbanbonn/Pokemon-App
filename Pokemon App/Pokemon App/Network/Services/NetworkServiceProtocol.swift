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
