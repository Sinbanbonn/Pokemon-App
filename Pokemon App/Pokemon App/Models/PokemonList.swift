import Foundation

struct PokemonList: Codable {
    
    let results: [Pokemon]

    enum CodingKeys: String, CodingKey {
        case results
    }
    
    static var placeholder: Self {
        return PokemonList(results: [])
    }
}

struct Pokemon: Codable {
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
