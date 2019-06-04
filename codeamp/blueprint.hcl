run git clone backend {
	src = "https://github.com/codeamp/circuit.git"
}

run path copytree k8s {
    // FIXME: sorry, this is temporary (to take an artefacts on the local fs)
    // It converts a string (input) to a fstree (output)
    src = "/Users/shad/forks/prototypes/34-dredd/examples/codeamp"
    path = "backend-k8s"
}

run docker build backend {
	src = git.clone.backend.tree
}

run docker push backend {
    image = docker.build.backend.image
    name = "gcr.io/deploy-test-231020/circuit"
    tag = git.clone.backend.commit
    gcloud-config = gcloud.auth.config.gcloud-config
    docker-config = gcloud.auth.config.docker-config
}

run kubernetes kustomize backend {
    src = path.copytree.k8s.tree
    build-path = "overlays/staging"
    image = docker.push.backend.full-name
}

run gcloud auth config {
    project = "deploy-test-231020"
    region = "us-west2"
    // FIXME: manage secrets
    service-key = "ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiZGVwbG95LXRlc3QtMjMxMDIwIiwKICAicHJpdmF0ZV9rZXlfaWQiOiAiZGQxY2VmMDM2YmRkNDk5ZGJhYTc3OTBhYThkMDhlNjRhODY3OTc0MyIsCiAgInByaXZhdGVfa2V5IjogIi0tLS0tQkVHSU4gUFJJVkFURSBLRVktLS0tLVxuTUlJRXZnSUJBREFOQmdrcWhraUc5dzBCQVFFRkFBU0NCS2d3Z2dTa0FnRUFBb0lCQVFDcmNPQSszS0dCY28wZlxuWW9naGp2aTRUdE05Vk83WmdLNzR6bGVJMkFvZW8wWU1oSVpnMWVRSmhYbGJYU0lzV1NROFcvZnJEd2NGZHR3WlxuYnZYRjkvMXkvcEJ5a2pWVmd5L1RZdExCZUZaZmFpZU5taGZQajltZ1l2SlFPZ1hvUUZJbUdrT1lrOTc5d29EZlxucmNFaHVCS1gzb1BzV1I3OTBnWmpvd3ZIRUt4alp5Q0w5bmlsMUpqcmdVYzFuQzRjTFg1WDdtK3B2Tm1tQVluVFxuSFVPMDJ3SjF5SDVmQUd3NzJNVGw0QTNhZ3hLeGs2ZUJJcjExTlhaUWxtZGdTRXZrL1dyUUk0MEF4d3padGdmWVxuS2ZOZzRPWVJnSEtoYjc4djRjTHd3azN0V0FTKy8zK1ZGNXJ0K1BhSHl4TzljY1NadnVPNUxzSTkzWTY5K0loWVxuKys0ZDJKMTVBZ01CQUFFQ2dnRUFFRTVKMGNqSHhxbFh3VXlza0c2Sit2T3FWVHJEQmVaZW5mVDRMK0NHWStBWlxuSFQ4c2pjRENNZUtqUm55Tzc4Tmh0aWowSlVQMlliOXFrek94eGd5K2F5WEpwTkFCcVJxelhZcFlhOFRQaUQ4dlxuT0dGWDB1ckdZdUlPVkhHVVZzRHBYMHpmc1g4YzlpczkrU2hNUm5IOHVMdVY5aENLNlU3RXcwekNaY0pROXhvelxuYUFpU3VzeFhHcWR6aS84R0psbjlmaHhLS1JCVUgzSFJMaExjYkdpNlY3ckVxMmR2RlhFT2ZEYVV4MXZmK2hsRlxueVd2cERIMjFPQTEwejZGTU9ScTZSZkRZK1FhOFF1eXNhSlF4TklwTXZDcTJra1VweDhaRm1idTM1WTJRVnhVcVxuUm5oNG5GcWdnMHJXQWRmNldUVGIzSjBuNTJHT0pGN2ViYVE1QkMwNFFRS0JnUUR4SWp6WnQ5TFZkWmdNVCtqbVxuc0FhbVdFZy94c3lIWmhIQk5FTDY3cGcrK1BGOWNBcFI3bEZZTW9RckZrU1hZVkdTVytzTGJFa3dXdUU0SVRHRlxuQkxiMEZSU25uNUYyaFVEeFRSYytFK0dxQjFXK2RPdDlhdnMySFlhM3hRRUh6ZU5zMDUzNUhuNTVsV0QzbXNxUVxubE1CM1BLdFhMUlo4Q2hIM3B0MkQyb0lqNFFLQmdRQzJBckQrM1VuYkUzdis5OG5zVXVzdmc4cHcyRVZ4RFNWTlxubVlCcHJsZHVtNXRucElIZi9RdmppOXRvb0d5MmVkeTBzZEszTkJaWjZMNHgzSEhJclVudDBSTzVyUlBsNEVYWVxuQTVRcmdFc1hCRFFaWEdlcmlaS2VSNW9hbmpFbGVOTlN6eWx3ZmhQK0wvNjRUQUxrL2oxVWZnZy9sTUlLZ0lXRFxudjMyK0ZMYXNtUUtCZ1FEblVFUzNSaFBHR1N4bWd6R1VPai9teXNGa0RMeWZGbGJwMDh4OUV1eVJYQldza3hJVFxuVGw1U0VRT2dvWmZpNzhSa2RqQ2ZvSjBFK2VrYkF4eVIwZGYvaFVsdkV5OWpWcWpaMFczK2F1d0xRMFlKa2ZkbFxuTkg4UGhudDVSazZhd2ZMc3JvUFlPbHh4SGM4TE56NGlPOC8xa2dsN2N4RWlwRFpnTDM1SHdoRWRnUUtCZ0dQQlxuOWVDNnlOQWFUY3ZoWS9yek41UkRWNkdoNSsyZWx1T0JUckNkcmE0aCszdEMzeXcxTlY3eU9MK1ByZ1lWcExJbFxuQktrRkUzc1Q1YXJPZUU3Vks3Lzg2Q0xNaWl0a1VPT2trb0dGUDZMTjJ3QkxkVWEva0d6UU1kYUUvY3JiL25kVVxudEJIRUNKRTVIUk5HRmhBTWlQRFdZdzcyS2FRMzdQWFk3c0pQK0ErQkFvR0JBSmtJR0RKVmZRanV0dlFPUkR4UFxualJLU0dENFNMS2VWdEJGRDgrRkc5SU1EOEtWQ0NJNnVyS3EyTDV3OWhWN0pLY1R5aXIxRVBJZzM3WUg0THlOYlxuaGwwUGlIcWwzdEw5dGFBK05zOWNoZGdkc0Y3NURaeTBDK0QwbDY5UmZmUThkWEh3SzA3aXpzTUdFdnRpSXVVelxuNTI4djdBTTRscVU5QmpPdkpEdWErelNDXG4tLS0tLUVORCBQUklWQVRFIEtFWS0tLS0tXG4iLAogICJjbGllbnRfZW1haWwiOiAiYnVpbGRraXRlQGRlcGxveS10ZXN0LTIzMTAyMC5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsCiAgImNsaWVudF9pZCI6ICIxMTYzOTQyODkyOTA2OTc4MTIwODEiLAogICJhdXRoX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvYXV0aCIsCiAgInRva2VuX3VyaSI6ICJodHRwczovL29hdXRoMi5nb29nbGVhcGlzLmNvbS90b2tlbiIsCiAgImF1dGhfcHJvdmlkZXJfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9vYXV0aDIvdjEvY2VydHMiLAogICJjbGllbnRfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9yb2JvdC92MS9tZXRhZGF0YS94NTA5L2J1aWxka2l0ZSU0MGRlcGxveS10ZXN0LTIzMTAyMC5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIKfQo="
    kubernetes-cluster = "cluster"
}

// FIXME: namespace from arguments?
run kubernetes deploy backend {
    src = kubernetes.kustomize.backend.tree
    namespace = "codeamp-staging"
    kubernetes-config = gcloud.auth.config.kubernetes-config
    gcloud-config = gcloud.auth.config.gcloud-config
}

run git clone frontend {
    src = "https://github.com/codeamp/panel.git"
}

run path copyfile frontend-buildenv {
    // FIXME: sorry, this is temporary (to take an artefacts on the local fs)
    // It converts a string (input) to a file (output)
    src = "/Users/shad/forks/prototypes/34-dredd/examples/codeamp"
    path = "frontend-buildenv"
}

run npm build frontend {
    src = git.clone.frontend.tree
    envfile = path.copyfile.frontend-buildenv.file
}

run netlify deploy frontend {
    src = npm.build.frontend.tree
    site-id = "ae6690b8-6b87-4bdf-8600-b2af21b968a5"
    // FIXME: should be a secret
    auth-token = "2be167a5ac0b2f56ef90f7ad363cffee35dbc57f934089a2542037e2d3c8bf84"
}
