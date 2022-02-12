//
//  InnerScrollable.swift
//  StickyHeader
//
//  Created by 오킹 on 2022/02/13.
//

import UIKit

protocol InnerTableViewScrollDelegate: AnyObject {
    func innerTableViewDidScroll(_ scrollView: UIScrollView, withDistance: CGFloat)
}

protocol InnerScrollable: UIViewController {
    func setInnerTableViewScrollDelegate(_ delegate: InnerTableViewScrollDelegate)
}
