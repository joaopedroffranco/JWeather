//
// Created by Joao Pedro Franco on 25/09/24
//

import Foundation
import JData

/// Stub implemention for test purposes.
enum ForecastStub {
	static let regular: Forecast = .init(
		id: 100,
			current: .init(
				temperature: .init(value: 17.3, feelsLike: 16.3, min: 13, max: 15.8),
				wind: .init(degrees: 181, speed: 8.3),
				condition: .init(iconUrl: URL(string: "https://image.png")!, label: "Light rain"),
				rainPrecipitation: 0.79,
				snowPrecipitation: 0.12
			),
			warnings: [
				.init(
					headline: "Flood Warning issued",
					instruction: "A Flood Warning means"
				)
			]
	)
}
