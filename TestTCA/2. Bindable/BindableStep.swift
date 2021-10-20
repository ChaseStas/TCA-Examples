//
//  BindableStep.swift
//  TestTCA
//
//  Created by Stanislau Parechyn on 20.10.2021.
//

import ComposableArchitecture
import SwiftUI

struct BindableStepState: Equatable {
    var oldText: String = ""

    @BindableState var text: String = ""
}

enum BindableStepAction: BindableAction, Equatable {
    case binding(BindingAction<BindableStepState>)

    case changeOldText(String)
}

let BindableStepReducer = Reducer<BindableStepState, BindableStepAction, Void>.combine(
    .init{ state, action, env in

        switch action {

        case let .changeOldText(value):
            state.oldText = value

        default: break
        }
        
        return .none
    }.binding()
)

struct BindableStepView: View {
    let store: Store<BindableStepState, BindableStepAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                TextField("Old Placeholder",
                          text: viewStore.binding(get: \.oldText,
                                                  send: BindableStepAction.changeOldText))

                TextField("Placeholder", text: viewStore.binding(\.$text))
            }
        }
    }
}

#if DEBUG
struct BindableStepView_Previews: PreviewProvider {
    static var previews: some View {
        BindableStepView(store: MockUp.make())
    }
}

extension MockUp {
    static func make() -> Store<BindableStepState, BindableStepAction> {
        .init(initialState: .init(), reducer: BindableStepReducer, environment: ())
    }
}
#endif
