//
//  File.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import Foundation
import AuthenticationServices

public typealias AuthToken = String

public struct AuthClient {
    public var authorize: () async throws -> AuthToken

    public init(
        authorize: @escaping () async throws -> AuthToken
    ) {
        self.authorize = authorize
    }
}

class AuthController: NSObject, ASAuthorizationControllerDelegate {
    var onCompletion: ((Result<AuthToken, Error>) -> Void)?

    func authorize() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = []

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        onCompletion?(.success(""))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onCompletion?(.failure(error))
    }
}

public extension AuthClient {
    static var test: Self {
        AuthClient(authorize: { "my_awesome_token" })
    }

    static var live: AuthClient {
        return AuthClient(
            authorize: {
                let controller = AuthController()

                return try await withCheckedThrowingContinuation { continuation in
                    controller.onCompletion = { result in
                        switch result {
                        case .success(let token): continuation.resume(returning: token)
                        case .failure(let error): continuation.resume(throwing: error)
                        }
                    }

                    controller.authorize()
                }
            }
        )
    }
}
