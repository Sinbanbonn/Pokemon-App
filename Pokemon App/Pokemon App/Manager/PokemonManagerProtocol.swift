import Foundation

// Protocol for the Pokemon service
protocol PokemonServiceable {
    var isConnectedToNetwork: Bool { get }
    func getPokemonList(offset: Int, limit: Int) async throws -> [PokemonViewModel]
    func getPokemonDetails(id: Int) async throws -> PokemonDetail
}

// Key for injecting PokemonManager into InjectedValues
private struct PokemonManagerKey: InjectionKey {
    // Initial value for the injection key is an instance of PokemonManager
    static var currentValue: PokemonServiceable = PokemonManager()
}

// Extension to manage the injection of PokemonManager
extension InjectedValues {
    var pokemonManager: PokemonServiceable {
        get { Self[PokemonManagerKey.self] }
        set { Self[PokemonManagerKey.self] = newValue }
    }
}
