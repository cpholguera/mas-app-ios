//
//  DemoResults.swift
//  MASTestApp
//
//  Created by Stefan on 20.05.2025.
//

import Foundation
import OSLog

enum Status: String, Codable {
  case fail = "FAIL"
  case pass = "PASS"
  case error = "ERROR"
}

struct DemoResult: Codable {
  let status: Status
  let demoId: String
  let message: String
}

class DemoResults {
  private let log: Logger
  private let demoId: String
  private var demoResults = [DemoResult]()

  init(demoId: String) {
    self.demoId = demoId
    self.log = Logger(
      subsystem: Bundle.main.bundleIdentifier!,
      category: "MAS-DEMO")
  }

  func add(status: Status, message: String) {
    demoResults.append(DemoResult(status: status, demoId: demoId, message: message))

    if(status == .pass){
      log.info("MASTG-DEMO-\(self.demoId) demonstrated a successful test: \(message)")
    }
    else if (status == .fail){
      log.info("MASTG-DEMO-\(self.demoId) demonstrated a failed test: \(message)")
    }
    else if (status == .error){
      log.error("MASTG-DEMO-\(self.demoId) failed: \(message)")
    }
  }

  func toJson() -> String {
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(demoResults) else {
      return "[]"
    }
    return String(data: data, encoding: .utf8) ?? "[]"
  }
}
