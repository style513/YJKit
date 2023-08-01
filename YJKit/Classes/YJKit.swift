//
//  YJKit.swift
//  YJKit
//
//  Created by yjzheng on 2023/8/1.
//

import Foundation
import UIKit

typealias YJ = YJKitManager

/// <#Description#>
enum YJKitManager {
    static let w = UIScreen.main.bounds.width
    static let h = UIScreen.main.bounds.height

    /// App名称
    static var displayName: String {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "YJKit"
    }

    /// App的Bundle ID
    static var bundleID: String {
        return Bundle.main.bundleIdentifier ?? "com.yjkit"
    }

    /// Build号
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "1"
    }

    /// App版本号
    static var versionS: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// 设备名称
    static var deviceName: String {
        return UIDevice.current.localizedModel
    }

    /// 设备方向，有时会取到未知unknown
    static var deviceOrientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }

    /// 主窗口
    static var keyWindow: UIWindow? {
        return getKeyWindow()
    }

    /// 当前系统版本
    static var systemVersion: String {
        return UIDevice.current.systemVersion
    }

    /// 判断设备是不是iPhoneX系列
    static var isX: Bool {
        return bottomSafeAreaHeight != 0
    }

    /// TabBar距底部区域高度
    static var bottomSafeAreaHeight: CGFloat {
        return YJKitManager.getKeyWindow()?.safeAreaInsets.bottom ?? 0
    }

    /// 状态栏的高度
    static var topSafeAreaHeight: CGFloat {
        return YJKitManager.getKeyWindow()?.safeAreaInsets.top ?? 0
    }

    /// 左边安全距
    static var leftSafeAreaWidth: CGFloat {
        return YJKitManager.getKeyWindow()?.safeAreaInsets.left ?? 0
    }

    /// 右边安全距
    static var rightSafeAreaWidth: CGFloat {
        return YJKitManager.getKeyWindow()?.safeAreaInsets.right ?? 0
    }

    static func getKeyWindow() -> UIWindow? {
        var keyWindow: UIWindow?
        if #available(iOS 13.0, *) {
            keyWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        return keyWindow
    }

    /// 导航栏的高度
    static let navBarHeight: CGFloat = 44.0

    /// TabBar的高度
    static let tabBarHeight: CGFloat = 49.0

    /// 状态栏和导航栏的高度
    static var statusWithNavBarHeight: CGFloat {
        return topSafeAreaHeight + navBarHeight
    }

    /// 根据宽度缩放
    static func scaleW(_ width: CGFloat, fit: CGFloat = 375.0) -> CGFloat {
        return w / fit * width
    }

    /// 根据高度缩放
    static func scaleH(_ height: CGFloat, fit: CGFloat = 812.0) -> CGFloat {
        return h / fit * height
    }

    /// 默认根据宽度缩放
    static func scale(_ value: CGFloat) -> CGFloat {
        return scaleW(value)
    }

    /// 根据控制器获取顶层控制器
    static func topVC(_ viewController: UIViewController?) -> UIViewController? {
        guard let currentVC = viewController else {
            return nil
        }
        if let nav = currentVC as? UINavigationController {
            return topVC(nav.visibleViewController)
        } else if let tabC = currentVC as? UITabBarController {
            return topVC(tabC.selectedViewController)
        } else if let presentVC = currentVC.presentedViewController {
            return topVC(presentVC)
        } else {
            return currentVC
        }
    }

    /// 获取顶层控制器根据window
    static func topVC() -> UIViewController? {
        var window = YJKitManager.getKeyWindow()

        if window?.windowLevel != UIWindow.Level.normal {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                window = windowScene.windows.first(where: { $0.isKeyWindow })
            }
        }

        return window?.rootViewController.flatMap { topVC($0) }
    }

    /// 当用户截屏时的监听
    static func didTakeScreenShot(_ action: @escaping (_ notification: Notification) -> Void) {
        _ = NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main)
        { notification in
            action(notification)
        }
    }

    /// 主动崩溃
    static func exitApp() {
        abort()
    }

    /// 打开系统设置页面
    static func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }

    /// 检查设备是否支持电话功能
    static var canMakePhoneCalls: Bool {
        return UIApplication.shared.canOpenURL(URL(string: "tel://")!)
    }
}
