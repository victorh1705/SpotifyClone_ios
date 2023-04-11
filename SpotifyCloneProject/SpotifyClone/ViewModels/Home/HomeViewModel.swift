//
//  HomeViewModel.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

// Because of API constraints, we can't have scrolls that fetch data progressively in all sections.
// Sections that support that: Top Podcasts, New Releases, Playlist This is X

import SwiftUI
import Models

class HomeViewModel: ObservableObject {
  private var api = HomePageAPICalls()
  private(set) var mainVM: MainViewModel
  @Published private(set) var isLoading = [Section: Bool]()
  @Published private(set) var mediaCollection = [Section: [SpotifyModel.MediaItem]]()
  @Published private(set) var numberOfLoadedItemsInSection = [Section: Int]()
  @Published var currentSubPage: HomeSubpage = .none
  // Subpage navigation history
  @Published private(set) var pageHistory = [(subPage: HomeSubpage, data: SpotifyModel.MediaItem, mediaDetailVM: MediaDetailViewModel)]()
  // This is the first image(the one on top of the scroll view) used to get the average color and to create the gradient background
  @Published private(set) var imageColorModel = RemoteImageModel(urlString: "")

  // The data from the item the user just tapped(if an item was tapped).
  private var tappedItemData: SpotifyModel.MediaItem?
  // This ins't the cache. It's just an auxiliary variable used for cleaning cache when needed.
  var homeCachedImageURLs = [String]()

  enum HomeSubpage {
    case none
    case transitionScreen

    case playlistDetail
    case trackDetail
    case albumDetail
    case showDetail
    case artistDetail
    case episodeDetail
  }

  init(mainViewModel: MainViewModel) {
    self.mainVM = mainViewModel
    // Populate isLoading and medias with all possible section keys
    for section in Section.allCases {
      isLoading[section] = true
      mediaCollection[section] = []
      numberOfLoadedItemsInSection[section] = 0
    }

    fetchHomeData()
  }

  enum Section: String, CaseIterable {
    case smallSongCards = "Small Song Card Items"
    case userFavoriteTracks = "Songs You Love"
    case userFavoriteArtists = "Your Artists"
    case recentlyPlayed = "Recently Played"
    case newReleases = "New Releases"
    case topPodcasts = "Top Podcasts"
    case artistTopTracks = "Artist Top Tracks"
    case featuredPlaylists = "Featured Playlists"
    case playlistThisIsX = "This Is..."
    case playlistRewind90s = "Rewind to the 90s"
    case playlistRewind80s = "Rewind the 80s"
    case playlistRewind70s = "Rewind the 70s"
    case playlistRewind2000s = "2000s Rewind"
    case playlistRewind2010s = "2010s Rewind"
  }

  func fetchHomeData() {
    for dictKey in isLoading.keys { isLoading[dictKey] = true }

    if mainVM.authKey != nil {
      let accessToken = mainVM.authKey!.accessToken

      fetchDataFor(.smallSongCards, with: accessToken)
      fetchDataFor(.newReleases, with: accessToken)
      fetchDataFor(.topPodcasts, with: accessToken)
      fetchDataFor(.recentlyPlayed, with: accessToken)
      fetchDataFor(.userFavoriteTracks, with: accessToken)
      fetchDataFor(.userFavoriteArtists, with: accessToken)
      fetchDataFor(.featuredPlaylists, with: accessToken)
      fetchDataFor(.playlistThisIsX, with: accessToken)
      fetchDataFor(.artistTopTracks, with: accessToken)
      fetchDataFor(.playlistRewind70s, with: accessToken)
      fetchDataFor(.playlistRewind80s, with: accessToken)
      fetchDataFor(.playlistRewind90s, with: accessToken)
      fetchDataFor(.playlistRewind2000s, with: accessToken)
      fetchDataFor(.playlistRewind2010s, with: accessToken)
    }
  }

  // MARK: - Fetch Data From API

