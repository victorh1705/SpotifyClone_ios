//
//  EpisodeResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/2/21.
//

import Foundation
import Models

struct EpisodeResponse: Decodable {
  let items: [Episode]
}
