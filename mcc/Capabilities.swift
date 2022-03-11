//
//  Capabilities.swift
//  mcc
//
//  Created by Finn Behrens on 11.03.22.
//

import ArgumentParser
import Foundation
import MatrixClient
import os

struct Capabilities: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "capabilities"
    )

    @OptionGroup var options: Mcc.Auth.Options

    func run() async throws {
        let logger = Logger()
        let client = await MatrixClient(
            homeserver: try MatrixHomeserver(resolve: options.homeserverConfig!),
            accessToken: options.tokenConfig!
        )

        logger.debug("resolved url: \(client.homeserver.url)")

        let info = try await client.getVersions()
        logger.debug("server has versions: \(info.versions)")

        let capabilities = try await client.getCapabilities()
        dump(capabilities)
    }
}
