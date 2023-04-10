//
//  CurrentUserInfoResponse.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/13/21.
//

import Foundation


public class CurrentUserInfoResponse: Decodable {
  public let display_name: String
  public let followers: Followers
  public let id: String
  public let images: [CoverImage]?
}
