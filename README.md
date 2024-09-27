# node-sample-reactapp

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



# Errors
- <details><summary>Error: EACCES: permission denied, mkdir '/etc/todos'</summary>
Run below command to resolve the error
`````` sudo npm install -g --unsafe-perm=true --allow-root `````` </details>
