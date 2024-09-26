//
//  Created by João Pedro Fabiano Franco on 07.09.23.
//

import Foundation
import Combine

/// Protocol for creating a Data Source.
///
/// A Data Source represents a source of `Decodable` data, which can be either cached or retrieved from a remote API.
/// This allows service layers to utilize instances of data sources to fetch data.
///
/// See `RemoteDataSource` for an implementation example.
/// In the future, a `CacheDataSource` can be implemented to retrieve cached data before fetching from remote sources.
public protocol DataSourceProtocol: AnyObject {
  func fetch<T: Decodable>(request: Requestable) -> AnyPublisher<T, Error>
}
