//
//  Third.swift
//  TestTCA
//
//  Created by Stanislau Parechyn on 20.10.2021.
//

import ComposableArchitecture
import SwiftUI

struct ThirdState: Equatable {

//    @BindableState var route: Route?
//    enum Route: Equatable {
//
//    }
}

enum ThirdAction: BindableAction, Equatable {
    case binding(BindingAction<ThirdState>)
}

struct ThirdEnvironment {
    
}

let ThirdReducer = Reducer<ThirdState, ThirdAction, ThirdEnvironment>.combine(
    .init{ state, action, env in

        switch action {

        default: break
        }
        
        return .none
    }.binding()
)

struct ThirdView: View {
    let store: Store<ThirdState, ThirdAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Text("Hello, this is third View!")
        }
    }
}

#if DEBUG
struct ThirdView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdView(store: MockUp.make())
    }
}

extension MockUp {
    static func make() -> Store<ThirdState, ThirdAction> {
        .init(initialState: .init(), reducer: ThirdReducer, environment: make())
    }

    static func make() -> ThirdEnvironment {
        .init()
    }
}
#endif
