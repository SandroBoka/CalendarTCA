import SwiftUI
import ComposableArchitecture

@main
struct DemoApp: App {

    var body: some Scene {
        WindowGroup {
            CalendarScreen(
                store: Store(initialState: CalendarFeature.State()) {
                    CalendarFeature()
                }
            )
        }
    }

}
