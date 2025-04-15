//
//  PokemonModel.swift
//  Pokeapi-MVVM
//
//  Created by Fathya on 20/03/25.
//

import Foundation

struct PokemonModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    var results: [Results]
}

struct Results: Codable {
    let name: String
    let url: String
    var image: PokemonImageModel?
}

struct PokemonImageModel: Codable {
    let sprites: SpritesModel
}

