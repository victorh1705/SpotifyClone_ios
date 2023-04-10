//
//  SpotifyModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import Foundation

public struct SpotifyModel {

  public struct CurrentUserProfileInfo {
    public init(displayName: String, followers: Int, imageURL: String, id: String) {
      self.displayName = displayName
      self.followers = followers
      self.imageURL = imageURL
      self.id = id
    }

    public let displayName: String
    public let followers: Int
    public let imageURL: String
    public let id: String
  }

  public enum MediaTypes {
    case track
    case album
    case playlist
    case show
    case artist
    case episode
  }

  // This public struct will be modified
  public struct PlaylistItem: Identifiable {
    public init(sectionTitle: String, name: String, imageURL: String, id: String) {
      self.sectionTitle = sectionTitle
      self.name = name
      self.imageURL = imageURL
      self.id = id
    }

    public var sectionTitle: String
    public var name: String
    public var imageURL: String
    public var id: String
  }

  public struct MediaItem: Identifiable {
    public var title: String
    public var previewURL: String
    public var imageURL: String
    public var lowResImageURL: String?
    public var authorName: [String]
    public var author: [Artist]?
    public var mediaType: MediaTypes
    public var id: String
    public var details: DetailTypes

    public init(title: String, previewURL: String, imageURL: String, lowResImageURL: String? = nil, authorName: [String], author: [Artist]? = nil, mediaType: SpotifyModel.MediaTypes, id: String, details: SpotifyModel.DetailTypes) {
      self.title = title
      self.previewURL = previewURL
      self.imageURL = imageURL
      self.lowResImageURL = lowResImageURL
      self.authorName = authorName
      self.author = author
      self.mediaType = mediaType
      self.id = id
      self.details = details
    }

    fileprivate func getDetails() -> DetailTypes {
      switch details {
      case .playlists(let playlistDetails):
        return DetailTypes.playlists(playlistDetails: playlistDetails)

      case .artists(let artistDetails):
        return DetailTypes.artists(artistDetails: artistDetails)

      case .shows(let showDetails):
        return DetailTypes.shows(showDetails: showDetails)

      case .tracks(let trackDetails):
        return DetailTypes.tracks(trackDetails: trackDetails)

      case .album(let albumDetails):
        return DetailTypes.album(albumDetails: albumDetails)

      case .episode(let episodeDetails):
        return DetailTypes.episode(episodeDetails: episodeDetails)
      }
    }

  }

  // MARK: - Detail public structs
  public enum DetailTypes {
    case shows(showDetails: ShowDetails)
    case tracks(trackDetails: TrackDetails)
    case playlists(playlistDetails: PlaylistDetails)
    case artists(artistDetails: ArtistDetails)
    case album(albumDetails: AlbumDetails)
    case episode(episodeDetails: EpisodeDetails)
  }

  public struct ShowDetails {
    public init(description: String, explicit: Bool, numberOfEpisodes: Int, id: String) {
      self.description = description
      self.explicit = explicit
      self.numberOfEpisodes = numberOfEpisodes
      self.id = id
    }

    public var description: String
    public var explicit: Bool
    public var numberOfEpisodes: Int
    public var id: String
  }

  public struct TrackDetails {
    public init(popularity: Int, explicit: Bool, description: String? = nil, durationInMs: Double, id: String, album: SpotifyModel.AlbumDetails? = nil) {
      self.popularity = popularity
      self.explicit = explicit
      self.description = description
      self.durationInMs = durationInMs
      self.id = id
      self.album = album
    }

    public var popularity: Int
    public var explicit: Bool
    public var description: String?
    public var durationInMs: Double
    public var id: String
    public var album: AlbumDetails?
  }

  public struct PlaylistDetails {
    public init(description: String, playlistTracks: SpotifyModel.PlaylistTracks, owner: SpotifyModel.MediaOwner, id: String) {
      self.description = description
      self.playlistTracks = playlistTracks
      self.owner = owner
      self.id = id
    }

    public var description: String
    public var playlistTracks: PlaylistTracks
    public var owner: MediaOwner
    public var id: String
  }

  public struct ArtistDetails {
    public var followers: Int
    public var genres: [String]
    public var popularity: Int
    public var id: String

