//
//  File.swift
//
//
//  Created by Dave Coleman on 15/6/2024.
//

import Foundation
import SwiftUI

public struct FadeSlideIn: ViewModifier {
  let distance: Double
  let opacity: Double

  public func body(content: Content) -> some View {
    content
      .offset(x: 0, y: distance)
      .opacity(opacity)
  }
}

extension AnyTransition {
  public static var fadeSlideIn: AnyTransition {
    .modifier(
      active: FadeSlideIn(distance: 16, opacity: 0.0),
      identity: FadeSlideIn(distance: 0, opacity: 1.0)
    )
  }
  public static var fadeSlideOut: AnyTransition {
    .modifier(
      active: FadeSlideIn(distance: 0, opacity: 0.0),
      identity: FadeSlideIn(distance: 12, opacity: 1.0)
    )
  }

  public static var fadeSlide: AnyTransition {
    .asymmetric(
      insertion: .fadeSlideIn,
      removal: .fadeSlideOut
    )
  }
}


struct AnimationTest: Identifiable {
  let id = UUID()
  var type: AnimationType
  var duration: Double?
  var bounce: Double?
  var mass: Double?
  var stiffness: Double?
  var damping: Double?
}

enum AnimationType: String {
  case spring
  case interpolatingSpring
  case easeOut
}

struct AnimationExamples: View {

  @State private var animations: [AnimationTest] = [
    AnimationTest(
      type: .spring,
      duration: 0.5,
      bounce: 0.0,
      mass: 10,
      stiffness: 2,
      damping: 2
    ),
    AnimationTest(
      type: .interpolatingSpring,
      duration: 0.2,
      bounce: 0.9,
      mass: 10,
      stiffness: 2,
      damping: 2
    ),
  ]

  var body: some View {

    let columns: [GridItem] = [
      GridItem(.flexible()),
      GridItem(.flexible()),
    ]

    LazyVGrid(columns: columns, spacing: 32) {
      ForEach($animations, id: \.id) { $animation in
        SingleAnimationView(animationItem: $animation)
      }
    }


  }
}

@MainActor
struct SingleAnimationView: View {

  @Binding var animationItem: AnimationTest

  @State private var isAnimating: Bool = false
  @State private var animationTimer: Timer?

  var body: some View {

    var animation: Animation {
      switch animationItem.type {
        case .spring:
          return .spring(
            response: animationItem.duration ?? 0.5, dampingFraction: animationItem.bounce ?? 0.5)
        case .interpolatingSpring:
          return .interpolatingSpring(
            mass: animationItem.mass ?? 1.0, stiffness: animationItem.stiffness ?? 100,
            damping: animationItem.damping ?? 10)
        case .easeOut:
          return .easeOut(duration: animationItem.duration ?? 0.5)
      }
    }

    VStack {

      RoundedRectangle(cornerRadius: Styles.sizeSmall)
        .frame(width: 100, height: 90)
        .offset(y: isAnimating ? 20 : -20)
        .animation(animation, value: isAnimating)
        .padding(.bottom, 40)

      Text(animationItem.type.rawValue)
        .font(.title2)
        .foregroundStyle(.tertiary)
        .padding(.bottom)
        .frame(maxWidth: .infinity, alignment: .leading)

      AnimatableProperty(
        nonOptionalBinding($animationItem.duration, defaultValue: 0.5),
        name: "Duration"
      )

      AnimatableProperty(
        nonOptionalBinding($animationItem.bounce, defaultValue: 0.5),
        name: "Bounce"
      )

      AnimatableProperty(
        nonOptionalBinding($animationItem.mass, defaultValue: 1.0),
        name: "Mass"
      )

      AnimatableProperty(
        nonOptionalBinding($animationItem.stiffness, defaultValue: 100),
        name: "Stiffness"
      )

      AnimatableProperty(
        nonOptionalBinding($animationItem.damping, defaultValue: 10),
        name: "Damping"
      )

    }
    .padding(.horizontal, 24)
    .padding(.top, 70)
    .padding(.bottom, 30)
    .background {
      RoundedRectangle(cornerRadius: Styles.sizeRegular)
        .opacity(0.1)
    }
    .onAppear {
      isAnimating.toggle()

      animationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
        fatalError("Need to address this concurrency warning")
        //                isAnimating.toggle()
      }
    }

  }
}

extension SingleAnimationView {

  @ViewBuilder
  func AnimatableProperty(
    _ property: Binding<Double>,
    name: String,
    start: Double = 0.1,
    end: Double = 1.4,
    increment: Double = 0.1
  ) -> some View {
    VStack(alignment: .leading, spacing: 14) {

      Text(name)

      HStack(spacing: 14) {


        Text("\(property.wrappedValue, specifier: "%.2f")")
          .padding(.horizontal, 6)
          .padding(.vertical, 3)
          .background(.white.opacity(0.1))
          .clipShape(.rect(cornerRadius: Styles.sizeTiny))

        Slider(
          value: property,
          in: start ... end
        )
        .controlSize(.small)

        HStack(spacing: 6) {
          Group {
            Button {
              let newValue = property.wrappedValue - increment
              property.wrappedValue = min(max(newValue, start), end)

            } label: {
              Label("Minus", systemImage: "minus")
                .frame(width: 28, height: 24)
                .contentShape(Rectangle())
            }
            Button {
              let newValue = property.wrappedValue + 0.1
              property.wrappedValue = min(max(newValue, start), end)
            } label: {
              Label("Plus", systemImage: "plus")
                .frame(width: 28, height: 24)
                .contentShape(Rectangle())
            }
          }
          .background(.white.opacity(0.1))
          .clipShape(.rect(cornerRadius: Styles.sizeTiny))
        }

        .buttonStyle(.plain)
        .labelStyle(.iconOnly)


      }
      .font(.system(size: 15))
      .monospacedDigit()

    }
    .foregroundStyle(.secondary)
    .fontWeight(.medium)
    .frame(maxWidth: .infinity)

  }
}


#if DEBUG
#Preview {
  AnimationExamples()
    .frame(width: 600, height: 700)
    .background(.black.opacity(0.6))
}
#endif



func nonOptionalBinding<T: Sendable>(_ binding: Binding<T?>, defaultValue: T) -> Binding<T> {
  Binding<T>(
    get: { binding.wrappedValue ?? defaultValue },
    set: { newValue in
      binding.wrappedValue = newValue
    }
  )
}
