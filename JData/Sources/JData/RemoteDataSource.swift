//
//  Created by João Pedro Fabiano Franco on 07.09.23.
//

import Foundation
import Combine

/// A typealias for simplifying the `AnyPublisher` type while wrapping the `Error` type.
public typealias RemotePublisher<T: Decodable> = AnyPublisher<T, Error>

/// Possible errors for a remote data source.
public enum RemoteDataSourceError: Error {
  case invalidRequest
  case decodeError
  case requestFailed
}

/// Conforms to `DataSourceProtocol` and wraps the native `URLSession` for data fetching.
///
/// This implementation uses `Combine` to align with the app's reactive approach.
public class RemoteDataSource: DataSourceProtocol {
  let session: URLSession

	/// It utilizes the common `.shared` session, but allows for dependency injection of a custom session for testing purposes.
  public init(session: URLSession = .shared) {
    self.session = session
  }
	
	/// Fetches data based on a given `Requestable` and decodes it into a `Decodable` type.
	///
	/// - Parameter request: An instance conforming to `Requestable`.
	/// - Returns: A `RemotePublisher` that publishes the decoded `Decodable` data.
	public func fetch<T>(request: Requestable) -> RemotePublisher<T> where T : Decodable {
		guard let request = request.request else {
			return Fail(error: RemoteDataSourceError.invalidRequest).eraseToAnyPublisher()
		}

		return session.dataTaskPublisher(for: request)
			.map { $0.data }
			.decode(type: T.self, decoder: JSONDecoder())
			.mapError { _ in RemoteDataSourceError.decodeError }
			.eraseToAnyPublisher()
	}
}
