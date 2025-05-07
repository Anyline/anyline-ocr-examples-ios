import Foundation

class PerformanceTracking {

    deinit {
        stopTracking()
    }

    let timeWindow: TimeInterval = 5.0

    private var resultTimestamps: [Date] = []

    // gathered per result.
    private var frameMetrics: [Date: ALPerformanceMetrics] = [:]

    // first is results per second (over timewindow), and second is an average of the
    // ALPerformanceMetrics.scanControllerProcessInMS values compiled in that same time period.
    private var rateCallback: ((Double, Double) -> Void)?

    private(set) var currentRate: Double = 0.0

    private var updateTimer: Timer?

    func startTracking(updateInterval: TimeInterval = 1.0, callback: ((Double, Double) -> Void)?) {
        self.rateCallback = callback

        stopTracking()

        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.calculateRate()
        }

        if let timer = updateTimer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }

    func stopTracking() {
        updateTimer?.invalidate()
        updateTimer = nil
    }


    func recordEvent(metric: ALPerformanceMetrics? = nil) {
        let date = Date()

        resultTimestamps.append(date)

        if let frameMetric = metric {
            frameMetrics[date] = frameMetric
        }

        pruneOldTimestamps()
    }

    func reset() {
        resultTimestamps.removeAll()
        frameMetrics.removeAll()
        currentRate = 0.0
        if let callback = rateCallback {
            callback(currentRate, 0.0)
        }
    }

    private func calculateRate() {

        pruneOldTimestamps()

        // Calculate events per second over the time window
        let eventsInWindow = resultTimestamps.count
        currentRate = Double(eventsInWindow) / timeWindow /* 5.0 */

        let sumProcessingTimes = frameMetrics.reduce(0) { result, element -> Int in
            result + (element.value.scanControllerProcessInMS?.intValue ?? 0)
        }

        var avgProcessingTimes = Double(0)
        if (frameMetrics.count > 0) {
            avgProcessingTimes = Double(sumProcessingTimes) / Double(frameMetrics.count)
        }

        // print("currentRate: \(currentRate), average processing time ms: \(avgProcessingTimes)")

        if let callback = rateCallback {
            callback(currentRate, avgProcessingTimes)
        }
    }

    private func pruneOldTimestamps() {
        let cutoffDate = Date().addingTimeInterval(-timeWindow)
        resultTimestamps = resultTimestamps.filter { $0 > cutoffDate }
        frameMetrics = frameMetrics.filter { $0.key > cutoffDate }
    }
}
