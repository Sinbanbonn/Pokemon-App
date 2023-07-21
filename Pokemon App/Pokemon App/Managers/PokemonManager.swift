import Foundation
import Reachability

let reachability = try! Reachability()
var isConnectedToNetwork: Bool {
        return reachability.connection != .unavailable
}

final class PokemonManager {
    private let networkManager = NetworkService()
    static let shared = PokemonManager()
    private init() {}
    
    func getPokemonList()->[PokemonViewModel]{
        var pokemonArray: [PokemonViewModel] = [PokemonViewModel]()
        if isConnectedToNetwork {
            networkManager.getNetworkPokemonList(offset: 0, limit: 20) { result in
                switch result {
                case .success(let items):
                    let results = items.results
                    for result in results {
                        pokemonArray.append(PokemonViewModel(titleName: result.name))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
        }
    }
        else {
            
        }
}
////добавить в coreDataManager функцию очистки container
////в модель бд добавить такие поля , как фото(UIImage), type,weight, height
//проверяем интернет подключение , если есть , то делаем все действия с апи также , как и раньше
//                                          подгружаем парраллельно инфу в бд,
//                                 если нет, то берем данные с бд