  func fetchDataFor(_ section: Section, with accessToken: String) {
    let numberOfItemsInEachLoad = 10
    let currentNumberOfLoadedItems = getNumberOfLoadedItems(for: section)
    increaseNumberOfLoadedItems(for: section, by: numberOfItemsInEachLoad)

    guard numberOfLoadedItemsInSection[section]! <= 50 else {
      return
    }

    DispatchQueue.main.async { [unowned self] in
      switch section {

      // MARK: - Track Responses

      // MARK: Small Song Card Items
      case .smallSongCards:
        api.getTrack(using: .userFavoriteTracks, with: accessToken) { tracks in

          if tracks.isEmpty {
            // If userFavoriteTracks returns empty, fetch tracks from Spotify's today top hits playlist.
            // Otherwise, the home screen UI won't look good.
            let todayHitsPlaylistID = "37i9dQZF1DXcBWIGoYBM5M"
            api.getTrack(using: .tracksFromPlaylist(playlistID: todayHitsPlaylistID), with: accessToken) { topTracks in
              trimAndCommunicateResult(section: section, medias: topTracks)
              setImageColorModelBasedOn(topTracks[0].imageURL)
            }

          } else {
            trimAndCommunicateResult(section: section, medias: tracks)
            setImageColorModelBasedOn(tracks[0].imageURL)
          }
        }

      // MARK: Recently Played
      case .recentlyPlayed:
        api.getTrack(using: .userRecentlyPlayed, with: accessToken) { tracks in
          trimAndCommunicateResult(section: section, medias: tracks)
        }

      // MARK: User Favorite Tracks
      case .userFavoriteTracks:
        api.getTrack(using: .userFavoriteTracks, with: accessToken,
                     limit: numberOfItemsInEachLoad, offset: currentNumberOfLoadedItems) { tracks in
          trimAndCommunicateResult(section: section, medias: tracks, loadMoreEnabled: true)
        }

      // MARK: - Artist Responses

      // MARK: User Favorite Artists
      case .userFavoriteArtists:
        api.getArtist(using: .userFavoriteArtists, with: accessToken) { artists in
          trimAndCommunicateResult(section: section, medias: artists)
        }

      // MARK: New Releases
      case .newReleases:
        api.getAlbum(using: .newReleases, with: accessToken, limit: numberOfItemsInEachLoad,
                     offset: currentNumberOfLoadedItems) { albums in
          trimAndCommunicateResult(section: section, medias: albums, loadMoreEnabled: true)
        }

      // MARK: Top Podcasts
      case .topPodcasts:
        api.getShow(using: .topPodcasts, with: accessToken, limit: numberOfItemsInEachLoad,
                    offset: currentNumberOfLoadedItems) { podcasts in
          trimAndCommunicateResult(section: section, medias: podcasts, loadMoreEnabled: true)
        }

      // MARK: Featured Playlists
      case .featuredPlaylists:
        api.getPlaylist(using: .featuredPlaylists, with: accessToken, limit: 20) { playlists in
          trimAndCommunicateResult(section: section, medias: playlists)
        }

      // MARK: Playlist This is X
      case .playlistThisIsX:
        let keyWord = "this is"
        api.getPlaylist(using: .playlistWithKeyword(keyWord: keyWord), with: accessToken,
                        limit: numberOfItemsInEachLoad, offset: currentNumberOfLoadedItems) { playlists in
          trimAndCommunicateResult(section: section, medias: playlists, loadMoreEnabled: true)
        }

      // MARK: Playlist Year Rewinds
      case .playlistRewind2010s, .playlistRewind2000s, .playlistRewind90s,
           .playlistRewind80s, .playlistRewind70s :

        var keyWord = "top hits of "
        switch section {
        case .playlistRewind2010s:
          keyWord += "201_"
        case .playlistRewind2000s:
          keyWord += "200_"
        case .playlistRewind90s:
          keyWord += "199_"
        case .playlistRewind80s:
          keyWord += "198_"
        case .playlistRewind70s:
          keyWord += "197_"
        default:
          fatalError("Year not defined or the section is not a year.")
        }

        api.getPlaylist(using: .playlistWithKeyword(keyWord: keyWord), with: accessToken) { playlists in
          trimAndCommunicateResult(section: section, medias: playlists)
        }

      // MARK: Artist's Top Tracks
      case .artistTopTracks:
        var artistID = ""
        // Get the user's most favorite artist
        api.getArtist(using: .userFavoriteArtists, with: accessToken) { artists in
          if artists.isEmpty == false {
            let userMostFavoriteArtist = artists[0]
            artistID = userMostFavoriteArtist.id
            mediaCollection[section]!.insert(artists[0], at: 0)

            // Add the artist's top songs
            api.getTrack(using: .topTracksFromArtist(artistID: artistID), with: accessToken) { tracks in
              trimAndCommunicateResult(section: section, medias: tracks, loadMoreEnabled: true)
            }
          } else {
            trimAndCommunicateResult(section: section, medias: [SpotifyModel.MediaItem]())
          }
        }
      default:
        fatalError("Tried to fetch data for a type not specified in the function declaration(fetchDataFor).")

      }
    }
  }

