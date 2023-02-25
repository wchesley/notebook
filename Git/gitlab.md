# Gitlab

- [Gitlab Docs](https://docs.gitlab.com/)

## TO-DO:
- Terraform state management
  - https://microfluidics.utoronto.ca/gitlab/help/user/infrastructure/iac/terraform_state.md
  - https://gitlab.com/gitlab-org/configure/examples/gitlab-terraform-aws/-/blob/master/.gitlab-ci.yml
  
- pushing large changes wont' go through pubulic internet. Issue *should* lie with nginx hosted in cloud. See [this stackoverflow post](https://stackoverflow.com/questions/7489813/github-push-error-rpc-failed-result-22-http-code-413) for more. 
  - Have tested with client_max_body_size set to 100M, still wouldn't go through: http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size
  - workaround: set a branch pointing to local IP of gitlab instance. I just named mine local_master for working with this repo. 

## Runner over SSH

- [pulled from stackoverflow](https://stackoverflow.com/questions/39208420/how-do-i-enable-cloning-over-ssh-for-a-gitlab-runner)

### option 1: 

I had a similar problem that necessitated the use of cloning via ssh: using the virtualbox executor with very old guest linux OSes. I was able to get around it by doing a few small configuration changes:

    Create a deploy key for access to the project.

    Force the user account that will perform the clone to use the deploy key. In my virtualbox case, I modified the ssh configuration for the user that's configured for virtualbox in /etc/gitlab-runnner/config.toml.

~/.ssh/config

Host gitlab.example.com
  Preferredauthentications publickey
  IdentityFile ~/.ssh/deploy-key

    Configure the runner to perform the clone via ssh in /etc/config.toml.

/etc/config.toml
```toml
[[runners]]

  # [...]

  environment = ["GIT_STRATEGY=none"]
  pre_build_script = '''
    # Fetching using ssh (via pre_build_script in config.toml)
    if [ -d "${CI_PROJECT_DIR}" ]; then rm -rf "${CI_PROJECT_DIR}"; fi
    mkdir -p "${CI_PROJECT_DIR}"
    cd "${CI_PROJECT_DIR}"
    git init
    git remote add origin "ssh://git@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git"
    git fetch origin "${CI_COMMIT_SHA}"
    git reset --hard FETCH_HEAD
  '''

  # [...]
```
Here's a breakdown of the additions to config.toml:

* The GIT_STRATEGY=none environment variable disables the runner's internal git cloning mechanism. (See the Git Strategy section of the CI/CD reference)
* The pre_build_script performs the actual clone using predefined CI/CD environment variables. In my case, this is a bash script to perform something similar to what a GIT_STRATEGY=fetch might do.
* If pre_build_script is multi-line, the output of the runner will only show the first line. Having a comment as the first line helps add clarity to the runner output.
* pre_clone_script is not used here. It's disabled since the environment has GIT_STRATEGY=none set.

### option 2: 

As a newcomer to gitlab, I've managed to hack a workaround to this issue as I also haven't found a built-in way to change the default cloning process (although [here is a recent comment about how it can be done](https://gitlab.com/gitlab-org/gitlab-ce/issues/22723#note_47011803)).

By [disabling the automatic cloning process](https://gitlab.com/gitlab-org/gitlab-runner/issues/1884#note_18695580), you can effectively override its behavior completely by simply writing your own cloning process in a before_script. Only for the purposes of example does the below show how to accomplish this for HTTP cloning but could be adapted for ssh cloning ([if you're trying to use HTTP cloning you should use the built-in cloning process and the config.toml](https://gitlab.com/gitlab-org/gitlab-runner/issues/3055#note_59363250)):

Create a new user called "gitlab-runner" and generate their user auth token for later use (or in your case, you would generate ssh keys).

Disable cloning process for runner by adding the following variable in either your project or group settings: .../settings/ci_cd

    key: GIT_STRATEGY

    value: none

Clone your repo in a before_script such as:
```yml
before_script:
  ## clean the working directory
  -  BUILD_DIR=/home/gitlab-runner/builds/$RUNNER_TOKEN/0 
  -  CLONE_DIR="$BUILD_DIR/$CI_PROJECT_PATH" 
  -  cd $BUILD_DIR 
  -  rm -rf $CLONE_DIR 
  -  mkdir -p $CLONE_DIR 

  ## clone the project each time (inefficient, consider performing fetch instead if it already exists)
  -  git clone http://gitlab-runner:$GITLABRUNNER_USER_AUTH_TOKEN@server:8888/${CI_PROJECT_PATH}.git $CLONE_DIR 
  -  cd $CLONE_DIR 
```
Note: Here are the relevant variables I also configured in step 2 rather than hard coding them in the script:

    RUNNER_TOKEN: "Runner Token" value listed in the Admin "Runners" menu for the particular runner you are trying to run.
    GITLABRUNNER_USER_AUTH_TOKEN: This is the auth token you generated in step 1.

Further Reading:

You can avoid the fake account approach taken above by instead issuing Deploy Keys. Or if security implications of access to any project is a concern, Deploy Tokens are an alternative with more security control. For comparison, see the docs:

    Deploy keys are shareable between projects that are not related or don’t even belong to the same group. Deploy tokens belong to either a project or a group.

    A deploy key is an SSH key you need to generate yourself on your machine. A deploy token is generated by your GitLab instance, and is provided to users only once (at creation time).

    A deploy key is valid as long as it’s registered and enabled. Deploy tokens can be time-sensitive, as you can control their validity by setting an expiration date to them.

    You can’t log in to a registry with deploy keys, or perform read / write operations on it, but this is possible with deploy tokens. You need an SSH key pair to use deploy keys, but not deploy tokens.

