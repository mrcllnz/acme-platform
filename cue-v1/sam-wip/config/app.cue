package main

import (
	"b.l/bl"
	"b.l/templates/yarn"
	"b.l/templates/netlify"
)

// A single instance of an Acme Clothing application
App :: bl.Block & {
	settings: {
		hostname:        string
		netlifySiteName: string
	}

	keychain: netlifyToken: string
	connection: [
		// Connect my own input to "frontend"
		{
			fromDir: "crate/code/web"
			to:      "frontend"
		},
	]
	input: true

	block: frontend: {
		connection: [
			// Connect my own input to "build"
			{
				from: "."
				to:   "build"
			},
			// Connect "build" output to "deploy"
			{
				from: "build"
				to:   "deploy"
			},
		]
		block: {
			hostname = settings.hostname
			netlifySiteName = settings.netlifySiteName
			netlifyToken = keychain.netlifyToken

			build: yarn & {
				settings: {
					writeEnvFile: ".env"
					loadEnv:      false
					environment: {
						NODE_ENV: "production"
						APP_URL:  "https://\(hostname)"
					}
					buildDirectory: "public"
					buildScript:    "build:client"
				}
			}
			deploy: netlify & {
				settings: {
					createSite: true
					domain:     hostname
					siteName:   netlifySiteName
				}
				keychain: token: netlifyToken
			}
		}
	}
}