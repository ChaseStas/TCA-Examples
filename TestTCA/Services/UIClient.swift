//
//  UIClient.swift
//  TestTCA
//
//  Created by Stanislau Parechyn on 03.11.2021.
//
import ComposableArchitecture
import Foundation
import SwiftUI
import UIKit

fileprivate extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

struct UIClient {
    var showPopup: (AnyHashable, String) -> Effect<Never, Never>
}

extension UIClient {

    private enum UIPopupHelper {
        static var presentedVCs: [AnyHashable: UIViewController] = [:]

        static func present(_ id: AnyHashable, text: String) {
            let topVC = UIApplication.topViewController()

            let view = InfoPopup(text: text,
                                 onDismiss: {
                                    presentedVCs[id]?.dismiss(animated: true, completion: nil)
                                    presentedVCs.removeValue(forKey: id)
                                 })
            let vc = UIHostingController(rootView: view)
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            presentedVCs[id] = vc
            
            topVC?.present(vc, animated: true, completion: nil)
        }
    }

    static let live: Self = {
        .init(showPopup: { id, text in
            .fireAndForget {
                UIPopupHelper.present(id, text: text)
            }
        })
    }()
}



