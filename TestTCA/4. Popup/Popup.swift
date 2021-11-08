//
//  Popup.swift
//  TestTCA
//
//  Created by Stanislau Parechyn on 03.11.2021.
//

import ComposableArchitecture
import SwiftUI

struct PopupState: Equatable {
}

enum PopupAction: BindableAction, Equatable {
    case binding(BindingAction<PopupState>)
    case didTap(Button)

    enum Button: Equatable {
        case showPopup
        case showTwoPopups
    }
}

struct PopupEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let uiClient: UIClient
}

let PopupReducer = Reducer<PopupState, PopupAction, PopupEnvironment>.combine(
    .init{ state, action, env in

        struct FirstPopupId: Hashable {}
        struct SecondPopupId: Hashable {}

        switch action {

        case .didTap(.showPopup):
            return env.uiClient
                .showPopup(FirstPopupId(), "This is first popup!")
                .fireAndForget()

        case .didTap(.showTwoPopups):
            return .merge(
                env.uiClient
                    .showPopup(FirstPopupId(),"This is first popup! I'm going to show second in 3 seconds")
                    .fireAndForget(),
                env.uiClient
                    .showPopup(SecondPopupId(),"This is second 🥰 popup!")
                    .deferred(for: 3, scheduler: env.mainQueue)
                    .fireAndForget()
            )


        default: break
        }
        
        return .none
    }.binding()
)

struct PopupView: View {
    let store: Store<PopupState, PopupAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Button(action: {
                    viewStore.send(.didTap(.showPopup))
                }, label: {
                    Text("Show Popup")
                })

                Button(action: {
                    viewStore.send(.didTap(.showTwoPopups))
                }, label: {
                    Text("Show Two Popups")
                })
            }
        }
    }
}

#if DEBUG
struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView(store: MockUp.make())
    }
}

extension MockUp {
    static func make() -> Store<PopupState, PopupAction> {
        .init(initialState: .init(), reducer: PopupReducer, environment: make())
    }

    static func make() -> PopupEnvironment {
        .init(mainQueue: .main, uiClient: .live)
    }
}
#endif
