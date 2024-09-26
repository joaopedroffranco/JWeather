//
//  Created by Joao Pedro Franco on 16/07/24.
//

import Foundation

/// Conforms to `Requestable`, representing the Forecast API.
///
/// This implementation represents the specifications of the Forecast API provided by [WeatherAPI](https://www.weatherapi.com/docs/).
enum ForecastRequest: Requestable {
	case fetch(latitude: Double, longitude: Double)

	var method: RequestMethod { .get }
	
	var host: String { "https://api.weatherapi.com/v1" }
	
	var endpoint: String { "/forecast.json" }
	
	var params: [String : String]? {
		var params = [
			"key": "7bb7ac18a4ec4cd2bfe152132242409",
		]
		
		switch self {
		case let .fetch(latitude, longitude):
			params["q"] = "\(latitude.description),\(longitude.description)"
			params["days"] = "1"
			params["alerts"] = "yes"
		}

		return params
	}
	
	var headers: [String : String]? { nil }
	
	var cachePolicy: URLRequest.CachePolicy { .reloadIgnoringLocalCacheData }
}
