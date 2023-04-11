//
//  FollowedShowResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import Foundation

public struct FollowedShowResponse: Decodable {
  public let items: [FollowedShowItem]

  public struct FollowedShowItem: Decodable {
    public let show: Show
  }
}
