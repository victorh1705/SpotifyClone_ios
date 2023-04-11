//
//  SearchEndpointResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/8/21.
//

import Foundation


/// # Used in any response from the Search endpoint of the API
public struct SearchEndpointResponse: Decodable {
  public let tracks: TrackSearchResponse?
  public let playlists: PlaylistSearchResponse?
  public let albums: AlbumSearchResponse?
  public let shows: ShowSearchResponse?
  public let artists: ArtistSearchResponse?
  public let episodes: EpisodesSearchResponse?

  public struct TrackSearchResponse: Decodable {
    public let items: [Track]
  }

  public struct PlaylistSearchResponse: Decodable {
    public let items: [Playlist]
  }

  public struct AlbumSearchResponse: Decodable {
    public let items: [Album]
  }

  public struct ShowSearchResponse: Decodable {
    public let items: [Show]
  }

  public struct ArtistSearchResponse: Decodable {
    public let items: [Artist]
  }

  public struct EpisodesSearchResponse: Decodable {
    public let items: [Episode]
  }
}
