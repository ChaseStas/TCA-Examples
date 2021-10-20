//
//  Second.swift
//  TestTCA
//
//  Created by Stanislau Parechyn on 20.10.2021.
//

import ComposableArchitecture
import SwiftUI

struct SecondState: Equatable {

//    @BindableState var route: Route?
//    enum Route: Equatable {
//
//    }
}

enum SecondAction: BindableAction, Equatable {
    case binding(BindingAction<SecondState>)
}

struct SecondEnvironment {
    
}

let SecondReducer = Reducer<SecondState, SecondAction, SecondEnvironment>.combine(
    .init{ state, action, env in

        switch action {

        default: break
        }
        
        return .none
    }.binding()
)

struct SecondView: View {
    let store: Store<SecondState, SecondAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Text("Hello, this is second view!")
        }
    }
}

#if DEBUG
struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(store: MockUp.make())
    }
}

extension MockUp {
    static func make() -> Store<SecondState, SecondAction> {
        .init(initialState: .init(), reducer: SecondReducer, environment: make())
    }

    static func make() -> SecondEnvironment {
        .init()
    }
}
#endif
