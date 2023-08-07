//
//  ChallengeView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI
import HopKit

import LibHopClient
import LibEngine

extension Journey {
    var clicks: Int { steps.count }
}

public struct ChallengeView: View {
    @Environment(\.engine) var engine
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.currentChallenge) var challenge
    @UseHopClient var hopClient
    @Binding var journey: Journey
    @State var searchQuery = ""
    @State var hasWon = false
    @State var showModal = false
    @State var showToast = false
    
    public init(journey: Binding<Journey>) {
        self._journey = journey
    }
    
    public var body: some View {
        let searchBarBackgroundColor = Color.black.opacity(0.75)
        let searchContainerBackgroundColor = Color.black.opacity(0.7)
        VStack {
            WebView(engineViewFactory: engine.viewFactory)
                .overlay(alignment: .topTrailing) {
                    if journey.clicks >= 0 {
                        Text("\(journey.clicks)")
                            .transition(.push(from: .leading).combined(with: .scale))
                            .id("click\(journey.clicks)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                    } else {
                        Text("0")
                            .transition(.push(from: .leading).combined(with: .scale))
                            .id("click\(journey.clicks)")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        TextField("Search", text: $searchQuery)
                            .foregroundColor(.white)
                            .disableAutocorrection(true)
                            .safeAreaInset(edge: .leading) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                                    .padding(0.5)
                                    .bold()
                            }
                            .accentColor(.white)
                            .padding(.all, 20)
                            .background(searchBarBackgroundColor)
                            .cornerRadius(55)
                            .font(.system(size: 20, weight: .heavy, design: .default))
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, -10)
                    .background(searchContainerBackgroundColor)
                }
                .onChange(of: hasWon) { hasWon in
                    showModal = hasWon
                }
                .onAppear {
                    guard let url = URL(string: "https://en.wikipedia.org/wiki/\(challenge.from.id)") else { return }
                    engine.dispatch(.load(URLRequest(url: url)))
                }
                .task {
                    for await event in engine.events {
                        if case EngineEvent.urlDidChange(let url) = event, let url {
                            withAnimation {
                                journey.steps.append(Step(date: .now, page: Page(id: url.lastPathComponent)))
                                hasWon = url.relativePath.contains(challenge.to.id) == true
                            }
                            if (hasWon) {
                                let userId = UUID(uuidString:"ff24d3a3-7740-4433-8e1f-f9d5d8eef1b5")!
                                let challengeId = UUID(uuidString: "319140d6-8fb3-42f9-be79-551ad7554aa0")!
                                do {
                                    try await hopClient.insertJourney(userId, challengeId, journey.clicks, journey.startedAt, Date.now)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                }
                .onChange(of: self.searchQuery) { query in
                    engine.dispatch(.findInPage(.updateQuery(query)))
                }
        }
        .sheet(isPresented: $showModal, onDismiss: {
            showModal = false
        }) {
            HasWonModal(showToast: $showToast, clicks: journey.clicks, from: challenge.from.title, to: challenge.to.title)
        }
    }
    
}

struct HasWonModal: View {
    @Binding var showToast: Bool
    let clicks: Int
    let from: String
    let to: String
    
    var body: some View {
        // Barbe -> Oppenheimer
        let shareText = "\(from) -> \(to) took me \(clicks) clicks, https://wikihop.app"
        
        VStack {
            Text("You did it")
            Text("It only took you...\(clicks) clicks").padding()
            Button(action: {
                UIPasteboard.general.string = shareText
                showToast = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showToast = false
                }
            }) {
                Text("Share")
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toast(isPresented: $showToast)
    }
}

extension View {
    func toast(isPresented: Binding<Bool>) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented))
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content

            if isPresented {
                ToastView().transition(.move(edge: .top))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
    
}

struct ToastView: View {
    var body: some View {
        Text("Copied to clipboard 🎉")
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
        
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(journey: .constant(.init(challengeId: UUID())))
    }
}
