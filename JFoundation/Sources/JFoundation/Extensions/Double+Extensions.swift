//
// Created by Joao Pedro Franco on 25/09/24
//
	
import Foundation

public extension Double {
	
	/// Formats a given `Double` object into a temperature string format in Celsius. It rounds to an `Int` and append the unit.
	var asTemperature: String { "\(Int(rounded()))º" }
	
	/// Formats a given `Double` object into a speed string format in km / h.
	var asSpeed: String { "\(self) km/h" }
	
	/// Formats a given `Double` object into a rain precipitation string format in mm.
	var asRainPrecipitation: String { "\(self) mm" }
	
	/// Formats a given `Double` object into a snow precipitation string format in cm.
	var asSnowPrecipitation: String { "\(self) cm" }
}
