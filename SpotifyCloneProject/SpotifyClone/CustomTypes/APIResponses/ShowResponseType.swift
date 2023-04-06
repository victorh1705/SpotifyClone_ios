//
//  ShowResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation
import Model

/// # Used in
/// - `Top podcasts`

struct ShowResponse: Decodable {
  let shows: ShowItem
}

struct ShowItem: Decodable {
  let items: [Show]
}
