//
// Created by Joao Pedro Franco on 24/09/24
//

import Combine
import JData
import CoreLocation

/// The `ObservableObject` view model for the `HomeView`.
///
/// Initialized with an initial location, it manages the `@Published` properties related to the search feature, displaying either the initial forecast or a list of searched locations. Also using `Combine` approach.
///
/// This view model ensures reactive updates to the UI based on changes in weather data and user interactions.
class HomeViewModel: ObservableObject {
	@Published var searchText: String = ""
	@Published var locationsSearched: [Location] = []
	@Published var locationTapped: Location?
	
	var initialLocation = Location(
		name: "Amsterdam",
		country: "NL",
		coordinate: CLLocationCoordinate2D(latitude: 52.364138, longitude: 4.891697)
	)
	private var locationService: SearchServiceProtocol
	private var cancellables: Set<AnyCancellable> = []
	
	init(locationService: SearchServiceProtocol = SearchService()) {
		self.locationService = locationService
	}
	
	/// Called when view did appear, setting up the observers.
	func onAppear() {
		setupSearchObserver()
	}
	
	/// Called when the user taps on a searched location, publishing it to the view.
	func onTap(location: Location) {
		locationTapped = location
	}
}

private extension HomeViewModel {
	func setupSearchObserver() {
		/// Subscribes to the search text from the Search Bar, updating the service search accordingly.
		/// This operation debounces input by 300 milliseconds to prevent service overloads and improve performance.
		$searchText
			.debounce(for: .milliseconds(300), scheduler: RunLoop.main)
			.sink { [weak self] text in
				guard let self = self else { return }
				self.locationService.search(text: text)
			}
			.store(in: &cancellables)
		
		/// Assigns the searched locations to its publisher and updates the view accordingly.
		locationService.locations
			.receive(on: RunLoop.main)
			.assign(to: &$locationsSearched)
	}
}
