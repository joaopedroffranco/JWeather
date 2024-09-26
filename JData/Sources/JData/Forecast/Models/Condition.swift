//
// Created by Joao Pedro Franco on 24/09/24
//

import Foundation

/// Represents the weather condition, including a description and an associated icon.
///
/// This structure provides details about the current weather state and its visual representation.
public struct Condition: Equatable {
	public let label: String
	public let iconUrl: URL?
	
	public init(iconUrl: URL? = nil, label: String) {
		self.iconUrl = iconUrl
		self.label = label
	}
}

extension Condition: Decodable {
	enum CodingKeys: String, CodingKey {
		case icon
		case label = "text"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		label = try container.decode(String.self, forKey: .label)
		
		/// Already constructs the final URL to be loaded.
		let iconUrl = try container.decode(String.self, forKey: .icon)
		let urlString = "https:\(iconUrl)"
		guard let url = URL(string: urlString) else { self.iconUrl = nil; return  }
		self.iconUrl = url
	}
}
