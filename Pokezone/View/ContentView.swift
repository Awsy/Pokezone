//
//  ContentView.swift
//  Pokezone
//
//  Created by Aws Shkara on 18/06/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
	@Environment(\.managedObjectContext) private var viewContext
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
		animation: .default)
	
	private var pokemons: FetchedResults<Pokemon>
	let fetchPokemons = FetchingService()
	
	var body: some View {
		NavigationView {
			List {
				ForEach(pokemons) { pokemon in
					NavigationLink {
						Text(pokemon.name ?? "")
					} label: {
						Text(pokemon.name ?? "")
					}
				}
				
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					EditButton()
				}
				ToolbarItem {
					Button("Add Item", systemImage: "plus") {
						getPokemons()
					}
				}
			}
			
		}
	}
	
	func getPokemons() {
		Task {
			for id in 1..<200 {
				do {
					let fetchedPokemons = try await fetchPokemons.fetchPokemons(id)
					let pokemon = Pokemon(context: viewContext)
					
					pokemon.id = fetchedPokemons.id
					pokemon.name = fetchedPokemons.name
					pokemon.types = fetchedPokemons.types
					pokemon.attack = fetchedPokemons.attack
					pokemon.defense = fetchedPokemons.defense
					pokemon.hp = fetchedPokemons.hp
					pokemon.specialAttack = fetchedPokemons.specialAttack
					pokemon.specialDefense = fetchedPokemons.specialDefense
					pokemon.speed = fetchedPokemons.speed
					pokemon.shiny = fetchedPokemons.shiny
					pokemon.sprite = fetchedPokemons.sprite
					
					try viewContext.save()
					
				} catch {
					print(error)
				}
			}
		}
	}
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
