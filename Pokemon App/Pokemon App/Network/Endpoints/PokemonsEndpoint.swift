import Foundation

enum PokemonEndpoint {
    case pokemonList(offset: Int, limit: Int)
    case pokemonDetails(id: Int)
    case pokemonListCombine(limit: Int)
}

extension PokemonEndpoint: Endpoint {
    var host: String {
        switch self {
        case .pokemonList, .pokemonDetails, .pokemonListCombine:
            return "pokeapi.co"
        }
    }
    
    var path: String {
        switch self {
        case .pokemonList(let offset, let limit):
            return "/api/v2/pokemon?offset=\(offset)&limit=\(limit)"
        case .pokemonDetails(let id):
            return "/api/v2/pokemon/\(id+1)/"
        case .pokemonListCombine(let limit):
            return "/api/v2/pokemon?offset=\(0)&limit=\(limit)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .pokemonDetails, .pokemonList, .pokemonListCombine:
            return .get
        }
    }

    var header: [String: String]? {
        
        switch self {
        case .pokemonList, .pokemonDetails, .pokemonListCombine:
            return nil
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .pokemonList, .pokemonDetails, .pokemonListCombine:
            return nil
        }
    }
}
