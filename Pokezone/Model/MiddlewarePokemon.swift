//
//  MiddlewarePokemon.swift
//  Pokezone
//
//  Created by Aws Shkara on 14/08/2025.
//

import Foundation

struct MiddlewarePokemon: Decodable {
	let id: Int16
	let name: String
	let types: [String]
	let attack: Int16
	let defense: Int16
	let hp: Int16
	let specialAttack: Int16
	let specialDefense: Int16
	let speed: Int16
	let spriteURL: URL
	let shinyURL: URL
	
	enum CodingKeys: CodingKey {
		case id
		case name
		case types
		case stats
		case sprites
		
		enum TypeDictionaryKeys: CodingKey {
			case type
			
			enum TypeKeys: CodingKey {
				case name
			}
		}
		
		enum StatDictionaryKeys: CodingKey {
			case baseStat
		}
		
		enum SpriteKeys: String, CodingKey {
			case spriteURL = "frontDefault"
			case shinyURL = "frontShiny"
		}
		
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		var decodedTypes: [String] = []
		var decodedStats: [Int16] = []
		
		id = try container.decode(Int16.self, forKey: .id)
		name = try container.decode(String.self, forKey: .name)
		
		
		var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
		
		while !typesContainer.isAtEnd {
			let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.self)
			let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
			let type = try typeContainer.decode(String.self, forKey: .name)
			
			decodedTypes.append(type)
		}
		
		// just swapping flying pokemons types places. "Flying" type should be before "Normal"
		if decodedTypes.count == 2 && decodedTypes[0] == "normal" {
			decodedTypes.swapAt(0, 1)
		}
		
		types = decodedTypes
		
		var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
		while !statsContainer.isAtEnd {
			let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: CodingKeys.StatDictionaryKeys.self)
			let stat = try statsDictionaryContainer.decode(Int16.self, forKey: .baseStat)
			decodedStats.append(stat)
		}
		
		hp = decodedStats[0]
		attack = decodedStats[1]
		defense = decodedStats[2]
		specialAttack = decodedStats[3]
		specialDefense = decodedStats[4]
		speed = decodedStats[5]
		
		let spriteContainer = try container.nestedContainer(keyedBy: CodingKeys.SpriteKeys.self, forKey: .sprites)
		
		spriteURL = try spriteContainer.decode(URL.self, forKey: .spriteURL)
		shinyURL = try spriteContainer.decode(URL.self, forKey: .shinyURL)
	}
}


struct Stat: Identifiable {
	let id: Int
	let name: String
	let value: Int16
}
