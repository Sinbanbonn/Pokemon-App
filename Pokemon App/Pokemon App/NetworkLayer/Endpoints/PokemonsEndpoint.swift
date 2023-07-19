import Foundation

enum PokemonEndpoint {
    case pokemonList(offset: Int)
    case pokemonDetails(id: Int)
}


extension PokemonEndpoint: Endpoint {
    var host: String {
        switch self {
        case .pokemonList, .pokemonDetails:
            return "pokeapi.co"
        }
    }
    
    var path: String {
        switch self {
        case .pokemonList(let offset):
            return "/api/v2/pokemon?offset=\(offset)&limit=20"
        case .pokemonDetails(let id):
            return "/\(id)/"
        }
    }

    var method: RequestMethod {
        switch self {
        case .pokemonDetails, .pokemonList:
            return .get
        }
    }

    var header: [String: String]? {
        
        switch self {
        case .pokemonList, .pokemonDetails:
            return nil
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .pokemonList, .pokemonDetails:
            return nil
        }
    }
}
