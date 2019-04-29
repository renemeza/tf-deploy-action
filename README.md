# Serverless actions

Actions for release and deploy serverless infrastructure

## Usage

Use in conjuction with https://github.com/unacast/actions/tree/master/github-deploy action to get the deployment environment and to start and complete the deployment.

Yuo can pass one of the following arguments

- `deploy` - To deploy the serverless configuration
- `release` - This argument creates a serverless package to be used by the `deploy` script

```
workflow "Release and Deploy" {
  on = "deployment"
  resolves = [
    "End Deployment",
  ]
}

action "Filter deleted branches" {
  uses = "UltCombo/action-filter-deleted-branches@master"
}

action "Add deploy scripts" {
  needs = "Filter deleted branches"
  uses = "unacast/actions/github-deploy@master"
}

action "Init deployment" {
  needs = "Add deploy scripts"
  uses = "docker://byrnedo/alpine-curl"
  runs = "/github/home/bin/deployment-create-status pending"
}

action "Release" {
  needs = "Init deployment"
  uses = "getndazn/serverless-action"
  args = "release"
  secrets = [
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "NPM_AUTH_TOKEN",
  ]
  env = {
    AWS_REGION = "us-east-1"
  }
}

action "Deploy" {
  needs = "Release"
  uses = "getndazn/serverless-action"
  args = "deploy"
  secrets = [
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "NPM_AUTH_TOKEN",
  ]
  env = {
    AWS_REGION = "us-east-1"
  }
}

action "End Deployment" {
  needs = "Deploy"
  uses = "docker://byrnedo/alpine-curl"
  runs = "/github/home/bin/deployment-create-status success"
}
```

### Copy the scripts

In order to make the scripts available to use inside other actions you can copy the scripts, To copy the scripts to the `$HOME/sls-deploy-action` pass the `COPY_SCRIPTS` environment variable and set it to `true`, this will allow the action to use the scripts as arguments and also make those available to other actions.

If you want to only copy the scripts you can pass the `COPY_SCRIPTS_ONLY` variable and set to `true`, this will copy the scripts only, this way you can not use the arguments.

```
# To copy and run the scripts
action "Release" {
  uses = "renemeza/sls-deploy-action@master"
  env = {
    COPY_SCRIPTS = "true"
  }
  args = "release"
}

# To only copy the scripts
action "Add Serverless deploy scripts" {
  uses = "renemeza/sls-deploy-action@master"
  env = {
    COPY_SCRIPTS_ONLY = "true"
  }
}
```

You can customize the directory where the scripts are going to be copied by passing the environment variable `COPY_SCRIPTS_DIR` with the name of the directory.

```
action "Add Serverless deploy scripts" {
  uses = "renemeza/sls-deploy-action@master"
  env = {
    COPY_SCRIPTS_ONLY = "true"
    COPY_SCRIPTS_DIR = "scripts"
  }
}
```

This will copy the scripts to `$HOME/scripts`.
