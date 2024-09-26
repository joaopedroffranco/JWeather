//
//  Created by Joao Pedro Franco on 15/07/24.
//

import Combine

/// Protocol for creating a service to fetch `Forecast` data based on latitude and longitude.
public protocol ForecastServiceProtocol {
	func fetch(latitude: Double, longitude: Double) -> AnyPublisher<Forecast?, Never>
}

/// Conforms to `ForecastServiceProtocol`.
///
/// This implementation uses a `RemoteDataSource` to fetch forecast data.
/// In the future, a cached data source may be implemented to support offline functionality if needed.
public class ForecastService: ForecastServiceProtocol {
	var dataSource: DataSourceProtocol
	
	/// The remote is the default data source.
	public init(dataSource: DataSourceProtocol = RemoteDataSource()) {
		self.dataSource = dataSource
	}
	
	/// Wraps the data source fetch, replacing any errors with `nil` since they are not relevant for further layers.
	///
	/// - Parameters:
	///   - latitude: The latitude coordinate.
	///   - longitude: The longitude coordinate.
	/// - Returns: An `AnyPublisher` that publishes the decoded `Forecast?` data, without propagating errors.
	public func fetch(latitude: Double, longitude: Double) -> AnyPublisher<Forecast?, Never> {
		dataSource.fetch(request: ForecastRequest.fetch(latitude: latitude, longitude: longitude))
			.replaceError(with: nil)
			.eraseToAnyPublisher()
	}
}
