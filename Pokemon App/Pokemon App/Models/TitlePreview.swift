//
//  TitlePreview.swift
//  Pokemon App
//
//  Created by Андрей Логвинов on 7/17/23.
//

import Foundation

struct TitlePreview: Codable {
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

    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
