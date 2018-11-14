//
//  SignatureCell.swift
//  ApplicationControlSignatures
//
//  Created by Hyuk Hur on 2018-11-12.
//  Copyright © 2018 Hyuk Hur. All rights reserved.
//

import UIKit

class SignatureCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var riskRatingView: RatingView!
    @IBOutlet weak var popularityRatingView: RatingView!

    static let dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        return dateFormatter
    }()

    func loadData(signature: Signature) {
        nameLabel.text = signature.name
        categoryLabel.text = signature.category
        descriptionLabel.text = signature.description
        releaseDateLabel.text = SignatureCell.dateFormatter.string(from: signature.released)
        riskRatingView.rate = signature.risk
        popularityRatingView.rate = signature.popularity
    }
    
}
