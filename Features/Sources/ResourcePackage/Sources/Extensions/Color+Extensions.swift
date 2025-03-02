//
//  Color+Extensions.swift
//  Features
//
//  Created by Geonhee on 2/23/25.
//

import SwiftUI

extension Color {
  public init(hex: Int, alpha: Double = 1.0) {
    let red = Double((hex >> 16) & 0xFF) / 255.0
    let green = Double((hex >> 8) & 0xFF) / 255.0
    let blue = Double(hex & 0xFF) / 255.0
    self.init(red: red, green: green, blue: blue, opacity: alpha)
  }

  public init(hex: String, alpha: Double = 1.0) {
    var sanitizedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)

    if sanitizedHex.hasPrefix("#") {
      sanitizedHex.removeFirst()
    }

    guard
      sanitizedHex.count == 6,
      let hexValue = Int(sanitizedHex, radix: 16)
    else {
      self = .black
      return
    }

    self.init(hex: hexValue, alpha: alpha)
  }

  public init(hexString: String) {
    var sanitizedHex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)

    if sanitizedHex.hasPrefix("#") {
      sanitizedHex.removeFirst()
    }

    guard
      sanitizedHex.count == 6 || sanitizedHex.count == 8,
      let hexValue = Int(sanitizedHex, radix: 16)
    else {
      self = .black
      return
    }

    let hasAlpha = sanitizedHex.count == 8

    let red = Double((hexValue >> (hasAlpha ? 24 : 16)) & 0xFF) / 255.0
    let green = Double((hexValue >> (hasAlpha ? 16 : 8)) & 0xFF) / 255.0
    let blue = Double((hexValue >> (hasAlpha ? 8 : 0)) & 0xFF) / 255.0
    let alpha = hasAlpha ? Double(hexValue & 0xFF) / 255.0 : 1.0

    self.init(red: red, green: green, blue: blue, opacity: alpha)
  }
}
