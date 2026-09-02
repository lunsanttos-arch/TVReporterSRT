import SwiftUI

@main
struct TVReporterSRTApp: App {
    @StateObject private var model = BroadcastViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
