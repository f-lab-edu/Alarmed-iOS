//
//  Color+Extensions.swift
//  Features
//
//  Created by Geonhee on 2/23/25.
//

import SwiftUI

extension Color {

  // MARK: Lifecycle

  public init(hexString: String) {
    guard
      let (hexValue, hasAlpha) = Self.parseHex(from: hexString)
    else {
      self = .black
      return
    }

    self.init(hex: hexValue, includesAlpha: hasAlpha)
  }

  private init(hex: Int, includesAlpha: Bool) {
    let red = Double((hex >> (includesAlpha ? Hex.alphaShift : Hex.redShift)) & Hex.componentMask) / Hex.colorNormalizationFactor
    let green = Double((hex >> (includesAlpha ? Hex.redShift : Hex.greenShift)) & Hex.componentMask) / Hex
      .colorNormalizationFactor
    let blue = Double((hex >> (includesAlpha ? Hex.greenShift : Hex.blueShift)) & Hex.componentMask) / Hex
      .colorNormalizationFactor
    let opacity = includesAlpha ? Double(hex & Hex.componentMask) / Hex.colorNormalizationFactor : Hex.maxAlpha

    self.init(red: red, green: green, blue: blue, opacity: opacity)
  }

  // MARK: Private

  private enum Hex {
    /// #RRGGBB
    static let rgbLength = 6
    /// #RRGGBBAA
    static let rgbaLength = 8
    static let colorPrefix = "#"

    static let redShift = 16
    static let greenShift = 8
    static let blueShift = 0
    static let alphaShift = 24
    static let componentMask = 0xFF
    static let colorNormalizationFactor = 255.0
    static let hexNumber = 16
    static let maxAlpha = 1.0
  }

  private static func parseHex(from hexString: String) -> (hex: Int, hasAlpha: Bool)? {
    var sanitizedHex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)

    if sanitizedHex.hasPrefix(Hex.colorPrefix) {
      sanitizedHex.removeFirst()
    }

    let hasAlpha = sanitizedHex.count == Hex.rgbaLength

    guard
      sanitizedHex.count == Hex.rgbLength || hasAlpha,
      let hexValue = Int(sanitizedHex, radix: Hex.hexNumber)
    else {
      return nil
    }

    return (hexValue, hasAlpha)
  }
}
