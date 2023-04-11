//
//  SpotifyMediaContent.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/6/21.
//

import SwiftUI

public struct SpotifyMediaContent {
  public let title: String
  public let author: String
  public let imageURL: String
  public var isPodcast: Bool = false
  public var isArtist: Bool = false

  public init(title: String,
       author: String,
       imageURL: String,
       isPodcast: Bool = false,
       isArtist: Bool = false) {
    self.title = title
    self.author = author
    self.imageURL = imageURL
    self.isPodcast = isPodcast
    self.isArtist = isArtist
  }
}
