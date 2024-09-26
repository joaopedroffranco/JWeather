//
// Created by Joao Pedro Franco on 25/09/24
//

import Foundation

public extension Date {

	/// Formats a given `Date` object into a specified string format.
	var asString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM.yyyy"
		
		return formatter.string(from: self)
	}
}
