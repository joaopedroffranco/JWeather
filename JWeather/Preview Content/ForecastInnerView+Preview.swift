//
// Created by Joao Pedro Franco on 25/09/24
//


import Foundation
import JData

/// This structure provides stub data to keep the Preview code clean and manageable.
struct PreviewForecastInnerView {
	private static func condition() -> Condition {
		.init(iconUrl: URL(string: "https://cdn.weatherapi.com/weather/64x64/day/296.png")!, label: "sunny")
	}
	
	private static func weather() -> Weather {
		Weather(
			temperature: .init(value: 18, feelsLike: 16, min: 12, max: 20),
			wind: .init(degrees: 140, speed: 50),
			condition: condition(),
			rainPrecipitation: 15.2,
			snowPrecipitation: 1.25
		)
	}
	
	private static let warning: Warning = {
		.init(
			headline: "Flood Warning issued January 05 at 9:47PM EST until January 07 at 6:15AM EST by NWS",
			instruction: "A Flood Warning means that flooding is imminent or occurring. All\ninterested parties should take necessary precautions immediately.\nMotorists should not attempt to drive around barricades or drive\ncars through flooded areas.\nCaution is urged when walking near riverbanks.\nAdditional information is available at www.weather.gov.\nThe next statement will be issued Wednesday morning at 1000 AM EST."
		)
	}()
	
	static func forecast(numberOfWarnings: Int) -> Forecast {
		Forecast(
			id: 1,
			current: weather(),
			warnings: numberOfWarnings > 0 ? (1...numberOfWarnings).map { _ in warning } : []
		)
	}
}
