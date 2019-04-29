workflow "Build and Publish" {
  on = "push"
  resolves = "Build"
}

action "Shell Lint" {
  uses = "actions/bin/shellcheck@master"
  args = "entrypoint.sh bin/*"
}

action "Docker Lint" {
  uses = "docker://replicated/dockerfilelint"
  args = ["Dockerfile"]
}

action "Build" {
  needs = ["Shell Lint", "Docker Lint"]
  uses = "actions/docker/cli@master"
  args = "build -t npm ."
}

# action "Docker Tag" {
#   needs = ["Build"]
#   uses = "actions/docker/tag@master"
#   args = "npm github/npm --no-latest"
# }

# action "Publish Filter" {
#   needs = ["Build"]
#   uses = "actions/bin/filter@master"
#   args = "branch master"
# }

# action "Docker Login" {
#   needs = ["Publish Filter"]
#   uses = "actions/docker/login@master"
#   secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
# }

# action "Docker Publish" {
#   needs = ["Docker Tag", "Docker Login"]
#   uses = "actions/docker/cli@master"
#   args = "push github/npm"
# }
