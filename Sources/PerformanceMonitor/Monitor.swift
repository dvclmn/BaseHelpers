//
//  File.swift
//
//
//  Created by Dave Coleman on 18/7/2024.
//

import SwiftUI
import Combine
import Foundation
import Charts

#if os(iOS)
import UIKit
#endif

struct PerformanceMetric: Identifiable {
    let id = UUID()
    let timestamp: Date
    let frameTime: Double
    let frameRate: Double
    let cpuUsage: Double
}

@Observable
class PerformanceMonitor {
    
    @Published var currentMetric: PerformanceMetric
        @Published var metrics: [PerformanceMetric] = []
    
    var frameTime: Double = 0
    var cpuUsage: Double = 0
    
    private var lastFrameTime: CFTimeInterval = CACurrentMediaTime()
    private var timer: Timer?
    private var displayLink: Any?
    
    
    
    
    private var updateCounter: Int = 0
    private var accumulatedFrameTime: Double = 0
    private var accumulatedCPUUsage: Double = 0
    
    let updateFrequency: Double
    
    
    init(updateFrequency: Double = 1.0) {
        
        self.updateFrequency = updateFrequency
        
#if os(iOS)
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        (displayLink as? CADisplayLink)?.add(to: .current, forMode: .common)
#elseif os(macOS)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.update()
        }
#endif
    }
    
    deinit {
#if os(iOS)
        (displayLink as? CADisplayLink)?.invalidate()
#elseif os(macOS)
        timer?.invalidate()
#endif
    }
    
    @objc private func update() {
        let currentTime = CACurrentMediaTime()
        let currentFrameTime = (currentTime - lastFrameTime) * 1000 // Convert to milliseconds
        lastFrameTime = currentTime
        
        let currentCPUUsage = getCPUUsage()
        
        accumulatedFrameTime += currentFrameTime
        accumulatedCPUUsage += currentCPUUsage
        updateCounter += 1
        
        if currentTime.truncatingRemainder(dividingBy: updateFrequency) < 1.0 / 60.0 {
            frameTime = accumulatedFrameTime / Double(updateCounter)
            cpuUsage = accumulatedCPUUsage / Double(updateCounter)
            
            accumulatedFrameTime = 0
            accumulatedCPUUsage = 0
            updateCounter = 0
        }
    }
    
    private func getCPUUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList: thread_act_array_t?
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsCount) {
            task_threads(mach_task_self_, &threadsList, $0)
        }
        
        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(MemoryLayout<thread_basic_info>.size / MemoryLayout<integer_t>.size)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                
                if infoResult == KERN_SUCCESS {
                    let threadBasicInfo = threadInfo
                    if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                        totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                    }
                }
            }
        }
        
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        return totalUsageOfCPU
    }
}

struct PerformanceMetricsView: View {
    @State var monitor = PerformanceMonitor()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Frame Time: \(String(format: "%.2f", monitor.frameTime)) ms")
            Text("CPU Usage: \(String(format: "%.2f", monitor.cpuUsage))%")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(minWidth: 190, alignment: .leading)
        .monospaced()
        .background(.black.opacity(0.4))
        .clipShape(.rect(cornerRadius: 8))
    }
}


#Preview {
    PerformanceMetricsView()
        .padding(40)
        .background(.black.opacity(0.6))
}
