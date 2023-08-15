import Foundation

/// Protocol for managing interactions with the Pokemon service.
protocol PokemonServiceable {
    /// Checks if the user is connected to a network.
    var isConnectedToNetwork: Bool { get }
    
    /// Fetches a list of Pokemon view models.
    ///
    /// - Parameters:
    ///   - offset: The offset for pagination.
    ///   - limit: The number of items to fetch.
    /// - Returns: An array of Pokemon view models.
    func getPokemonList(offset: Int, limit: Int) async throws -> [PokemonViewModel]
    
    /// Fetches detailed information about a Pokemon.
    ///
    /// - Parameter id: The ID of the Pokemon to fetch.
    /// - Returns: A PokemonDetail object containing detailed information.
    func getPokemonDetails(id: Int) async throws -> PokemonDetail
}

/// Key used for injecting the PokemonManager into InjectedValues.
private struct PokemonManagerKey: InjectionKey {
    // The initial value for the injection key is an instance of PokemonManager.
    static var currentValue: PokemonServiceable = PokemonManager()
}

/// Extension to manage the injection of PokemonManager.
extension InjectedValues {
    var pokemonManager: PokemonServiceable {
        get { Self[PokemonManagerKey.self] }
        set { Self[PokemonManagerKey.self] = newValue }
    }
}
