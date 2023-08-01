//
//  Scale.swift
//  YJKit
//
//  Created by yjzheng on 2023/8/1.
//

import UIKit

public extension CGFloat {
    var yj_scale: CGFloat {
        return YJ.scale(self)
    }
}

public extension Int {
    var yj_scale: CGFloat {
        return YJ.scale(CGFloat(self))
    }
}

public extension Double {
    var yj_scale: CGFloat {
        return YJ.scale(CGFloat(self))
    }
}
