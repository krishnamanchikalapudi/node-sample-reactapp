clear
# TOKEN SETUP
# jf c add --user=krishnam --interactive=true --url=https://psazuse.jfrog.io --overwrite=true 

# Setting variables
export JF_RT_URL="https://psazuse.jfrog.io" JFROG_NAME="psazuse" JFROG_CLI_LOG_LEVEL="DEBUG" RT_REPO_NPM="krishnam-npm" RT_REPO_DOCKER="krishnam-docker" # JF_ACCESS_TOKEN="<GET_YOUR_OWN_KEY>"
export  BUILD_NAME="node-sample-reactapp-docker" BUILD_ID="cmd.$(date '+%Y-%m-%d-%H-%M')" 
echo " JFROG_NAME: $JFROG_NAME \n JF_RT_URL: $JF_RT_URL \n BUILD_NAME: $BUILD_NAME \n BUILD_ID: $BUILD_ID \n JFROG_CLI_LOG_LEVEL: $JFROG_CLI_LOG_LEVEL  \n"

# Config - Artifactory info
jf npmc --server-id-resolve ${JFROG_NAME} --server-id-deploy ${JFROG_NAME} --repo-resolve ${RT_REPO_NPM}-virtual --repo-deploy ${RT_REPO_NPM}-virtual

echo "\n\n**** NPM: Package ****\n\n"
# npm: Build
jf npm install --build-name=${BUILD_NAME} --build-number=${BUILD_ID}
# npm:publish
jf npm publish --build-name=${BUILD_NAME} --build-number=${BUILD_ID}

# Docker
### config
# export DOCKER_PWD="<GET_YOUR_OWN_KEY>" 
echo "\n DOCKER_PWD: $DOCKER_PWD \n "
docker login psazuse.jfrog.io -u krishnam -p ${DOCKER_PWD}

### Create image and push
echo "\n\n**** Docker: build image ****"
docker image build -f Dockerfile --platform linux/amd64,linux/arm64 -t psazuse.jfrog.io/${RT_REPO_DOCKER}-virtual/${BUILD_NAME}:${BUILD_ID} --output=type=image .

docker inspect psazuse.jfrog.io/${RT_REPO_DOCKER}-virtual/${BUILD_NAME}:${BUILD_ID} --format='{{.Id}}'

echo "\n BUILD_NAME: $BUILD_NAME \n BUILD_ID: $BUILD_ID \n JFROG_CLI_LOG_LEVEL: $JFROG_CLI_LOG_LEVEL  \n RT_PROJECT_REPO: $RT_PROJECT_REPO \n RT_REPO_DOCKER: $RT_REPO_DOCKER \n "

#### Tag with latest also
# docker tag psazuse.jfrog.io/krishnam-docker-virtual/${BUILD_NAME}:${BUILD_ID} psazuse.jfrog.io/krishnam-docker-virtual/${BUILD_NAME}:latest 

### Docker Push image
echo "\n\n**** Docker: jf push ****"
jf docker push psazuse.jfrog.io/${RT_REPO_DOCKER}-virtual/${BUILD_NAME}:${BUILD_ID} --build-name=${BUILD_NAME} --build-number=${BUILD_ID} --detailed-summary=true


## bdc: build-docker-create, Adding Published Docker Images to the Build-Info 
echo "\n\n**** Docker: build create ****"
export DKR_MANIFEST="list-manifest-${BUILD_ID}.json" SPEC_BP_DOCKER="dockerimage-file-details-${BUILD_ID}" 
jf rt curl -XGET "/api/storage/${RT_REPO_DOCKER}-virtual/${BUILD_NAME}:${BUILD_ID}/list.manifest.json" -H "Authorization: Bearer ${JF_ACCESS_TOKEN}"

export imageSha256=$(jf rt curl -XGET "/api/storage/${RT_REPO_DOCKER}-virtual/${BUILD_NAME}:${BUILD_ID}/list.manifest.json" | jq -r '.originalChecksums.sha256')
jf rt curl -XGET "/api/storage/${RT_REPO_DOCKER}-virtual/${BUILD_NAME}/${BUILD_ID}/list.manifest.json" -H "Authorization: Bearer ${JF_ACCESS_TOKEN}" -o "${DKR_MANIFEST}"
imageSha256=`cat ${DKR_MANIFEST} | jq -r '.originalChecksums.sha256'`

echo ${imageSha256}
echo ${JF_RT_HOST}/${RT_REPO_DOCKER}-virtual/${BUILD_NAME}:${BUILD_ID}@sha256:${imageSha256} > ${SPEC_BP_DOCKER}
jf rt bdc ${RT_REPO_DOCKER}-virtual --image-file ${SPEC_BP_DOCKER} --build-name ${BUILD_NAME} --build-number ${BUILD_ID} 



echo "\n\n**** Build Info ****\n\n"
# build: bce:build-collect-env 
jf rt bce ${BUILD_NAME} ${BUILD_ID}
## build: bag:build-add-git
jf rt bag ${BUILD_NAME} ${BUILD_ID}
# Build:publish
jf rt bp ${BUILD_NAME} ${BUILD_ID} --detailed-summary=true



# clean
echo "\n\n**** CLEAN UP ****\n\n"
rm -rf package-lock.json
rm -rf .jfrog
rm -rf ${DKR_MANIFEST}
rm -rf ${SPEC_BP_DOCKER}
echo "\n\n**** DONE ****\n\n"