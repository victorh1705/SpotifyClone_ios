//
//  FilterableViewModelProtocol.swift
//  SpotifyClone
//
//  Created by Gabriel on 10/25/21.
//

import SwiftUI
import Models

protocol FilterableViewModelProtocol: ObservableObject {
  var selectedMediaTypeFilter: SpotifyModel.MediaTypes? { get set }
  var currentScrollPosition: CGFloat { get set }
}
