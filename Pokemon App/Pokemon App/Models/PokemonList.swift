import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
    let next: String

    enum CodingKeys: String, CodingKey {
        case results
        case next
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
