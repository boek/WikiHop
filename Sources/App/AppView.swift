//
//  AppView.swift
//  
//
//  Created by Jeff Boek on 8/4/23.
//

import SwiftUI

import FeatureOnboarding
import FeatureHome

struct AppView: View {
    @State var hasOnboarded = false
    var body: some View {
        if hasOnboarded {
            HomeView()
        } else {
            OnboardingView {
                self.hasOnboarded.toggle()
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
