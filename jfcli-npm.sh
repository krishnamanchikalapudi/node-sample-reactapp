clear
# TOKEN SETUP
# jf c add --user=krishnam --interactive=true --url=https://psazuse.jfrog.io --overwrite=true 

# Setting variables
export JF_RT_URL="https://psazuse.jfrog.io" JFROG_NAME="psazuse" RT_REPO="krishnam-npm"  JFROG_CLI_LOG_LEVEL="DEBUG" # JF_ACCESS_TOKEN="<GET_YOUR_OWN_KEY>"
export  BUILD_NAME="node-sample-reactapp" BUILD_ID="cmd.$(date '+%Y-%m-%d-%H-%M')" 
echo " JFROG_NAME: $JFROG_NAME \n JF_RT_URL: $JF_RT_URL \n BUILD_NAME: $BUILD_NAME \n BUILD_ID: $BUILD_ID \n JFROG_CLI_LOG_LEVEL: $JFROG_CLI_LOG_LEVEL  \n"

# Config - Artifactory info
jf npmc --global --server-id-resolve ${JFROG_NAME} --server-id-deploy ${JFROG_NAME} --repo-resolve ${RT_REPO}-virtual --repo-deploy ${RT_REPO}-virtual


echo "\n\n**** NPM: Package ****\n\n"
# npm: install
jf npm install --build-name=${BUILD_NAME} --build-number=${BUILD_ID} 
# npm:publish
jf npm publish --build-name=${BUILD_NAME} --build-number=${BUILD_ID}


echo "\n\n**** Build Info ****\n\n"
# build: bce:build-collect-env 
jf rt bce ${BUILD_NAME} ${BUILD_ID}
## build: bag:build-add-git
jf rt bag ${BUILD_NAME} ${BUILD_ID}
# Build:publish
jf rt bp ${BUILD_NAME} ${BUILD_ID} --detailed-summary=true


# set-props
echo "\n\n**** Props: set ****\n\n"
jf rt sp "env=demo;org=ps;team=arch;pack_cat=webapp;ts=ts-${BUILD_ID}" --build="${BUILD_NAME}/${BUILD_ID}"

sleep 10
# Query props
echo "\n\n**** Query by prop ****\n\n"
jf rt curl "/api/search/prop?repos=${RT_REPO}-virtual&team=arch&env=demo"

echo "\n\n**** Query by prop build.name ****\n\n"
jf rt curl "/api/search/prop?repos=${RT_REPO}-virtual&build.name=${BUILD_NAME}"


# clean
rm -rf package-lock.json
rm -rf .jfrog
rm -rf temp

echo "\n\n**** DONE ****\n\n"