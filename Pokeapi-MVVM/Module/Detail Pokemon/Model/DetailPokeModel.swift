//
//  DetailPokeModel.swift
//  Pokeapi-MVVM
//
//  Created by Fathya on 20/03/25.
//

import Foundation

/// semuanya
struct DetailPokeModel: Decodable {
    let id: Int
    let name: String
    let sprites: SpritesModel
    var moves: [MovesModel]
    let stats: [StatsModel]
    
    var hp: Int {
        for stat in stats {
            if stat.stat.name == "hp" {
                return stat.baseStat
            }
        }
        return 0
    }
    
///   return by index
//    var hp: Int {
//        var health2: Int {
//            if stats.count > 0 {
//                return stats[0].baseStat
//            }
//            return 0
//        }
//    }
}

/// sprites
struct SpritesModel: Codable {
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "front_default"
    }
}

/// moves
struct MovesModel: Decodable {
    var move: MoveModel
}

struct MoveModel: Decodable {
    let name: String
    let url: String
    var detail: MoveDetailModel?
}

struct MoveDetailModel: Decodable {
    let accuracy: Int?
    let effectEntries: [EffectModel]
    
    enum CodingKeys: String, CodingKey {
        case accuracy
        case effectEntries = "effect_entries"
    }
    
    var effectString: String? {
        let firstEntry = effectEntries[0]
        let shortEffect = firstEntry.shortEffect != nil ? firstEntry.shortEffect : nil
        let effect = firstEntry.effect != nil ? firstEntry.effect : shortEffect
        return effect
    }
}

struct EffectModel: Codable {
    let effect: String?
    let shortEffect: String?
    
    enum CodingKeys: String, CodingKey {
        case effect
        case shortEffect = "short_effect"
    }
}

/// stats
struct StatsModel: Codable {
    let baseStat: Int
    let stat: StatModel
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatModel: Codable {
    let name: String
}


