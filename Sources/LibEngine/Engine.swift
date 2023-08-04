import Combine
import WebKit
import SwiftUI

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

public enum EngineAction {
    case load(URLRequest)
    case goBack
    case goForward
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
