//
//  UIView+Constraints.swift
//  WeatherAppDemo
//
//  Created by Berkay Vurkan on 4.12.2020.
//

import UIKit

extension UIView {
    public func fit(_ into: UIView) {
        into.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            .init(item: into, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            .init(item: into, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: into, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: into, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        self.layoutIfNeeded()
    }

    public func fitVertically(_ into: UIView, left: CGFloat?, right: CGFloat?) {
        into.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraintBatch: [NSLayoutConstraint] = [
            .init(item: into, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            .init(item: into, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        ]
        if let leadingMargin = left {
            constraintBatch.append(.init(item: into, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: -leadingMargin))
        }
        if let trailingMargin = right {
            constraintBatch.append(.init(item: into, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: trailingMargin))
        }
        NSLayoutConstraint.activate(constraintBatch)
        self.layoutIfNeeded()
    }
}
