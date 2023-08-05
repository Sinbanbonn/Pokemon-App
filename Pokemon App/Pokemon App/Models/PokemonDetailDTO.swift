import Foundation

struct PokemonDetailDTO: Codable {
    let name: String
    let height: Int
    let weight: Int
    let types: [Typs]
    let sprites: Sprites
}

struct Typs: Codable {
    let slot: Int
    let type: TypeData
}

struct TypeData: Codable {
    let name: String
    let url: String
}

struct Sprites: Codable {
    let frontDefault: String
    let other: Other

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}

struct Other: Codable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String
    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
