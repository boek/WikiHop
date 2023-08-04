import Combine
import WebKit
import SwiftUI
import Foundation

public struct FindInPageResults: Equatable {
    public var current: Int
    public var total: Int
}

public struct EngineViewFactory: Equatable {
    public var id: String
    public var factory: () -> UIView

    public init(
        id: String = UUID().uuidString,
        factory: @escaping () -> UIView
    ) {
        self.id = id
        self.factory = factory
    }

    func callAsFunction() -> UIView {
        return factory()
    }

    public static func == (lhs: EngineViewFactory, rhs: EngineViewFactory) -> Bool {
        lhs.id == rhs.id
    }
}

public enum EngineScrollState {
    case inert
    case startScrolling(CGPoint)
    case scrolling(start: CGPoint, current: CGPoint)
    case stoppedScrolling
}

public struct NavigationState {
    var canGoBack: Bool
    var canGoForward: Bool
}

public enum FindInPageAction {
    case updateQuery(String)
    case findNext(String)
    case findPrevious(String)
}

public enum EngineAction {
    case load(URLRequest)
    case goBack
    case goForward
    case findInPage(FindInPageAction)
}

public enum EngineEvent: Equatable {
    case startScrolling(CGPoint)
    case scrolled(CGPoint)
    case endScrolling(CGPoint)
    case updateEstimatedProgress(Double)
    case didStartProvisionalNavigation
    case didStartNavigation
    case didFinishNavigation
    case didNavigateBack
    case didNavigateForward
    case didReload
    case urlDidChange
    case pullToRefresh
    case themeColorChanged(Color)
    case updateFindInPageResults(FindInPageResults)
}

public struct Engine {
    public var viewFactory: EngineViewFactory
    public var dispatch: (EngineAction) -> Void
    public var events: AsyncStream<EngineEvent>
}

public extension Engine {
    static var test: Self {
        .init(
            viewFactory: EngineViewFactory(id: "test-factory") { UIView() },
            dispatch: { _ in },
            events: AsyncStream { _ in }
        )
    }

    static var system: Self {
        let webviewController = SystemWebViewController()

        return Engine(
            viewFactory: EngineViewFactory {
                webviewController.webView
            },
            dispatch: { action in
                switch action {
                case .load(let urlRequest): webviewController.load(urlRequest)
                case .goBack: webviewController.goBack()
                case .goForward: webviewController.goForward()
                case .findInPage(let action): webviewController.findInPage(action)
                }
            },
            events: webviewController.events
        )
    }
}

class FullScreenWKWebView: WKWebView {
    override var safeAreaInsets: UIEdgeInsets { .zero }
}

class SystemWebViewController: NSObject {
    private(set) var events: AsyncStream<EngineEvent>!
    private var continuation: AsyncStream<EngineEvent>.Continuation!
    private var subscriptions = Set<AnyCancellable>()

    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.websiteDataStore = .nonPersistent()

        configuration.userContentController.add(self, name: "findInPageHandler")
        let source = try! String(contentsOf: Bundle.module.url(forResource: "findInPage", withExtension: "js")!)
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)

        let view = WKWebView(frame: .zero, configuration: configuration)
        view.scrollView.delegate = self
        view.navigationDelegate = self
        view.allowsBackForwardNavigationGestures = true
        view.scrollView.contentInsetAdjustmentBehavior = .automatic
        view.allowsLinkPreview = true
        view.scrollView.clipsToBounds = false

        view.publisher(for: \.estimatedProgress)
            .sink { [weak self] in self?.continuation.yield(.updateEstimatedProgress($0)) }
            .store(in: &subscriptions)

        view.publisher(for: \.themeColor)
            .map { Color($0 ?? .blue) }
            .sink { [weak self] in
                self?.continuation.yield(.themeColorChanged($0))
            }
            .store(in: &subscriptions)

        return view
    }()

    override init() {
        super.init()
        self.events = AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    func goBack() {
        webView.goBack()
    }

    func goForward() {
        webView.goForward()
    }

    func load(_ request: URLRequest) {
        webView.load(request)
    }

    func findInPage(_ action: FindInPageAction) {
        let function: String
        let text: String

        switch action {
        case .updateQuery(let query):
            text = query
            function = "find"
        case .findNext(let query):
            text = query
            function = "findNext"
        case .findPrevious(let query):
            text = query
            function = "findPrevious"
        }

        let escaped = text.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
        print(escaped)
        webView.evaluateJavaScript("__firefox__.\(function)(\"\(escaped)\")", completionHandler: nil)
    }
}

extension SystemWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        continuation.yield(.didFinishNavigation)
    }
}

extension SystemWebViewController: WKUIDelegate {

}

extension SystemWebViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        continuation.yield(.scrolled(scrollView.contentOffset))
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        continuation.yield(.startScrolling(scrollView.contentOffset))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        continuation.yield(.endScrolling(scrollView.contentOffset))
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}


extension SystemWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let data = message.body as! [String : Int]
        print(data)

//        continuation.yield(.updateFindInPageResults(FindInPageResults(current: current, total: total)))
    }
}
