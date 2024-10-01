# node-sample-reactapp
- [![JF-CLI - NPM publish & BuildInfo](https://github.com/krishnamanchikalapudi/node-sample-reactapp/actions/workflows/jfcli-npm.yml/badge.svg)](https://github.com/krishnamanchikalapudi/node-sample-reactapp/actions/workflows/jfcli-npm.yml)
- [![JF-CLI with Docker](https://github.com/krishnamanchikalapudi/node-sample-reactapp/actions/workflows/jfcli-docker.yml/badge.svg)](https://github.com/krishnamanchikalapudi/node-sample-reactapp/actions/workflows/jfcli-docker.yml)
- [![JF-CLI - Query properties](https://github.com/krishnamanchikalapudi/node-sample-reactapp/actions/workflows/jfcli-queryprop.yml/badge.svg)](https://github.com/krishnamanchikalapudi/node-sample-reactapp/actions/workflows/jfcli-queryprop.yml)

### Prerequisite
- Install JFrog CLI: [https://jfrog.com/getcli/](https://jfrog.com/getcli/
- JFrog CLI commands [documentation](https://docs.jfrog-applications.jfrog.io/jfrog-applications/jfrog-cli/install)
- Configure JFrog CLI with the artifactory using command
``````
jf c add --user=<USER_ID> --interactive=true --url=https://<SAAS_HOST>.jfrog.io --overwrite=true
``````

## Build project
### NPM
``````
./jf-cli.sh
``````
### run
``````
npm start
``````
### Docker
``````
./jf-docker.sh
``````
### run
``````
docker run -d --name node-sample-reactapp -p 7080:8080 ${orgName}/${imageName}:latest

``````


# Errors
- <details><summary>Error: EACCES: permission denied, mkdir '/etc/todos'</summary>
Run below command to resolve the error
`````` sudo npm install -g --unsafe-perm=true --allow-root `````` </details>
- <details><summary>Error: Dependencies lock file is not found in /home/runner/work/node-sample-reactapp/node-sample-reactapp. Supported file patterns: package-lock.json,npm-shrinkwrap.json,yarn.lock</summary>
`````` cache-dependency-path: package-lock.json `````` </details>