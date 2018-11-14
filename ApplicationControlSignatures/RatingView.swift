//
//  RatingView.swift
//  ApplicationControlSignatures
//
//  Created by Hyuk Hur on 2018-11-12.
//  Copyright © 2018 Hyuk Hur. All rights reserved.
//

import UIKit

@IBDesignable
class RatingView: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = ratingText(rate: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        text = ratingText(rate: 0)
    }

    @IBInspectable
    var rate: Int = 0 {
        didSet {
            text = ratingText(rate: rate)
        }
    }

    @IBInspectable
    var unratedCharacter: String = "☆" {
        didSet {
            rate = 0
        }
    }

    @IBInspectable
    var ratedCharacter: String = "★" {
        didSet {
            rate = 0
        }
    }

    private func ratingText(rate: Int) -> String {
        return (0..<5).map({
            $0 < rate ? ratedCharacter : unratedCharacter
        }).joined()
    }
}
