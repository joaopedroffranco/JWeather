//
//  Created by Joao Pedro Franco on 23/09/24.
//

import SwiftUI

/// Represents the screen that displays the inner forecast view, managing its states.
struct ForecastView: View {
	/// It is a `@StateObject` because it creates and maintains its own view model instance, eliminating the need for external injection.
	/// This allows for independent state management within the view.
	@StateObject var viewModel: ForecastViewModel
	
	init(location: Location) {
		self._viewModel = StateObject(wrappedValue: ForecastViewModel(for: location))
	}
	
	var body: some View {
		content.onAppear { viewModel.load() }
	}
}

private extension ForecastView {
	@ViewBuilder
	/// Manages the possible states: `.data`, `.loading`, and `.error`.
	var content: some View {
		switch viewModel.state {
		case .loading:
			ProgressView()
		case let .error(name):
			Text("Sorry :(\n\nCouldn't load the forecast for\n\(name ?? "")")
				.multilineTextAlignment(.center)
		case let .data(location, forecast):
			ForecastInnerView(
				locationName: location.name,
				weather: forecast.current,
				warnings: forecast.warnings
			)
		}
	}
}
