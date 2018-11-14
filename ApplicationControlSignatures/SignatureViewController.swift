//
//  SignatureViewController.swift
//  ApplicationControlSignatures
//
//  Created by Hyuk Hur on 2018-11-12.
//  Copyright © 2018 Hyuk Hur. All rights reserved.
//

import UIKit

class SignatureViewController: UITableViewController {
    static let signatureDetailCell = "signatureDetailCell"

    var signature: Signature? {
        didSet {
            title = signature?.name
        }
    }

    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SignatureViewController.signatureDetailCell, for: indexPath) as? SignatureDetailCell,
            let signature = signature else {
            return UITableViewCell()
        }
        cell.loadData(signature: signature)
        return cell
    }
}
