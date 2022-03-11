//
//  File.swift
//
//
//  Created by Finn Behrens on 02.03.22.
//

import ArgumentParser
import Foundation
import MatrixClient

extension Mcc.Auth {
    struct Options: ParsableArguments {
        @Option(name: .long, help: "The homeserver to use.")
        var homeserver: String?

        @Option(name: .shortAndLong, help: "The userid to use.")
        var userID: String?

        @Option(name: .shortAndLong, help: "Token to use")
        var token: String?

        @Option(name: .long, help: "Device id")
        var deviceID: String?

        // MARK: - dynamic variables

        var homeserverConfig: String? {
            if let homeserver = homeserver {
                return homeserver
            }
            return Config.homeServer
        }

        var homeserverThrow: String {
            get throws {
                if let homeserverConfig = homeserverConfig {
                    return homeserverConfig
                }
                throw MatrixError.NotFound
            }
        }

        var userIDConfig: String? {
            if let userID = userID {
                return userID
            }
            return Config.userID
        }

        var userIDThrow: String {
            get throws {
                if let userIDConfig = userIDConfig {
                    return userIDConfig
                }
                throw MatrixError.NotFound
            }
        }

        var tokenConfig: String? {
            if let token = token {
                return token
            }
            return Config.token
        }

        var deviceIDConfig: String? {
            if let deviceID = deviceID {
                return deviceID
            }
            return Config.deviceID
        }
    }
}
