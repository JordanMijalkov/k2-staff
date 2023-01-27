//
//  PassKitHelper.swift
//  Runner
//
//  Created by Apple Star on 4/25/22.
//

import Foundation
import PassKit

@objc public class PassKitHelper:NSObject {
    private static var tokenPKSuppresion:PKSuppressionRequestToken!;
    
    public static func suppressApplePay() {
        if #available(iOS 9, *) {
            if( PKPassLibrary.isPassLibraryAvailable() && !PKPassLibrary.isSuppressingAutomaticPassPresentation()) {
                tokenPKSuppresion = PKPassLibrary.requestAutomaticPassPresentationSuppression(responseHandler: { (result) in
                    if result == PKAutomaticPassPresentationSuppressionResult.success {
                        print("Automatic Pass Presentation suppressed")
                    }
                    else {
                        print("Could not suppress Automatic Pass Presentation")
                    }
                })
            }
        }
    }
    
    public static func enableApplePay() {
        if #available(iOS 9, *) {
            if( PKPassLibrary.isPassLibraryAvailable() && PKPassLibrary.isSuppressingAutomaticPassPresentation()) {
                PKPassLibrary.endAutomaticPassPresentationSuppression(withRequestToken: tokenPKSuppresion)
                print("Automatic Pass Presentation enabled")
            }
        }
    }
}
