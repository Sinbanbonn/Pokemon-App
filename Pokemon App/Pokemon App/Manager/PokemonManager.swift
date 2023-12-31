import Foundation
import Reachability

final class PokemonManager {
    private let networkManager = NetworkService()
    static let shared = PokemonManager()
    private init() {}
    
    let reachability = try! Reachability()
    var isConnectedToNetwork: Bool {
        return reachability.connection != .unavailable
    }
    
    var paginationCounter: Int = 0
    
    func getPokemonList(offset: Int , limit: Int = 20 ,completion: @escaping(Result<[PokemonViewModel], Error>) -> Void){
        var pokemonArray: [PokemonViewModel] = [PokemonViewModel]()
        if isConnectedToNetwork {
            networkManager.getNetworkPokemonList(offset: self.paginationCounter * limit, limit: 20) { result in
                switch result {
                case .success(let items):
                    let results = items.results
                    for result in results {
                        pokemonArray.append(PokemonViewModel(titleName: result.name))
                    }
                    completion(.success(pokemonArray))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
            DispatchQueue.global(qos: .background).sync {
                for i in paginationCounter*offset...(paginationCounter+1)*(limit) {
                    self.networkManager.getNetworkPokemonInfo(id: i) { result in
                        switch result{
                        case .success(let pokemon):
                            CoreDataManager.shared.addPokemonToCoreData(pokemon: pokemon)
                        case .failure(let error):
                            print(error.localizedDescription)
                            
                        }
                    }
                }
            }
            self.paginationCounter += 1
        }
        else {
            var entities: [PokemonItem] = [PokemonItem]()
            entities = CoreDataManager.shared.fetchPokemonListItems()
            if !entities.isEmpty {
                for i in self.paginationCounter * limit...(self.paginationCounter + 1) * limit {
                    if i >= entities.count { return}
                    pokemonArray.append(PokemonViewModel(titleName: entities[i].name!))
                }
                paginationCounter += 1
                completion(.success(pokemonArray))
            }
            else {
                completion(.failure(RequestError.notFound))
            }
        }
    }
    
    func getPokemonDetails(id: Int, completion: @escaping(Result<PokemonDetailViewModel, Error>) -> Void) {
        if isConnectedToNetwork {
            networkManager.getNetworkPokemonInfo(id: id) { result in
                switch result {
                case .success(let pokemon):
                    let pokemonViewModel = PokemonDetailViewModel(
                        imageURL: pokemon.sprites.other.officialArtwork.frontDefault,
                        name: pokemon.name.capitalizeFirstLetter(),
                        height: pokemon.height,
                        weight: pokemon.weight,
                        type: pokemon.types.map { $0.type.name }.joined(separator: ", "))
                    
                    completion(.success(pokemonViewModel))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        else {
            let entities = CoreDataManager.shared.fetchPokemonListItems()
            if !entities.isEmpty {
                let pokemonViewModel = PokemonDetailViewModel(
                    imageURL: entities[id].imageURL!,
                    name: entities[id].name!.capitalizeFirstLetter(),
                    height: Int(entities[id].height),
                    weight: Int(entities[id].weight),
                    type: entities[id].type!
                )
                completion(.success(pokemonViewModel))
            }
            else {
                completion(.failure(RequestError.notFound))
            }
        }
    }
    
}
