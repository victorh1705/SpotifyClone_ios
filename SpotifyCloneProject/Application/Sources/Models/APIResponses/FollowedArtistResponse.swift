//
//  FollowedUserArtistResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/20/21.
//

import Foundation


/// # Used in
/// - `MyLibraryScreen`
public struct FollowedArtistResponse: Decodable {
  public let artists: ArtistResponseItem

  public struct ArtistResponseItem: Decodable {
    public let items: [Artist]
  }
}
