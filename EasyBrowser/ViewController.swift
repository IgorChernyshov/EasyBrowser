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
	private var url: URL

	// MARK: - Lifecycle
	init(website: String) {
		self.url = URL(string: "https://\(website)")!
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("This initializer is not implemented")
	}

	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		navigationItem.rightBarButtonItem = refreshBarButtonItem

		let backBarButtonItem = UIBarButtonItem(title: "<", style: .plain, target: webView, action: #selector(webView.goBack))
		let forwardBarButtonItem = UIBarButtonItem(title: ">", style: .plain, target: webView, action: #selector(webView.goForward))
		let spacerBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressBarButtonItem = UIBarButtonItem(customView: progressView)

		toolbarItems = [backBarButtonItem, forwardBarButtonItem, spacerBarButtonItem, progressBarButtonItem]
		navigationController?.isToolbarHidden = false

		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
	}

	override func viewWillDisappear(_ animated: Bool) {
		webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
		super.viewWillDisappear(animated)
	}

	// MARK: - Selectors
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

	// MARK: - Alerts
	private func showURLNotAllowedAlert() {
		let alertController = UIAlertController(title: "Parent control", message: "This URL is not allowed", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Mkay", style: .default))
		present(alertController, animated: true)
	}
}

// MARK: - WKNavigationDelegate
extension ViewController: WKNavigationDelegate {

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url

		if let host = url?.host {
			if host.contains(self.url.host ?? "") {
				decisionHandler(.allow)
				return
			}
		}

		showURLNotAllowedAlert()
		decisionHandler(.cancel)
	}
}
