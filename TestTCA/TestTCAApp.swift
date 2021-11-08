//
//  TestTCAApp.swift
//  TestTCA
//
//  Created by Stanislau Parechyn on 14.10.2021.
//

import ComposableArchitecture
import SwiftUI

@main
struct TestTCAApp: App {
    let store: Store<CoreState, CoreAction> = .init(
        initialState: .init(),
        reducer: CoreReducer,
        environment: CoreEnvironment(mainQueue: .main, uiClient: .live)
    )

    var body: some Scene {
        WindowGroup {
            NavigationView {
                CoreView(store: store)
            }
        }
    }
}
