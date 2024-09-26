//
// Created by Joao Pedro Franco on 24/09/24
//

import Foundation

/// Represents the alert response.
///
/// The important information includes the headline and instructions.
public struct Warning: Hashable {
	public let headline: String
	public let instruction: String
	
	public init(headline: String, instruction: String) {
		self.headline = headline
		self.instruction = instruction
	}
}

extension Warning: Decodable {}
