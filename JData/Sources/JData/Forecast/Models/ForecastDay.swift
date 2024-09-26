//
// Created by Joao Pedro Franco on 25/09/24
//

import Foundation

/// A simple internal struct to assist in retrieving the minimum and maximum temperatures.
///
/// This struct is used to extract these values from a nested container within the root response.
struct ForecastDay {
	let minTemperature: Double
	let maxTemperature: Double
}

extension ForecastDay: Decodable {
	enum CodingKeys: String, CodingKey {
		case day
		
		enum TempCodingKeys: String, CodingKey {
			case minTemperature = "mintemp_c"
			case maxTemperature = "maxtemp_c"
		}
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dayContainer = try container.nestedContainer(keyedBy: CodingKeys.TempCodingKeys.self, forKey: .day)
		
		minTemperature = try dayContainer.decode(Double.self, forKey: .minTemperature)
		maxTemperature = try dayContainer.decode(Double.self, forKey: .maxTemperature)
	}
}
