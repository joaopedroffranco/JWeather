//
// Created by Joao Pedro Franco on 24/09/24
//

import Combine
import MapKit

/// Protocol for searching and retrieving filtered locations.
///
/// This protocol defines the requirements for implementing location search functionality, returning a list of matching results.
protocol SearchServiceProtocol {
	var locations: CurrentValueSubject<[Location], Never> { get set }
	func search(text: String)
}

/// Conforms to `SearchServiceProtocol` and wraps the native `MKLocalSearchCompleter` to search locations.
///
/// The `MKLocalSearchCompleter` is used because it's one of the best native solutions for finding a list of placemarks.
/// The `CLGeocoder` was considered, but it is limited and does not return results that meet the expected use case.
class SearchService: NSObject, SearchServiceProtocol {
	private let completer: MKLocalSearchCompleter
	
	/// A `CurrentValueSubject` that publishes a list of filtered locations.
	///
	/// A `CurrentValueSubject` is used here because the final value is important and needs to be retained.
	var locations: CurrentValueSubject<[Location], Never> = .init([])
	
	init(completer: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
		self.completer = completer
		self.completer.resultTypes = .address
		super.init()

		self.completer.delegate = self
	}
	
	/// Applies the search text to the `MKLocalSearchCompleter` to update location search completion.
	func search(text: String) {
		completer.queryFragment = text
	}
}

// MARK: - Delegate
extension SearchService: MKLocalSearchCompleterDelegate {
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		Task { await mapLocation(from: completer.results) }
	}
	
	func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
		locations.send([])
	}
}

private extension SearchService {
	/// Maps and converts the results from `MKLocalSearchCompletion` into the expected `[Location]` format.
	func mapLocation(from results: [MKLocalSearchCompletion]) async {
		var searchResults: [Location] = []
		
		/// To enhance performance, each result is processed in a separate task, as they don't need to wait for one another.
		await withTaskGroup(of: Location?.self) { group in
			results.forEach { result in
				group.addTask {
					/// A native solution for obtaining a `CLPlacemark` from `MKLocalSearchCompletion`.
					/// The `CLPlacemark` is required to retrieve the coordinates of the searched location.
					let request = MKLocalSearch.Request(completion: result)
					let search = MKLocalSearch(request: request)
					
					guard let response = try? await search.start() else { return nil }
					for item in response.mapItems {
						let placemark = item.placemark
						if let location = placemark.location, let name = placemark.name, let country = placemark.countryCode {
							/// Creates a `Location` instance from a given `CLPlacemark`.
							return Location(
								name: name,
								country: country,
								coordinate: location.coordinate
							)
						} else {
							return nil
						}
					}
					
					return nil
				}
			}

			/// When the task group completes, it appends each individually mapped `Location` to the final array.
			for await result in group {
				if let data = result {
					searchResults.append(data)
				}
			}
		}

		locations.send(searchResults)
	}
}
