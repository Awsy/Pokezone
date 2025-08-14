//
//  FetchingService.swift
//  Pokezone
//
//  Created by Aws Shkara on 14/08/2025.
//

import Foundation

struct FetchingService {
	enum FetchError: Error {
		case badResponse
	}
	
	private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
	
	func fetchPokemons(_ id: Int) async throws-> MiddlewarePokemon {
		let fetchURL = baseURL.appending(path: String(id))
		
		let (data, response) = try await URLSession.shared.data(from: fetchURL)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw FetchError.badResponse
		}
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		
		let pokemon = try decoder.decode(MiddlewarePokemon.self, from: data)
		
		return pokemon
	}
}
