//
//  Core.swift
//  TestTCA
//
//  Created by Stanislau Parechyn on 20.10.2021.
//

import ComposableArchitecture
import SwiftUI

struct CoreState: Equatable {

    var stateBindable: BindableStepState = .init()
    var stateNavigation: NavigationStepState = .init()
//    @BindableState var route: Route?
//    enum Route: Equatable {
//
//    }
}

enum CoreAction: BindableAction, Equatable {
    case actionNavigation(NavigationStepAction)
    case actionBindable(BindableStepAction)
    case binding(BindingAction<CoreState>)
}

struct CoreEnvironment {
    
}

let CoreReducer = Reducer<CoreState, CoreAction, CoreEnvironment>.combine(
    .init{ state, action, env in

        switch action {

        default: break
        }
        
        return .none
    }
    .debugActions()
    .binding(),
    NavigationStepReducer
        .pullback(
            state: \.stateNavigation,
            action: /CoreAction.actionNavigation,
            environment: { _ in }),
    BindableStepReducer
        .pullback(
            state: \.stateBindable,
            action: /CoreAction.actionBindable,
            environment: { _ in })
)

struct CoreView: View {
    let store: Store<CoreState, CoreAction>

    var body: some View {
        WithViewStore(store) { viewStore in

            List {
                NavigationLink("1. Navigation",
                               destination: NavigationStepView(store: store.scope(state: \.stateNavigation,
                                                                                  action: CoreAction.actionNavigation)))
                NavigationLink("2. Bindable State&Action",
                               destination: BindableStepView(store: store.scope(state: \.stateBindable,
                                                                                  action: CoreAction.actionBindable)))
            }
        }
    }
}

#if DEBUG
enum MockUp {}

struct CoreView_Previews: PreviewProvider {
    static var previews: some View {
        CoreView(store: MockUp.make())
    }
}

extension MockUp {
    static func make() -> Store<CoreState, CoreAction> {
        .init(initialState: .init(), reducer: CoreReducer, environment: make())
    }

    static func make() -> CoreEnvironment {
        .init()
    }
}
#endif
