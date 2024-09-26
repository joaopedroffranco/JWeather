//
//  Created by Joao Pedro Franco on 16/07/24.
//

import Foundation

/// Represents the root of the API response.
///
/// Additional metadata, such as daily or hourly weather, can be added here in the future.
public struct Forecast: Hashable {
	/// A simple identifier that conforms to `Hashable`.
	public let id: Int
	
	/// The current `Weather` information.
	public let current: Weather
	
	/// The array of alerts.
	public let warnings: [Warning]
	
	public init(id: Int, current: Weather, warnings: [Warning] = []) {
		self.id = id
		self.current = current
		self.warnings = warnings
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

extension Forecast: Decodable {
	enum CodingKeys: String, CodingKey {
		case location
		case current
		case warnings = "alerts"
		case forecast

		enum LocationCodingKeys: String, CodingKey {
			case localtimeEpoch = "localtime_epoch"
		}
		
		enum ForecastCodingKeys: String, CodingKey {
			case forecastDay = "forecastday"
		}
		
		enum WarningCodingKeys: String, CodingKey {
			case warning = "alert"
		}
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		/// id
		let locationContainer = try container.nestedContainer(keyedBy: CodingKeys.LocationCodingKeys.self, forKey: .location)
		/// Utilizes the Unix location information, which is sensible and largely unique.
		id = try locationContainer.decode(Int.self, forKey: .localtimeEpoch)
		
		/// current
		var current = try container.decode(Weather.self, forKey: .current)

		/// Implements specific logic to retrieve the minimum and maximum temperatures.
		/// These values are not included in the `current` response but are available in the `forecast` in a nested response.
		let innerContainer = try container.nestedContainer(keyedBy: CodingKeys.ForecastCodingKeys.self, forKey: .forecast)
		let forecastDays = try innerContainer.decode([ForecastDay].self, forKey: .forecastDay)
		
		if let first = forecastDays.first {
			current.temperature.min = first.minTemperature
			current.temperature.max = first.maxTemperature
		}
		self.current = current

		/// alerts
		if let warningContainer = try? container.nestedContainer(keyedBy: CodingKeys.WarningCodingKeys.self, forKey: .warnings) {
			warnings = try warningContainer.decodeIfPresent([Warning].self, forKey: .warning) ?? []
		} else {
			warnings = []
		}
	}
}
