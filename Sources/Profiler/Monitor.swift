////
////  File.swift
////
////
////  Created by Dave Coleman on 18/7/2024.
////
//
//import SwiftUI
//import Combine
//import Foundation
//import Charts
//import QuartzCore
//
//struct PerformanceMetric: Identifiable {
//    let id = UUID()
//    let timestamp: Date
//    let frameTime: Double
//    let frameRate: Double
//    let cpuUsage: Double
//}
//
//
//@MainActor
//extension CADisplayLink {
//    static func events() -> AsyncStream<CADisplayLink> {
//        AsyncStream { continuation in
//            let displayLink = DisplayLink { displayLink in
//                continuation.yield(displayLink)
//            }
//            
//            continuation.onTermination = { _ in
//                Task { await displayLink.stop() }
//            }
//        }
//    }
//}
//
//
//private extension CADisplayLink {
//    @MainActor
//    private class DisplayLink: NSObject {
//        private var displayLink: CADisplayLink?
//        private let handler: (CADisplayLink) -> Void
//        
//        init(mode: RunLoop.Mode = .default, handler: @escaping (CADisplayLink) -> Void) {
//            self.handler = handler
//            super.init()
//            
//            
//#if os(iOS)
//            displayLink = CADisplayLink(target: self, selector: #selector(handle(displayLink:)))
//#else
//            let window = NSApplication.shared.windows.first
//            
//            
//            
////            displayLink = displayLink(target: self, selector: #selector(handle(displayLink:))
////            displayLink = window?.displayLink(target: self, selector: #selector(handle(displayLink:)))
//#endif
//            displayLink?.add(to: .main, forMode: mode)
//            
//        }
//        
//        func stop() {
//            displayLink?.invalidate()
//        }
//        
//        @objc func handle(displayLink: CADisplayLink) {
//            handler(displayLink)
//        }
//    }
//}
//
//struct ContentViewTest: View {
//    @State var timestamp: CFTimeInterval = 0
//    
//    var body: some View  {
//        VStack {
//            Text("\(timestamp, specifier: "%0.2f")")
//                .monospacedDigit()
//        }
//        .task {
//            for await event in CADisplayLink.events() {
//                timestamp = event.targetTimestamp
//            }
//        }
//    }
//}
//
//@Observable
//class PerformanceMonitor {
//    
//    var currentMetric: PerformanceMetric
//    var metrics: [PerformanceMetric] = []
//    
//    private let updateFrequency: Double
//    private let maxDataPoints: Int
//    private var lastUpdateTime: CFTimeInterval = 0
//    private var task: Task<Void, Never>?
//    
//    init(updateFrequency: Double = 1.0, maxDataPoints: Int = 60) {
//        self.updateFrequency = updateFrequency
//        self.maxDataPoints = maxDataPoints
//        self.currentMetric = PerformanceMetric(timestamp: Date(), frameTime: 0, frameRate: 0, cpuUsage: 0)
//        
//        
//        startMonitoring()
//    }
//    
//    deinit {
//        task?.cancel()
//    }
//    
//    private func startMonitoring() {
//        task = Task {
//            for await displayLink in await CADisplayLink.events() {
//                self.update(displayLink: displayLink)
//            }
//        }
//    }
//    
////        private func createDisplayLink() {
////                displayLink = CADisplayLink(target: self, selector: #selector(update))
////                displayLink?.add(to: .current, forMode: .common)
////    
////                // Optionally set preferred frame rate
////                // displayLink?.preferredFramesPerSecond = 60
////            }
//    
//    private func update(displayLink: CADisplayLink) {
//        let currentTime = displayLink.timestamp
//        
//        if currentTime - lastUpdateTime >= updateFrequency {
//            let frameTime = (displayLink.targetTimestamp - displayLink.timestamp) * 1000 // Convert to milliseconds
//            let frameRate = 1 / (displayLink.targetTimestamp - displayLink.timestamp)
//            let cpuUsage = getCPUUsage()
//            
//            let newMetric = PerformanceMetric(
//                timestamp: Date(),
//                frameTime: frameTime,
//                frameRate: frameRate,
//                cpuUsage: cpuUsage
//            )
//            
//            self.currentMetric = newMetric
//            self.metrics.append(newMetric)
//            if self.metrics.count > self.maxDataPoints {
//                self.metrics.removeFirst()
//            }
//            
//            lastUpdateTime = currentTime
//        }
//    }
//    
//    
//    private func getCPUUsage() -> Double {
//        var totalUsageOfCPU: Double = 0.0
//        var threadsList: thread_act_array_t?
//        var threadsCount = mach_msg_type_number_t(0)
//        let threadsResult = withUnsafeMutablePointer(to: &threadsCount) {
//            task_threads(mach_task_self_, &threadsList, $0)
//        }
//        
//        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
//            for index in 0..<threadsCount {
//                var threadInfo = thread_basic_info()
//                var threadInfoCount = mach_msg_type_number_t(MemoryLayout<thread_basic_info>.size / MemoryLayout<integer_t>.size)
//                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
//                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
//                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
//                    }
//                }
//                
//                if infoResult == KERN_SUCCESS {
//                    let threadBasicInfo = threadInfo
//                    if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
//                        totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
//                    }
//                }
//            }
//        }
//        
//        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
//        return totalUsageOfCPU
//    }
//}
//
//struct PerformanceGraphView: View {
//    
//    @State var monitor = PerformanceMonitor()
//    
//    var body: some View {
//        VStack {
//            Chart(monitor.metrics) { metric in
//                LineMark(
//                    x: .value("Time", metric.timestamp),
//                    y: .value("Frame Time", metric.frameTime)
//                )
//                .foregroundStyle(.blue)
//                
//                LineMark(
//                    x: .value("Time", metric.timestamp),
//                    y: .value("Frame Rate", metric.frameRate)
//                )
//                .foregroundStyle(.green)
//                
//                LineMark(
//                    x: .value("Time", metric.timestamp),
//                    y: .value("CPU Usage", metric.cpuUsage)
//                )
//                .foregroundStyle(.red)
//            }
//            .frame(height: 200)
//            .padding()
//            
//            Text("Frame Time: \(String(format: "%.2f", monitor.currentMetric.frameTime)) ms")
//            Text("Frame Rate: \(String(format: "%.2f", monitor.currentMetric.frameRate)) FPS")
//            Text("CPU Usage: \(String(format: "%.2f", monitor.currentMetric.cpuUsage))%")
//        }
//        .padding()
//        .background(Color.black.opacity(0.7))
//        .foregroundColor(.white)
//        .cornerRadius(10)
//    }
//}
//
//
//#Preview {
//    PerformanceGraphView()
//        .padding(40)
//        .background(.black.opacity(0.6))
//}
