//
//  SignatureDetailCell.swift
//  ApplicationControlSignatures
//
//  Created by Hyuk Hur on 2018-11-12.
//  Copyright © 2018 Hyuk Hur. All rights reserved.
//


import UIKit

class SignatureDetailCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var riskRatingView: RatingView!
    @IBOutlet weak var popularityRatingView: RatingView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var referencesViews: UIStackView!
    @IBOutlet weak var referencesTextView: UITextView!

    static let dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter
    }()

    func loadData(signature: Signature) {
        idLabel.text = "\(signature.id)"
        nameLabel.text = signature.name
        categoryLabel.text = signature.category
        releaseDateLabel.text = SignatureDetailCell.dateFormatter.string(from: signature.released)
        riskRatingView.rate = signature.risk
        popularityRatingView.rate = signature.popularity
        descriptionTextView.text = signature.description
        referencesViews.isHidden = signature.referenceURLs.isEmpty
        referencesTextView.text = signature.referenceURLs.map({ $0.absoluteString }).joined(separator: "\n")
    }
}
