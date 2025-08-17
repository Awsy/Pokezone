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
	
	@FetchRequest<Pokemon>(sortDescriptors: []) private var allPokemons
	
	@FetchRequest<Pokemon>(sortDescriptors: [SortDescriptor(\.id)],
						   animation: .default
	) private var pokemons
	
	private let fetchPokemons = FetchingService()
	
	
	@State var searchText = ""
	@State var isFavorite = false
	
	private var predicate: NSPredicate {
		var predicates: [NSPredicate] = []
		if !searchText.isEmpty {
			predicates.append(NSPredicate(format: "name contains[c] %@", searchText))
		}
		
		if isFavorite {
			predicates.append(NSPredicate(format: "favorite == %d", true))
		}
		
		return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
	}
	
	var body: some View {
		
		if allPokemons.isEmpty {
			ContentUnavailableView {
				Label("No Pokemon", image: .nopokemon)
			} description: {
				Text("There is no pokemons list yet. \nFetch some pokemons to display.")
			} actions: {
				Button("Fetch Pokemons", systemImage: "antenna.radiowaves.left.and.right") {
					getPokemons()
				}
				.buttonStyle(.borderedProminent)
			}

		} else {
			
			NavigationStack {
				List {
					Section {
						ForEach(pokemons) { pokemon in
							NavigationLink(value: pokemon) {
								
								if pokemon.sprite == nil {
									AsyncImage(url: pokemon.spriteURL) { image in
										image
											.resizable()
											.scaledToFit()
										
									} placeholder: {
										ProgressView()
									}
									.frame(width: 110, height: 110)
								} else {
									pokemon.spriteImage
										.resizable()
										.scaledToFit()
										.frame(width: 110, height: 110)
								}
								
								VStack(alignment: .leading) {
									
									HStack {
										Text(pokemon.name?.capitalized ?? "")
											.fontWeight(.bold)
										
										if pokemon.favorite {
											Image(systemName: "star.fill")
												.foregroundStyle(.yellow)
										}
									}
									
									HStack {
										ForEach(pokemon.types!, id: \.self) { type in
											Text(type.capitalized)
												.font(.subheadline)
												.fontWeight(.semibold)
												.foregroundStyle(.black)
												.padding(.horizontal, 10)
												.padding(.vertical, 5)
												.background(Color(type.capitalized))
												.clipShape(.capsule)
										}
									}
								}
								
							}
							.swipeActions(edge: .leading) {
								Button(pokemon.favorite ? "Remove from Favorites" : "Add to Favorites", systemImage: "star") {
									pokemon.favorite.toggle()
									do {
										try viewContext.save()
									
									} catch {
										print(error)
									}
								}
								.tint(pokemon.favorite ? .gray : .yellow)
							}
						}
						.padding()
					}
					.background(.clear.mix(with: .indigo, by: 0.3))
					.clipShape(.rect(cornerRadius: 10))
					
				}
				.navigationTitle("Pokezone")
				.searchable(text: $searchText, prompt: "Search a Pokemon...")
				.autocorrectionDisabled()
				.onChange(of: searchText) {
					pokemons.nsPredicate = predicate
				}
				.onChange(of: isFavorite) {
					pokemons.nsPredicate = predicate
				}
				.navigationDestination(for: Pokemon.self) { pokemon in
					PokemonDetailsView()
						.environmentObject(pokemon)
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							isFavorite.toggle()
						} label: {
							Label("Filter Pokemons", systemImage: isFavorite ? "star.fill" : "star")
						}
						.tint(.yellow)
					}
				}
				
			}
			.task {
				getPokemons()
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
					pokemon.shinyURL = fetchedPokemons.shinyURL
					pokemon.spriteURL = fetchedPokemons.spriteURL
					
					try viewContext.save()
					
				} catch {
					print(error)
				}
			}
			storeImages()
		}
	}
	
	func storeImages() {
		Task {
			do {
				for pokemon in allPokemons {
					pokemon.sprite = try await URLSession.shared.data(from: pokemon.spriteURL!).0
					pokemon.shiny = try await URLSession.shared.data(from: pokemon.shinyURL!).0
					
					try viewContext.save()
				}
			} catch {
				print(error)
			}
		}
	}
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
