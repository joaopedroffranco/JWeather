//
// Created by Joao Pedro Franco on 25/09/24
//

import Combine
@testable import JData

/// A mock implementation of `ForecastServiceProtocol` that returns predefined `Forecast` data.
///
/// This fake data source is utilized in tests to simulate responses, enabling controlled and predictable outcomes for testing scenarios.
public class FakeForecastService: ForecastServiceProtocol {
	let forecast: Forecast?
	
	public init(forecast: Forecast?) {
		self.forecast = forecast
	}
	
	public func fetch(latitude: Double, longitude: Double) -> AnyPublisher<Forecast?, Never> {
		Just(forecast).eraseToAnyPublisher()
	}
}
