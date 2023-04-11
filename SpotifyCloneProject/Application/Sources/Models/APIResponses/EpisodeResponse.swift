//
//  EpisodeResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/2/21.
//

import Foundation

public struct EpisodeResponse: Decodable {
  public let items: [Episode]
}
