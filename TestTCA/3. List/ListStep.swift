//
//  ListStep.swift
//  TestTCA
//
//  Created by Stanislau Parechyn on 20.10.2021.
//

import ComposableArchitecture
import SwiftUI

struct ListStepState: Equatable {
    let items: [Item] = [
        .init(action: .didTap(.blabla), text: "Blabla"),
        .init(action: .didTap(.profile), text: "Profile"),
        .init(action: .didTap(.restore), text: "Restore"),
        .init(action: .didTap(.termsOfUse), text: "Terms of use"),
        .init(action: .didTap(.logout), text: "Log out")
    ]

    @BindableState var route: Route?

    typealias Route = ItemType

    enum ItemType: Equatable {
        case blabla
        case logout
        case profile
        case restore
        case termsOfUse
    }

    struct Item: Identifiable, Equatable {
        let id: UUID = .init()

        let action: ListStepAction
        let text: String
    }
}

enum ListStepAction: BindableAction, Equatable {
    case binding(BindingAction<ListStepState>)
    case didTap(Button)

    typealias Button = ListStepState.ItemType
}


let ListStepReducer = Reducer<ListStepState, ListStepAction, Void>.combine(
    .init{ state, action, env in

        switch action {

        case let .didTap(value):
            state.route = value

        default: break
        }
        
        return .none
    }
    .binding()
)

struct ListStepView: View {
    let store: Store<ListStepState, ListStepAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                List {
                    NavigationLink(
                        "",
                        destination: FirstView(text: "Bla bla"),
                        tag: ListStepState.Route.blabla,
                        selection: viewStore.binding(\.$route))

                    NavigationLink(
                        "",
                        destination: FirstView(text: "Profile"),
                        tag: ListStepState.Route.profile,
                        selection: viewStore.binding(\.$route))

                    NavigationLink(
                        "",
                        destination: FirstView(text: "Restore"),
                        tag: ListStepState.Route.restore,
                        selection: viewStore.binding(\.$route))

                    NavigationLink(
                        "",
                        destination: FirstView(text: "Terms Of Use"),
                        tag: ListStepState.Route.termsOfUse,
                        selection: viewStore.binding(\.$route))

                    NavigationLink(
                        "",
                        destination: FirstView(text: "Log out"),
                        tag: ListStepState.Route.logout,
                        selection: viewStore.binding(\.$route))
                }
                .opacity(0)

                VStack {
                    ForEach(viewStore.items, id: \.id) { item in
                        Button {
                            viewStore.send(item.action)
                        } label: {
                            Text(item.text)
                                .foregroundColor(.init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)))
                                .frame(height: 44)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                        }

                    }
                }
            }
        }
    }
}

#if DEBUG
struct ListStepView_Previews: PreviewProvider {
    static var previews: some View {
        ListStepView(store: MockUp.make())
    }
}

extension MockUp {
    static func make() -> Store<ListStepState, ListStepAction> {
        .init(initialState: .init(), reducer: ListStepReducer, environment: ())
    }
}
#endif
