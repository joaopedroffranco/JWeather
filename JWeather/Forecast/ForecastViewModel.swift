//
// Created by Joao Pedro Franco on 24/09/24
//

import Foundation
import Combine
import JData

/// Possible states for the `ForecastView`
enum ForecastViewState: Equatable {
	case loading
	case data(Location, Forecast)
	case error(String?)
}

/// The `ObservableObject` view model for the `ForecastView`.
///
/// Initialized with a location, it manages the various states and interacts with the service layer using a `Combine` approach.
///
/// This view model ensures reactive updates to the UI based on changes in weather data.
class ForecastViewModel: ObservableObject {
	@Published var state: ForecastViewState = .loading

	private let location: Location
	private var service: ForecastServiceProtocol
	
	private var cancellables: Set<AnyCancellable> = []
	
	init(
		for location: Location,
		service: ForecastServiceProtocol = ForecastService()
	) {
		self.location = location
		self.service = service
	}
	
	/// Called when view needs to load the forecast data.
	func load() {
		fetchForecast()
	}
}

private extension ForecastViewModel {
	/// Subscribes to the service publisher, receiving updates on the main thread, and maps the data to the corresponding state.
	///
	/// This ensures that the UI is updated with the latest information while maintaining responsiveness.
	func fetchForecast() {
		service.fetch(
			latitude: location.coordinate.latitude,
			longitude: location.coordinate.longitude
		)
		.receive(on: RunLoop.main)
		.map { [weak self] forecast in
			guard let self = self, let forecast = forecast else { return .error(self?.location.name) }
			return .data(self.location, forecast)
		}
		.assign(to: &$state)
	}
}
