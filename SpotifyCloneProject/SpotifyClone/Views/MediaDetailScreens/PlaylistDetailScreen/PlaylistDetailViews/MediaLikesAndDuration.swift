//
//  MediaLikesAndDuration.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/25/21.
//

import SwiftUI
import Models
import Utils

struct MediaLikesAndDuration: View {
  var playlistTracks: SpotifyModel.PlaylistTracks

  var body: some View {
    Text("\(playlistTracks.numberOfSongs) songs")
      .opacity(Constants.opacityStandard)
  }
}
