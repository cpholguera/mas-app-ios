//
//  DemoResults.swift
//  MASTestApp
//
//  Created by Stefan on 20.05.2025.
//

import Foundation
import os.log

enum Status: String, Codable {
    case fail = "FAIL"
    case pass = "PASS"
    case error = "ERROR"
}

struct DemoResult: Codable {
    let status: Status
    let testId: String
    let message: String
}

class DemoResults {
    private let testId: String
    private var demoResults = [DemoResult]()

    init(testId: String) {
        self.testId = testId
    }

    func add(status: Status, message: String) {
        let formattedTestId = "[MASTG-TEST-\(testId)]"
        os_log("%{public}@ %{public}@: %{public}@", log: .default, type: .debug,
               status.rawValue, formattedTestId, message)
        demoResults.append(DemoResult(status: status, testId: formattedTestId, message: message))
    }

    func toJson() -> String {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(demoResults) else {
            return "[]"
        }
        return String(data: data, encoding: .utf8) ?? "[]"
    }
}
