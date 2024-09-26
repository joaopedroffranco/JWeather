//
// Created by Joao Pedro Franco on 24/09/24
//

import SwiftUI
import JUI

/// Represents the first and home screen that displays the initial weather forecast and manages searched locations.
struct HomeView: View {
	/// It is a `@StateObject` because it creates and maintains its own view model instance, eliminating the need for external injection.
	/// This allows for independent state management within the view.
	@StateObject var viewModel: HomeViewModel = .init()
	
	var body: some View {
		VStack {
			SearchBar(placeholder: "Try another location...", text: $viewModel.searchText)
				.padding(.top, DesignSystem.Spacings.xs)
			
			Spacer()
			content.onAppear { viewModel.onAppear() }
			Spacer()
		}
		.background(DesignSystem.Colors.background)
		/// When a location is tapped, it presents a modal sheet displaying the forecast information for that location.
		.sheet(item: $viewModel.locationTapped) { location in
			ForecastView(location: location)
		}
	}
}

extension HomeView {
	@ViewBuilder
	var content: some View {
		/// If there are searched locations, it displays their list; otherwise, it shows the initial weather forecast.
		if viewModel.locationsSearched.isEmpty {
			ForecastView(location: viewModel.initialLocation)
		} else {
			locationsContent
		}
	}
	
	@ViewBuilder
	var locationsContent: some View {
		JList(data: viewModel.locationsSearched) { location in
			Text("\(location.name), \(location.country)")
				.frame(height: 50)
				.padding(.horizontal, DesignSystem.Spacings.xs)
				.onTapGesture { viewModel.onTap(location: location) }
		}
	}
}
