//
//  Easing Algorithms.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//

import Foundation

public enum EasingType {
    case linear
    case easeIn
    case easeOut
    case easeInOut
}
public func applyEasing(_ value: CGFloat, easing: EasingType) -> CGFloat {
    switch easing {
    case .linear:
        return value
    case .easeIn:
        return value * value * value
    case .easeOut:
        let f = value - 1.0
        return f * f * f + 1.0
    case .easeInOut:
        if value < 0.5 {
            return 4.0 * value * value * value
        } else {
            let f = (2.0 * value - 2.0)
            return 0.5 * f * f * f + 1.0
        }
    }
}