  // MARK: - Auxiliary Functions

  private func getNumberOfLoadedItems(for section: Section) -> Int {
    return numberOfLoadedItemsInSection[section]!
  }

  private func increaseNumberOfLoadedItems(for section: Section, by amount: Int) {
    if numberOfLoadedItemsInSection[section]! <= 50 {
      numberOfLoadedItemsInSection[section]! += amount
    }
  }

  private func trimAndCommunicateResult(section: Section, medias: [SpotifyModel.MediaItem],
                                        loadMoreEnabled: Bool = false) {
    var noDuplicateMedias = [SpotifyModel.MediaItem]()
    var mediaIDs = [String]()

    for media in medias {
      if !mediaIDs.contains(media.id) {
        mediaIDs.append(media.id)
        noDuplicateMedias.append(media)
      }
    }

    if loadMoreEnabled {
      mediaCollection[section]! += noDuplicateMedias
    } else {
      mediaCollection[section] = noDuplicateMedias
    }

    isLoading[section] = false
  }

  // MARK: - Non-api Related Functions

  func goToNoneSubpage() {
    pageHistory.removeAll()
    currentSubPage = .none
  }

  func goToPreviousPage() {

    // removes the current page
    pageHistory.removeLast()

    if pageHistory.isEmpty == false {
      changeSubpageTo(pageHistory.last!.subPage,
                      mediaDetailVM: pageHistory.last!.mediaDetailVM,
                      withData: pageHistory.last!.data)

      // removes the page that we just returned to
      pageHistory.removeLast()

    } else {
      goToNoneSubpage()
    }

  }

  func changeSubpageTo(_ subPage: HomeSubpage,
                       mediaDetailVM: MediaDetailViewModel,
                       withData data: SpotifyModel.MediaItem) {

    tappedItemData = data
    deleteAllImagesFromCache()

    pageHistory.append((subPage: subPage, data: data, mediaDetailVM: mediaDetailVM))

    currentSubPage = .transitionScreen

    // if we change the subpage right away it'll cause a crash
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      mediaDetailVM.cleanAll()
      mediaDetailVM.mainItem = data
      mediaDetailVM.accessToken = self.mainVM.authKey!.accessToken
      mediaDetailVM.setImageColorModelBasedOn(data.imageURL)
      self.currentSubPage = subPage
    }

  }

  func setImageColorModelBasedOn(_ firstImageURL: String) {
    imageColorModel = RemoteImageModel(urlString: firstImageURL)
  }

  // MARK: - Cache related functions

    func deleteImageFromCache() {

      // Delete from the auxiliary function so we won't keep counting a cached image that was already deleted.
      let imageURLThatWillBeDeleted = homeCachedImageURLs.removeFirst()

      guard tappedItemData == nil else {
        // if tappedItemData != nil, that means the user tapped some item. So for a better UX,
        // we shouldn't delete the image that the user just tapped from cache, therefore the
        // detail view of the tapped item will load smoothly.
        if tappedItemData!.imageURL != imageURLThatWillBeDeleted {
          ImageCache.deleteImageFromCache(imageURL: imageURLThatWillBeDeleted)
          self.objectWillChange.send()

        }
        return
      }

      ImageCache.deleteImageFromCache(imageURL: imageURLThatWillBeDeleted)
      self.objectWillChange.send()
    }

    private func deleteAllImagesFromCache() {
      // It's better to use this instead of .deleteAll() in 'ImageCache' right away, otherwise the item that
      // the user just tapped(in case he tapped) will also be deleted causing a non-pleasant user experience.
      for _ in homeCachedImageURLs.indices {
        deleteImageFromCache()
      }
    }

}
