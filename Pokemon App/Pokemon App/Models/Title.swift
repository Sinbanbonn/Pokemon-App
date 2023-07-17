import Foundation

struct Title: Codable {
    let results: [Pokemon]
    
    enum CodingKeys: String , CodingKey{
        case results
    }
}

struct Pokemon: Codable {
    let name: String
    let url: String
    
    enum CodingKeys: String , CodingKey{
        case name
        case url
    }
}
