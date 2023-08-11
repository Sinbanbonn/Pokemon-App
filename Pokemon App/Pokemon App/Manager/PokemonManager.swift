import Foundation
import Reachability

protocol PokemonServiceable {
    func getPokemonList(offset: Int , limit: Int) async throws-> [PokemonViewModel]
    func getPokemonDetails(id: Int) async throws -> PokemonDetail
}

final class PokemonManager: PokemonServiceable {
    private let networkManager = NetworkService()
    init() {}
    
    let reachability = try! Reachability()
    var isConnectedToNetwork: Bool {
        return reachability.connection != .unavailable
    }
    
    func getPokemonList(offset: Int , limit: Int = 20) async throws-> [PokemonViewModel] {
        var pokemonArray: [PokemonViewModel] = [PokemonViewModel]()
        if isConnectedToNetwork {
            do{
                let pokemons = try await networkManager.getNetworkPokemonList(offset: 0, limit: limit).results
                for pokemon in pokemons {
                    pokemonArray.append(PokemonViewModel(titleName: pokemon.name))
                }
                return pokemonArray
            }
            catch {
                print(error.localizedDescription)
                throw error
            }
        }
        else {
            return []
        }
    }
    
    func getPokemonDetails(id: Int) async throws -> PokemonDetail {
        if isConnectedToNetwork {
            do {
                let pokemon = try await networkManager.getNetworkPokemonInfo(id: id)
                let pokemonViewModel = PokemonDetail(
                    imageURL: pokemon.sprites.other.officialArtwork.frontDefault,
                    name: pokemon.name.capitalizeFirstLetter(),
                    height: pokemon.height,
                    weight: pokemon.weight,
                    type: pokemon.types.map { $0.type.name }.joined(separator: ", "))
                return pokemonViewModel
            }
            catch {
                throw error
            }
        }
        else {
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
            }
            else {
                throw RequestError.notFound
            }
        }
    }
    
}
