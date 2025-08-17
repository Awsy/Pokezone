//
//  PokemonStatsView.swift
//  Pokezone
//
//  Created by Aws Shkara on 17/08/2025.
//

import SwiftUI
import Charts


struct PokemonStatsView: View {
	var pokemon: Pokemon
	
	var body: some View {
		Chart(pokemon.stats) { stat in
			BarMark(x: .value("Value", stat.value),
					y: .value("Stat", stat.name))
			.annotation(position: .trailing) {
				Text("\(stat.value)")
					.font(.subheadline)
					.foregroundStyle(.gray)
					.padding(.top, -5)
			}
		}
		.frame(height: 200)
		.foregroundStyle(pokemon.typeColor)
		.padding([.horizontal, .bottom])
		.chartXScale(domain: 0...pokemon.highStat.value + 10)
	}
}

#Preview {
	PokemonStatsView(pokemon: PersistenceController.previewPokemon)
}
