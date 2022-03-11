//
//  File.swift
//
//
//  Created by Finn Behrens on 05.02.22.
//

import ArgumentParser
import Foundation
import MatrixClient
import os

extension Mcc.Auth {
    struct Login: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "login",
            abstract: "Login to a matrix homeserver"
        )

        @OptionGroup var options: Options

        @Option(name: .shortAndLong, help: "Password to log in with")
        var password: String

        @Flag()
        var noSave: Bool = false

        func run() async throws {
            let logger = Logger()
            let client = await MatrixClient(homeserver: try MatrixHomeserver(resolve: try options.homeserverThrow))

            logger.debug("resolved url: \(client.homeserver.url)")

            let info = try await client.getVersions()
            logger.debug("server has versions: \(info.versions)")

            if !(try await client.supportsPasswordAuth()) {
                logger.warning("Server does not support password authentication.")
                throw MatrixError.Forbidden
            }

            let login = try await client.login(
                username: try options.userIDThrow,
                password: password,
                deviceId: options.deviceIDConfig
            )
            print("user id: \(login.userId ?? "")")
            print("token: \(login.accessToken ?? "")")
            print("device id: \(login.deviceId ?? "")")

            if !noSave {
                Config.userID = login.userId
                Config.token = login.accessToken
                Config.deviceID = login.deviceId
                Config.homeServer = login.homeServer
            }
        }
    }

    struct Logout: ParsableCommand {
        @OptionGroup var options: Options

        @Option(name: .shortAndLong, help: "Token.")
        var token: String

        @Flag(name: .long, help: "Logout all devices.")
        var all = false

        func run() async throws {
            let logger = Logger()
            let client = await MatrixClient(homeserver: try MatrixHomeserver(resolve: try options.homeserverThrow))

            logger.debug("resolved url: \(client.homeserver.url)")

            let info = try await client.getVersions()
            logger.debug("server has versions: \(info.versions)")

            try await client.logout(all: all)
        }
    }
}
