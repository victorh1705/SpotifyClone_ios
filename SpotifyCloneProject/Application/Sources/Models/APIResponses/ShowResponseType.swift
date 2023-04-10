//
//  ShowResponseType.swift
//  SpotifyClone
//
//  Created by Gabriel on 9/24/21.
//

import Foundation


/// # Used in
/// - `Top podcasts`
public struct ShowResponse: Decodable {
  public let shows: ShowItem
}
public struct ShowItem: Decodable {
  public let items: [Show]
}
