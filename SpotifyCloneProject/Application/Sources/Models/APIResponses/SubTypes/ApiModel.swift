//
//  GeneralTypes.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation

/// ## **None of those will be used directly to show UI, they're used by SpotifyModel to then show UI.**

public struct Track: Decodable {
  public var name: String
  public var preview_url: String?
  public var album: Album?
  public var artists: [Artist]
  public var type: String
  public var id: String

  public var popularity: Int?
  public var explicit: Bool
  public var duration_ms: Double
}

public struct Album: Decodable {
  public var name: String
  public var images: [CoverImage]?
  public var album_type: String
  public var artists: [Artist]
  public var id: String

  public var total_tracks: Int
  public var release_date: String // yyyy-MM-dd
}

public struct Show: Decodable {
  public var name: String
  public var publisher: String
  public var images: [CoverImage]
  public var type: String
  public var id: String

  public var description: String
  public var explicit: Bool
  public var total_episodes: Int
}

public struct Artist: Decodable {
  public init(name: String, images: [CoverImage]? = nil, id: String) {
    self.name = name
    self.images = images
    self.id = id
    self.followers = nil
    self.genres = nil
    self.popularity = nil
  }
  
  public var name: String
  public var images: [CoverImage]?
  public var id: String

  public var followers: Followers?
  public var genres: [String]?
  public var popularity: Int?
}

public struct Playlist: Decodable {
  public var name: String
  public var images: [CoverImage]
  public var id: String

  public var description: String
  public var tracks: TracksInfo
  public var owner: MediaOwner
}

public struct Episode: Decodable {
  public var name: String
  public var images: [CoverImage]
  public var audio_preview_url: String
  public var type: String
  public var id: String

  public var description: String
  public var explicit: Bool
  public var duration_ms: Double
  public var release_date: String
}

public struct CoverImage: Decodable {
  public var url: String
}

public struct TracksInfo: Decodable {
  public var total: Int
  public var href: String // Can't use id because some responses only return href
}

public struct MediaOwner: Decodable {
  public var display_name: String
  public var id: String
}

public struct Followers: Decodable {
  public var total: Int
}
