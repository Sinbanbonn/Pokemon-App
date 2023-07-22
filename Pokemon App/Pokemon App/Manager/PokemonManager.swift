import Foundation
import Reachability

let reachability = try! Reachability()
var isConnectedToNetwork: Bool {
        return reachability.connection != .unavailable
}
//добавить решение ошибоки 
final class PokemonManager {
    private let networkManager = NetworkService()
    static let shared = PokemonManager()
    var counter: Int = 0
    private init() {}
    
    func getPokemonList(offset: Int , limit: Int = 20 ,completion: @escaping(Result<[PokemonViewModel], RequestError>) -> Void){
        var pokemonArray: [PokemonViewModel] = [PokemonViewModel]()
        if isConnectedToNetwork {
            print("IsConnected")
            networkManager.getNetworkPokemonList(offset: self.counter * limit, limit: 20) { result in
                self.counter += 1
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
                for i in offset...offset+limit {
                    self.networkManager.getNetworkPokemonInfo(id: i) { result in
                        switch result{
                        case .success(let pokemon):
                            CoreDataManager.shared.addPokemonToCoreData(pokemon: pokemon)
                        case .failure(let error): break
                            
                        }
                    }
                }
                print(CoreDataManager.shared.fetchPokemonListItems().count)
            }
        }
        else {
        
            let entities = CoreDataManager.shared.fetchPokemonListItems()
            print("entities.count =========================\(entities.count)")
            if !entities.isEmpty {
                for i in self.counter * limit...(self.counter + 1) * limit {
                    if i >= entities.count { return}
                    pokemonArray.append(PokemonViewModel(titleName: entities[i].name!))
                }
                counter += 1
                completion(.success(pokemonArray))
            }else {
                completion(.failure(.notFound))
            }
        }
        
    }
    
    func getPokemonDetails(id: Int, completion: @escaping(Result<PokemonDetailViewModel, RequestError>) -> Void) {
        if !isConnectedToNetwork {
            networkManager.getNetworkPokemonInfo(id: id) { result in
                switch result {
                case .success(let pokemon):
                    let pokemonViewModel = PokemonDetailViewModel(
                        imageURL: pokemon.sprites.other.officialArtwork.frontDefault,
                        name: pokemon.name.capitalizeFirstLetter(),
                        height: pokemon.height,
                        weight: pokemon.weight,
                        type: pokemon.types.map { $0.type.name }.joined(separator: ", "),
                        image: nil)
                    
                    completion(.success(pokemonViewModel))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        else {
            print("This method was called")
            let entities = CoreDataManager.shared.fetchPokemonListItems()
            if !entities.isEmpty {
                let pokemonViewModel = PokemonDetailViewModel(
                    imageURL: entities[id].imageURL!,
                    name: entities[id].name!.capitalizeFirstLetter(),
                    height: Int(entities[id].height),
                    weight: Int(entities[id].weight),
                    type: entities[id].type!,
                    image: entities[id].image)
                completion(.success(pokemonViewModel))
            }else {
                completion(.failure(.notFound))
            }
        }
    }
    
}
