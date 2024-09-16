//
//  ANSIColors.swift
//  Helpers
//
//  Created by Dave Coleman on 20/8/2024.
//



public enum ANSIColors: String {
  case black = "\u{001B}[0;30m"
  case red = "\u{001B}[0;31m"
  case green = "\u{001B}[0;32m"
  case yellow = "\u{001B}[0;33m"
  case blue = "\u{001B}[0;34m"
  case magenta = "\u{001B}[0;35m"
  case cyan = "\u{001B}[0;36m"
  case white = "\u{001B}[0;37m"
  case reset = "\u{001B}[0;0m"
  
  case bgBlack = "\u{001B}[40m"
  case bgRed = "\u{001B}[41m"
  case bgGreen = "\u{001B}[42m"
  case bgYellow = "\u{001B}[43m"
  case bgBlue = "\u{001B}[44m"
  case bgMagenta = "\u{001B}[45m"
  case bgCyan = "\u{001B}[46m"
  case bgWhite = "\u{001B}[47m"
  
  case bold = "\u{001B}[1m"
  case underline = "\u{001B}[4m"
}
