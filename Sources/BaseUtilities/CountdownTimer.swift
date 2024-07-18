//
//  Clipboard.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//
import Foundation
import SwiftUI

@Observable
public class CountdownTimer {
    public var countdownTask: Task<Void, Never>? = nil
    public var timeLeft: TimeInterval = 0
    public var onCountdownEnd: (() -> Void)?
    
    public init() {

    }
    
    // Usage:
    // Initialise with e.g. `var countdownTimer = CountdownTimer()`
    //    task(id: isKeyUnlocked) {
    //        if isKeyUnlocked {
    //            countdown.onCountdownEnd = {
    //                isKeyUnlocked = false
    //            }
    //            countdown.startCountdown(for: 60)
    //        }
    //    }
    
    /// Notes on this implementation:
    /// - Repeating task that checks the time left against a target end date
    /// - Involves repeated checks at regular intervals, which provides opportunities to update UI or state and handle other logic on each tick
    /// - Better suited for scenarios where continuous feedback or updates are required throughout the duration of the countdown, such as updating a user interface with the time remaining
    public func startCountdown(for duration: TimeInterval, starting: Date = .now) {
        
//        print("|--- start Countdown --->")
        
        if let existingTask = countdownTask {
            existingTask.cancel()
            countdownTask = nil
//            print("Existing countdown task cancelled.")
        }
        
        let endDate = starting + duration
//        print("End date is \(endDate)")
        
        countdownTask = Task {
//            print("Beginning countdown task")
            while true {
                let now = Date()
                if now >= endDate {
//                    print("Countdown Ended")
                    await MainActor.run {
                                            self.onCountdownEnd?()
                                        }

                    break
                }
                // Check cancellation here to handle it more proactively
                if Task.isCancelled {
//                    print("Task was cancelled")
                    break
                }
                
                let timeLeft = endDate.timeIntervalSince(now)

                await MainActor.run {
                                    self.timeLeft = timeLeft
                                }
//                print("Updated the timeLeft property: \(self.timeLeft)")
                
                try? await Task.sleep(for: .seconds(1))
            }
        }
//        print(">--- END start Countdown ---|\n")
    } // END start countdown
    
    
    /// Notes on alternative approach below:
    /// - 'one-shot sleep' until a specific deadline
    /// - A single await for the entire duration until a pre-defined deadline.
    /// -  Ideal for scenarios where you simply need to delay execution of code until some time has passed without the need to perform actions during the waiting period
//    let refreshTask = Task {
//        
//        let deadline = ContinuousClock().now.advanced(by: .seconds(Int(duration)))
//        
//        do {
//            print("Beginning the timer now, at \(Date.now). Should perform a refresh at \(deadline)")
//            try await Task.sleep(until: deadline, clock: ContinuousClock())
//            
//            print("GOG timer is up")
//            
//        } catch {
//            // Handle cancellation or other errors
//            print("Token refresh task was canceled or an error occurred.")
//        }
//        
//    }
}
