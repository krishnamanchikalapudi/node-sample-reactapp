# https://hub.docker.com/_/node
FROM psazuse.jfrog.io/krishnam-docker-virtual/node:20
WORKDIR /usr/local/app

COPY ./src ./src
COPY package.json ./
COPY *.sh ./

RUN npm config set cache temp
RUN chmod -R 777 * 

RUN ./jfcli-npm.sh

EXPOSE 3000
CMD [ "npm", "run dev"]