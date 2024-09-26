//
// Created by Joao Pedro Franco on 24/09/24
//

import Foundation
import CoreLocation

/// Represents a location that can be searched.
///
/// This structure is `Hashable` and `Identifiable`, making it suitable for use in lists and sheet presentations.
struct Location: Identifiable, Hashable {
	let id = UUID().uuidString
	let name: String
	let country: String
	let coordinate: CLLocationCoordinate2D
	
	static func == (lhs: Location, rhs: Location) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
