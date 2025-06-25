//
//  MastgTest.swift
//  MASTestApp
//
//  Created by Charlie on 28.04.24.
//

import SwiftUI
import os.log

struct MastgTest {
    
    static func mastgTest(completion: @escaping (String) -> Void) {
            let r = DemoResults(testId: "0000")

            do {
                let sensitiveString = "Hello from the OWASP MASTG Test app."

                // case 1: Demo implements a case which fails a test
                r.add(status: .fail, message: "The app implemented a demo which failed the test.")

                // case 2: Demo implements a case which passes a test
                r.add(status: .pass, message: "The app implemented a demo which passed the test with the following value: '\(sensitiveString)'")

                throw NSError(domain: "MastgTest", code: 1, userInfo: [NSLocalizedDescriptionKey: "Something went wrong during the demo."])
            }
            catch {
                // case 3: Demo fails due to an exception.
                r.add(status: .error, message: error.localizedDescription)
            }

            return completion(r.toJson())
        }
}
