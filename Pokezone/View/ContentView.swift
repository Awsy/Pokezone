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
						
					}
				}
			}
			
		}
	}
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
