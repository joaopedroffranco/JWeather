//
//  Created by Joao Pedro Franco on 16/07/24.
//

import Foundation

/// Wraps the wind metadata.
public struct Wind: Equatable {
	public let degrees: Int
	public let speed: Double
	
	public init(degrees: Int, speed: Double) {
		self.degrees = degrees
		self.speed = speed
	}
}

/// Wraps the temperature metadata.
///
/// The minimum and maximum temperatures are optional, as they are injected from the root response.
public struct Temperature: Equatable {
	public let value: Double
	public let feelsLike: Double
	public var min: Double?
	public var max: Double?
	
	public init(value: Double, feelsLike: Double, min: Double? = nil, max: Double? = nil) {
		self.value = value
		self.feelsLike = feelsLike
		self.min = min
		self.max = max
	}
}

/// Represents metadata related to weather information.
///
/// Additional metadata, such as visibility, pressure, and more, to enhance the weather information.
public struct Weather: Equatable {
	public var temperature: Temperature
	public let wind: Wind
	public let condition: Condition
	public let rainPrecipitation: Double?
	public let snowPrecipitation: Double?
	
	public init(
		temperature: Temperature,
		wind: Wind,
		condition: Condition,
		rainPrecipitation: Double?,
		snowPrecipitation: Double?
	) {
		self.temperature = temperature
		self.wind = wind
		self.condition = condition
		self.rainPrecipitation = rainPrecipitation
		self.snowPrecipitation = snowPrecipitation
	}
}

extension Weather: Decodable {
	enum CodingKeys: String, CodingKey {
		case temperature = "temp_c"
		case feelsLike = "feelslike_c"
		case condition
		case windSpeed = "wind_kph"
		case windDegrees = "wind_degree"
		case rainPrecipitation = "precip_mm"
		case snowPrecipitation = "snow_cm"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		let value = try container.decode(Double.self, forKey: .temperature)
		let feelsLike = try container.decode(Double.self, forKey: .feelsLike)
		temperature = Temperature(value: value, feelsLike: feelsLike)
		
		let windSpeed = try container.decode(Double.self, forKey: .windSpeed)
		let windDegrees = try container.decode(Int.self, forKey: .windDegrees)
		wind = Wind(degrees: windDegrees, speed: windSpeed)
		condition = try container.decode(Condition.self, forKey: .condition)
		rainPrecipitation = try container.decodeIfPresent(Double.self, forKey: .rainPrecipitation)
		snowPrecipitation = try container.decodeIfPresent(Double.self, forKey: .snowPrecipitation)
	}
}
