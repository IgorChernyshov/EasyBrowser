//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Igor Chernyshov on 21.06.2021.
//

import WebKit

final class ViewController: UIViewController {

	// MARK: - Properties
	private var webView: WKWebView!
	private var progressView: UIProgressView!

	// MARK: - Lifecycle
	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(didTapOpenButton))

		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		toolbarItems = [progressButton, spacer, refresh]
		navigationController?.isToolbarHidden = false

		let url = URL(string: "https://www.ya.ru")!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
	}

	override func viewWillDisappear(_ animated: Bool) {
		webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
		super.viewWillDisappear(animated)
	}

	// MARK: - Selectors
	@objc private func didTapOpenButton() {
		let alertController = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
		alertController.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
		alertController.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
		present(alertController, animated: true)
	}

	private func openPage(action: UIAlertAction) {
		let url = URL(string: "https://" + action.title!)!
		webView.load(URLRequest(url: url))
	}

	// MARK: - Observers
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}
}

// MARK: - WKNavigationDelegate
extension ViewController: WKNavigationDelegate {

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
}