    public init(followers: Int, genres: [String], popularity: Int, id: String) {
      self.followers = followers
      self.genres = genres
      self.popularity = popularity
      self.id = id
    }
  }

  public struct AlbumDetails {
    public init(name: String, numberOfTracks: Int, releaseDate: String, id: String) {
      self.name = name
      self.numberOfTracks = numberOfTracks
      self.releaseDate = releaseDate
      self.id = id
    }
    
    public var name: String
    public var numberOfTracks: Int
    public var releaseDate: String // yyyy-MM-dd
    public var id: String
  }

  public struct EpisodeDetails {
    public init(explicit: Bool, description: String? = nil, durationInMs: Double, releaseDate: String, id: String, showId: String? = nil) {
      self.explicit = explicit
      self.description = description
      self.durationInMs = durationInMs
      self.releaseDate = releaseDate
      self.id = id
      self.showId = showId
    }

    public var explicit: Bool
    public var description: String?
    public var durationInMs: Double
    public var releaseDate: String
    public var id: String
    public var showId: String?
  }

  // MARK: - Sub public structs
  public struct PlaylistTracks {
    public init(numberOfSongs: Int, href: String) {
      self.numberOfSongs = numberOfSongs
      self.href = href
    }

    public var numberOfSongs: Int
    public var href: String // Can't use id because some responses only return href
  }

  public struct MediaOwner {
    public init(displayName: String, id: String) {
      self.displayName = displayName
      self.id = id
    }

    public var displayName: String
    public var id: String
  }

  // MARK: - Auxiliary functions

  public static func getShowDetails(for mediaItem: MediaItem) -> ShowDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .shows(let showDetails):
      return SpotifyModel.ShowDetails(description: showDetails.description,
                                      explicit: showDetails.explicit,
                                      numberOfEpisodes: showDetails.numberOfEpisodes,
                                      id: showDetails.id)
    default:
      fatalError("Wrong type for `ShowDetails`")
    }
  }

  public static func getTrackDetails(for mediaItem: MediaItem) -> TrackDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .tracks(let trackDetails):
      return SpotifyModel.TrackDetails(popularity: trackDetails.popularity,
                                       explicit: trackDetails.explicit,
                                       durationInMs: trackDetails.durationInMs,
                                       id: trackDetails.id,
                                       album: trackDetails.album)
    default:
      fatalError("Wrong type for `TrackDetails`")
    }
  }

  public static func getPlaylistDetails(for mediaItem: MediaItem) -> PlaylistDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .playlists(let playlistDetails):
      return SpotifyModel.PlaylistDetails(description: playlistDetails.description,
                                          playlistTracks: playlistDetails.playlistTracks,
                                          owner: playlistDetails.owner,
                                          id: playlistDetails.id)
    default:
      fatalError("Wrong type for `PlaylistDetails`")
    }
  }

  public static func getArtistDetails(for mediaItem: MediaItem) -> ArtistDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .artists(let artistDetails):
      return SpotifyModel.ArtistDetails(followers: artistDetails.followers,
                                        genres: artistDetails.genres,
                                        popularity: artistDetails.popularity,
                                        id: artistDetails.id)
    default:
      fatalError("Wrong type for `ArtistDetails`")
    }
  }

  public static func getAlbumDetails(for mediaItem: MediaItem) -> AlbumDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .album(let albumDetails):
      return SpotifyModel.AlbumDetails(name: albumDetails.name,
                                       numberOfTracks: albumDetails.numberOfTracks,
                                       releaseDate: albumDetails.releaseDate,
                                       id: albumDetails.id)
    default:
      fatalError("Wrong type for `AlbumDetails`")
    }
  }

  public static func getEpisodeDetails(for mediaItem: MediaItem) -> EpisodeDetails {
    let detailsTypes = mediaItem.getDetails()
    switch detailsTypes {
    case .episode(let episodeDetails):
      return SpotifyModel.EpisodeDetails(explicit: episodeDetails.explicit,
                                         description: episodeDetails.description,
                                         durationInMs: episodeDetails.durationInMs,
                                         releaseDate: episodeDetails.releaseDate,
                                         id: episodeDetails.id)
    default:
      fatalError("Wrong type for `EpisodeDetails`")
    }
  }

}
