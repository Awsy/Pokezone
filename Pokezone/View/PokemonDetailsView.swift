//
//  PokemonDetailsView.swift
//  Pokezone
//
//  Created by Aws Shkara on 15/08/2025.
//

import SwiftUI
import CoreData

struct PokemonDetailsView: View {
	
	@Environment(\.managedObjectContext) private var viewContext
	@EnvironmentObject private var pokemon: Pokemon
	@State private var isShiny = false
	
	var body: some View {
		ScrollView {
			
			ZStack {
				Image(.rockgroundsteelfightingghostdarkpsychic)
					.resizable()
					.scaledToFit()
					.shadow(color: .black, radius: 5)
				
				AsyncImage(url: pokemon.sprite) { image in
					image
						.interpolation(.none)
						.resizable()
						.scaledToFit()
						.padding(.top, 30)
						.shadow(color: .white, radius: 2)
				} placeholder: {
					ProgressView()
				}
			}
			
			HStack {
				ForEach(pokemon.types!, id: \.self) { type in
					Text(type.capitalized)
						.font(.title2)
						.fontWeight(.semibold)
						.foregroundStyle(.black)
						.shadow(color: .brown, radius: 1)
						.padding(.horizontal)
						.padding(.vertical, 8)
						.background(Color(type.capitalized))
						.clipShape(.capsule)
				}
				
				Spacer()
				
				Button {
					pokemon.favorite.toggle()
					
					do {
						try viewContext.save()
					} catch {
						print(error)
					}
				} label: {
					Image(systemName: pokemon.favorite ? "star.fill" : "star")
						.font(.largeTitle)
						.tint(.yellow)
				}
			}
			.padding()
			
			
		}
		.navigationTitle(pokemon.name?.capitalized ?? "Unknown Pokemon")
	}
}

#Preview {
	NavigationStack{
		PokemonDetailsView()
			.environmentObject(PersistenceController.previewPokemon)
	}
}
