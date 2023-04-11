//
//  AuthKey.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/13/21.
//

import Foundation

public struct AuthKey: Decodable {
  public var accessToken: String
  public var refreshToken: String
  public var scope: String

  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case scope
  }
}
