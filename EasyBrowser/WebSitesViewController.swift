//
//  WebSitesViewController.swift
//  EasyBrowser
//
//  Created by Igor Chernyshov on 22.06.2021.
//

import UIKit

final class WebSitesViewController: UITableViewController {

	private lazy var websites: [String] = ["ya.ru", "apple.com", "hackingwithswift.com"]

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Easy Browser"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
}

extension WebSitesViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		websites.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
		cell.textLabel?.text = websites[indexPath.row]
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let viewController = ViewController(website: websites[indexPath.row])
		navigationController?.pushViewController(viewController, animated: true)
	}
}
