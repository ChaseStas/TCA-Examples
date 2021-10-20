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
    var stateList: ListStepState = .init()
    var stateNavigation: NavigationStepState = .init()
}

enum CoreAction: BindableAction, Equatable {
    case actionBindable(BindableStepAction)
    case actionList(ListStepAction)
    case actionNavigation(NavigationStepAction)

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
            environment: { _ in }),
    ListStepReducer
        .pullback(
            state: \.stateList,
            action: /CoreAction.actionList,
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
                NavigationLink("3. List",
                               destination: ListStepView(store: store.scope(state: \.stateList,
                                                                                  action: CoreAction.actionList)))
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
