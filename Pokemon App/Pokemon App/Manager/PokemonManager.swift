import Foundation
import Reachability

final class PokemonManager {
    // Inject the network service using property wrapper
    @Injected(\.networkService) private var networkManager: NetworkServiciable
    
    // Initialize Reachability for network status
    private var reachability: Reachability? = {
        do {
            return try Reachability()
        } catch {
            return nil
        }
    }()
}

// MARK: - Conforming to PokemonServiceable
extension PokemonManager: PokemonServiceable {
    var isConnectedToNetwork: Bool {
        return reachability?.connection != .unavailable
    }
    
    func getPokemonList(offset: Int, limit: Int = 20) async throws -> [PokemonViewModel] {
        // Use network data if available, otherwise return empty array
        return await isConnectedToNetwork ? try getArrayFromNetwork(offset: offset, limit: limit) : []
    }
    
    func getPokemonDetails(id: Int) async throws -> PokemonDetail {
        // Use network data if available, otherwise try to get data from DB
        return await isConnectedToNetwork ? try getNetworkDetails(id: id) : try getDBDetails(id: id)
    }
}

// MARK: - Private methods for getting arrays of Pokemons
private extension PokemonManager {
    func getArrayFromNetwork(offset: Int, limit: Int) async throws -> [PokemonViewModel] {
        do {
            var pokemonArray: [PokemonViewModel] = []
            let pokemons = try await networkManager.getNetworkPokemonList(offset: 0, limit: limit).results
            
            // Map network data to view models
            for pokemon in pokemons {
                pokemonArray.append(PokemonViewModel(titleName: pokemon.name))
            }
            
            return pokemonArray
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

// MARK: - Private methods for getting details
private extension PokemonManager {
    func getNetworkDetails(id: Int) async throws -> PokemonDetail {
        do {
            // Get Pokemon details from the network
            let pokemon = try await networkManager.getNetworkPokemonInfo(id: id)
            let pokemonViewModel = PokemonDetail(
                imageURL: pokemon.sprites.other.officialArtwork.frontDefault,
                name: pokemon.name.capitalizeFirstLetter(),
                height: pokemon.height,
                weight: pokemon.weight,
                type: pokemon.types.map { $0.type.name }.joined(separator: ", ")
            )
            return pokemonViewModel
        } catch {
            throw error
        }
    }
    
    func getDBDetails(id: Int) async throws -> PokemonDetail {
        // Try to fetch data from the database, handle not found case
        let entities = CoreDataManager.shared.fetchPokemonListItems()
        
        if !entities.isEmpty {
            let pokemonViewModel = PokemonDetail(
                imageURL: entities[id].imageURL!,
                name: entities[id].name!.capitalizeFirstLetter(),
                height: Int(entities[id].height),
                weight: Int(entities[id].weight),
                type: entities[id].type!
            )
            return pokemonViewModel
        } else {
            throw RequestError.notFound
        }
    }
}
