//
// Created by Joao Pedro Franco on 25/09/24
//
	
import Combine
@testable import JWeather

/// A mock implementation of `SearchServiceProtocol` that publishes predefined searched text and locations.
///
/// This fake data source is utilized in tests to simulate responses, enabling controlled and predictable outcomes for testing scenarios.
class FakeSearchService: SearchServiceProtocol {
	var searchedText: PassthroughSubject<String, Never> = .init()
	var locations: CurrentValueSubject<[Location], Never> = .init([])
	
	func search(text: String) {
		searchedText.send(text)
	}
}
