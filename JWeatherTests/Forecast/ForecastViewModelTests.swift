//
// Created by Joao Pedro Franco on 25/09/24
//

import XCTest
import Combine
@testable import JWeather

/// Tests for the `ForecastViewModel`.
///
/// This test suite verifies that the view model correctly publishes the `Forecast` data based on the outcomes from the service.
class ForecastViewModelTests: XCTestCase {
	private let location = Location(
		name: "Test",
		country: "Mine",
		coordinate: .init(latitude: 12, longitude: 15)
	)

	private var cancellables: Set<AnyCancellable> = []
	
	func testRegularForecast() throws {
		// given
		let forecast = ForecastStub.regular
		let service = FakeForecastService(forecast: forecast)
		let viewModel = ForecastViewModel(for: location, service: service)
		
		// when
		let expectation = XCTestExpectation(description: "Loading...")
		var expetedState: ForecastViewState = .loading
		viewModel.$state
			.dropFirst()
			.sink { state in
				expetedState = state
				expectation.fulfill()
			}
			.store(in: &cancellables)

		XCTAssertEqual(expetedState, .loading)
		viewModel.load()
		
		wait(for: [expectation], timeout: 5)
		
		// then
		XCTAssertEqual(expetedState, .data(location, forecast))
	}
	
	func testNilForecast() throws {
		// given
		let service = FakeForecastService(forecast: nil)
		let viewModel = ForecastViewModel(for: location, service: service)
		
		// when
		let expectation = XCTestExpectation(description: "Loading...")
		var expetedState: ForecastViewState = .loading
		viewModel.$state
			.dropFirst()
			.sink { state in
				expetedState = state
				expectation.fulfill()
			}
			.store(in: &cancellables)

		XCTAssertEqual(expetedState, .loading)
		viewModel.load()

		wait(for: [expectation], timeout: 5)
		
		// then
		XCTAssertEqual(expetedState, .error(location.name))
	}
}
