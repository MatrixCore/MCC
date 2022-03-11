//
//  config.swift
//  mcc
//
//  Created by Finn Behrens on 11.03.22.
//

import ArgumentParser
import Foundation
import SwiftUI

public enum Config {
    static var userDefaults = UserDefaults.standard

    @AppStorage("homeserver")
    static var homeServer: String?

    @AppStorage("user_id")
    static var userID: String?

    @AppStorage("token")
    static var token: String?

    @AppStorage("device_id")
    static var deviceID: String?
}

public struct ConfigCommand: ParsableCommand {
    public init() {}

    public static var configuration = CommandConfiguration(
        commandName: "config",
        abstract: "Stored command config",
        version: "0.1.0",
        subcommands: [SetCommand.self]
    )

    public func run() async throws {
        print("homeserver: \(Config.homeServer ?? "none")")
        print("user_id: \(Config.userID ?? "none")")
        print("token: \(Config.token ?? "none")")
        print("device_id: \(Config.deviceID ?? "none")")
    }
}

extension ConfigCommand {
    struct SetCommand: ParsableCommand {
        @Option(name: .long, help: "The homeserver to use.")
        var homeserver: String?

        @Option(name: .long, help: "user id local part to use for login")
        var userID: String?

        public static var configuration = CommandConfiguration(
            commandName: "set"
        )

        public func run() async throws {
            if let homeserver = homeserver {
                Config.homeServer = homeserver
            }

            if let userID = userID {
                Config.userID = userID
            }
        }
    }
}
