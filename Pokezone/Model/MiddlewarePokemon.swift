//
//  MiddlewarePokemon.swift
//  Pokezone
//
//  Created by Aws Shkara on 14/08/2025.
//

import Foundation

struct MiddlewarePokemon: Codable {
	let id: Int16
	let name: String
	let types: [String]
	let attack: Int16
	let defense: Int16
	let hp: Int16
	let specialAttack: Int16
	let specialDefense: Int16
	let speed: Int16
	let sprite: URL
	let shiny: URL
}
