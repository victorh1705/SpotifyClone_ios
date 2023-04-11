//
//  SavedEpisodeResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/24/21.
//

import Foundation

public struct SavedEpisodeResponse: Decodable {
  public let items: [SavedEpisodeItem]
  
  public struct SavedEpisodeItem: Decodable {
    public let episode: Episode
  }
}
