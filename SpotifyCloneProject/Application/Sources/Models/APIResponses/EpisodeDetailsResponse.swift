//
//  EpisodeDetailsResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/14/21.
//

import Foundation

public struct EpisodeDetailsResponse: Decodable {
  public let audio_preview_url: String
  public let description: String
  public let duration_ms: Double
  public let explicit: Bool
  public let id: String
  public let images: [CoverImage]
  public let name: String
  public let show: Show
  public let release_date: String
}
