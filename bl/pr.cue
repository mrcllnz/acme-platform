package main

import (
	"b.l/bl"
	"stackbrew.io/github"
)

// Environment to deploy a full review environment for each pull request on the monorepo,
// then post its URL as a comment on the pull request.
env: prReview: {

	input: {
		prNumber: int | *0
		// If we are triggered by a webhook, get the PR number from the payload
		if (env.devInfra.input.githubEvents.number & int) != _|_ {
			prNumber: env.devInfra.input.githubEvents.number
		}
	}

	debug: bl.BashScript & {
		environment: num: "pr-\(input.prNumber).dev.acme.infralabs.io"
		code: "echo $num"
	}

	output: {
		"PR \(config.pr.number) URL":     config.deploy.web.url
		"PR \(config.pr.number) API URL": config.deploy.api.url
	}

	config: {
		monorepo = env.devInfra.config.monorepo

		pr: monorepo.GetPullRequest & {
			number: input.prNumber
		}

		checkout: github.CheckoutPullRequest & {
			pullRequest: pr.pullRequest
			token: monorepo.token
		}

		commentDetails = #"""
				##### Details
				* **repository**: \#(pr.pullRequest.headRepository.url)
				* **branch**: `\#(pr.pullRequest.headRef.name)`
				* **commit**: \#(pr.pullRequest.headRef.target.oid)
				"""#
		addComment: github.AddComment & {
			token:     env.devInfra.input.githubToken
			subjectId: pr.pullRequest.id
			body:      #"""
				#### :rocket: ACME Deployment in Progress

				\#(commentDetails)
				"""#
		}

		deploy: env.devInfra.Deployment & {
			source: checkout.out
			web: hostname: "pr-\(input.prNumber).dev.acme.infralabs.io"
			api: hostname: "pr-\(input.prNumber).dev.acme-api.infralabs.io"
			web: site: name: "acme-pr-\(input.prNumber)"
		}

		// Since this task depends on `deploy.web.url`, it won't fire unless the deployment
		updateComment: github.UpdateComment & {
			commentId: addComment.comment.id
			token:     env.devInfra.input.githubToken
			body:      #"""
				#### :white_check_mark: ACME Deployment Completed!

				The deployment is live at \#(deploy.web.url)

				\#(commentDetails)
				"""#
		}
	}
}
