//
//  Created by Joao Pedro Franco on 23/09/24.
//

import SwiftUI
import JUI
import JData

/// Represents the view that displays the current weather and any warnings for a specific location.
struct ForecastInnerView: View {
	let locationName: String
	let weather: Weather
	let warnings: [Warning]
	
	private let backgroundColor: Color = DesignSystem.Colors.background
	private let foregroundColor: Color = DesignSystem.Colors.dark
	
	var body: some View {
		VStack {
			header()
			
			ScrollView(showsIndicators: false) {
				VStack {
					cellBoxView(
						title: "Feels like",
						value: weather.temperature.feelsLike.asTemperature
					)
					
					cellBoxView(
						title: "Wind",
						value: "\(weather.wind.degrees.asDegrees), \(weather.wind.speed.asSpeed)"
					)
					
					if let rain = weather.rainPrecipitation {
						cellBoxView(
							title: "Rain",
							value: rain.asRainPrecipitation
						)
					}
					
					if let snow = weather.snowPrecipitation {
						cellBoxView(
							title: "Snow",
							value: snow.asSnowPrecipitation
						)
					}
					
					ForEach(warnings, id: \.self) {
						WarningBox(
							headline: $0.headline,
							message: $0.instruction
						)
					}
				}
			}
			.padding(.top, DesignSystem.Spacings.xs)
			
			Spacer()
		}
		.padding(DesignSystem.Spacings.xs)
		.background(backgroundColor)
	}
}

// MARK: - Components
private extension ForecastInnerView {
	@ViewBuilder
	func header() -> some View {
		VStack(spacing: .zero) {
			HStack(alignment: .center, spacing: .zero) {
				if let url = weather.condition.iconUrl {
					CachedImage(image: .remote(url))
						.frame(width: 48, height: 48, alignment: .center)
				}
				
				Text(locationName)
					.font(DesignSystem.Fonts.title)
					.foregroundColor(foregroundColor)
			}
			
			Text(weather.temperature.value.asTemperature)
				.font(DesignSystem.Fonts.huge)
				.foregroundColor(foregroundColor)
			
			Text(weather.condition.label)
				.font(DesignSystem.Fonts.default)
				.foregroundColor(foregroundColor)
			
			minMaxView()
		}
	}
	
	@ViewBuilder
	func minMaxView() -> some View {
		if let min = weather.temperature.min, let max = weather.temperature.max {
			HStack {
				Text(min.asTemperature)
					.font(DesignSystem.Fonts.default)
					.foregroundColor(foregroundColor)
				Text("|")
					.font(DesignSystem.Fonts.default)
					.foregroundColor(foregroundColor)
				Text(max.asTemperature)
					.font(DesignSystem.Fonts.default)
					.foregroundColor(foregroundColor)
			}
		}
	}
	
	@ViewBuilder
	func cellBoxView(title: String, value: String) -> some View {
		Box(
			title: title,
			value: value,
			backgroundColor: foregroundColor,
			foregroundColor: backgroundColor
		)
	}
}

struct ForecastInnerView_Previews: PreviewProvider {
	static let location = "Amsterdam"
	
	static var previews: some View {
		Group {
			ForEach([
				PreviewForecastInnerView.forecast(numberOfWarnings: 1),
				PreviewForecastInnerView.forecast(numberOfWarnings: 1),
				PreviewForecastInnerView.forecast(numberOfWarnings: 2)
			], id: \.self) {
				ForecastInnerView(
					locationName: location,
					weather: $0.current,
					warnings: $0.warnings
				)
			}
		}
	}
}
