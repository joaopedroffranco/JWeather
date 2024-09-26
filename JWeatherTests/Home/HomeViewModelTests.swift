//
// Created by Joao Pedro Franco on 25/09/24
//
	
import XCTest
import Combine
@testable import JWeather

/// Tests for the `HomeViewModel`.
///
/// This test suite verifies that the view model correctly handles searches, updates the list of searched locations, and responds appropriately when a user taps on a location.
class HomeViewModelTests: XCTestCase {
	private let location = Location(
		name: "Test",
		country: "Mine",
		coordinate: .init(latitude: 12, longitude: 15)
	)
	private var cancellables: Set<AnyCancellable> = []
	
	// MARK: - Search
	func testTypingSearch() throws {
		// given
		let service = FakeSearchService()
		let viewModel = HomeViewModel(locationService: service)
		
		// when
		let expectation = XCTestExpectation(description: "Typing...")
		var expectedText: String?
		service.searchedText
			.sink { text in
				expectedText = text
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.onAppear()
		viewModel.searchText = "New location"
		
		wait(for: [expectation], timeout: 0.3)

		// then
		XCTAssertEqual(expectedText, "New location")
	}

	func testLocationSearched() throws {
		// given
		let service = FakeSearchService()
		let viewModel = HomeViewModel(locationService: service)
		
		// when
		let expectation = XCTestExpectation(description: "Searching...")
		var expectedLocations: [Location]?
		viewModel.$locationsSearched
			.dropFirst()
			.sink { locations in
				expectedLocations = locations
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.onAppear()
		service.locations.send([location, location, location])
		
		wait(for: [expectation], timeout: 1)

		// then
		XCTAssertEqual(expectedLocations, [location, location, location])
	}
	
	func testEmptyLocationSearched() throws {
		// given
		let service = FakeSearchService()
		let viewModel = HomeViewModel(locationService: service)
		
		// when
		let expectation = XCTestExpectation(description: "Searching...")
		var expectedLocations: [Location]?
		viewModel.$locationsSearched
			.dropFirst()
			.sink { locations in
				expectedLocations = locations
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.onAppear()
		service.locations.send([])
		
		wait(for: [expectation], timeout: 1)

		// then
		XCTAssertEqual(expectedLocations, [])
	}
	
	// MARK: - Tap
	func testTapLocation() throws {
		// given
		let service = FakeSearchService()
		let viewModel = HomeViewModel(locationService: service)
		
		// when
		let expectation = XCTestExpectation(description: "Tapping...")
		var expectedLocation: Location?
		viewModel.$locationTapped
			.sink { location in
				expectedLocation = location
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.onAppear()
		viewModel.onTap(location: location)
		
		wait(for: [expectation], timeout: 0.3)

		// then
		XCTAssertEqual(expectedLocation, location)
	}
}
