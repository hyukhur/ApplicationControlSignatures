//
//  ViewController.swift
//  ApplicationControlSignatures
//
//  Created by Hyuk Hur on 2018-11-12.
//  Copyright © 2018 Hyuk Hur. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    let fetcher = try! Fetcher<Signature>(address: "")!

    static let cellIdentifier = "signatureCell"
    static let showSignatureIdentifier = "showSignature"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()

        refreshControl?.addTarget(self,
                                 action:#selector(ViewController.refreshChanged(_:)),
                                 for: .valueChanged)

        refreshControl?.beginRefreshing()
        refreshChanged(refreshControl!)
    }

    @objc
    func refreshChanged(_ refreshControl: UIRefreshControl) {
        fetcher.fetch {[weak self, weak refreshControl] _,_ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                refreshControl?.endRefreshing()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetcher.domainObjects.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier, for: indexPath) as? SignatureCell else {
            return UITableViewCell()
        }
        cell.loadData(signature: fetcher.domainObjects[indexPath.row])
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case ViewController.showSignatureIdentifier:
            guard let row = tableView?.indexPathForSelectedRow?.row,
                let destination = segue.destination as? SignatureViewController else {
                    return
            }

            destination.signature = fetcher.domainObjects[row]
        default: break
        }
    }
}

