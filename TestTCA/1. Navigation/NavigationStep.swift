//
//  NavigationStep.swift
//  TestTCA
//
//  Created by Stanislau Parechyn on 20.10.2021.
//

import ComposableArchitecture
import SwiftUI

struct NavigationStepState: Equatable {
    @BindableState var route: Route?
    @BindableState var shouldNavigate = false

    enum Route: Equatable {
        case next
    }
}

enum NavigationStepAction: BindableAction, Equatable {
    case binding(BindingAction<NavigationStepState>)

    case someAction
}

let NavigationStepReducer = Reducer<NavigationStepState, NavigationStepAction, Void>.combine(
    .init{ state, action, env in

        switch action {

        case .someAction:
            state.route = .next

        default: break
        }
        
        return .none
    }.binding()
)

struct NavigationStepView: View {
    let store: Store<NavigationStepState, NavigationStepAction>

    var body: some View {
        WithViewStore(store) { viewStore in

            ZStack {
                // NavigationLink добавлены в List и спрятаны из-за бага на ios 14.5, который выкидывает с нужного экрана как только ты сделал переход
                List {
                    NavigationLink("",
                                   destination: FirstView(text: "Destination with Binding<Bool> navigation"),
                                                          isActive: viewStore.binding(\.$shouldNavigate))

                    NavigationLink("",
                                   destination: FirstView(text: "Destination with Action and Route"),
                                   tag: NavigationStepState.Route.next,
                                   selection: viewStore.binding(\.$route))
                }
                .opacity(0.0)

                List {
                    NavigationLink(destination: FirstView(text: "This was simple navigation with destination and label")) {
                        Text("1. Simple navigation")
                    }


                    Button {
                        viewStore.send(.binding(.set(\.$shouldNavigate, !viewStore.shouldNavigate)))
                    } label: {
                        Text("2. Navigate with binding")
                    }


                    Button {
                        viewStore.send(.someAction)
                    } label: {
                        Text("3. Navigate with route")
                    }
                }
            }

        }
    }
}

#if DEBUG
struct NavigationStepView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStepView(store: MockUp.make())
    }
}

extension MockUp {
    static func make() -> Store<NavigationStepState, NavigationStepAction> {
        .init(initialState: .init(), reducer: NavigationStepReducer, environment: () )
    }

}
#endif
