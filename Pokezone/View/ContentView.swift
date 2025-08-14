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
		NavigationStack {
			List {
				ForEach(pokemons) { pokemon in
					NavigationLink(value: pokemon) {
						AsyncImage(url: pokemon.sprite) { image in
								image
								.resizable()
								.scaledToFit()
								
						} placeholder: {
							ProgressView()
						}
						.frame(width: 100, height: 100)
						
						VStack(alignment: .leading) {
							Text(pokemon.name ?? "")
						}
						
					}
				}
				
			}
			.navigationTitle("Pokezone")
			.navigationDestination(for: Pokemon.self) { pokemon in
				HStack {
					AsyncImage(url: pokemon.sprite) { image in
						image
							.resizable()
							.scaledToFit()
						
					} placeholder: {
						ProgressView()
					}
					.frame(width: 100, height: 100)
					
					Text(pokemon.name ?? "No Name found")
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
