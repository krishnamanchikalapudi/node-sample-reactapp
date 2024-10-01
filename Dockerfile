# https://hub.docker.com/_/node
FROM psazuse.jfrog.io/krishnam-docker-virtual/node:20
WORKDIR /usr/local/app

COPY ./src ./src
COPY ./node_modules ./node_modules

COPY package.json ./
COPY *.sh ./

RUN npm config set cache temp
RUN chmod -R 755 * 

RUN npm install

EXPOSE 3000
CMD [ "npm", "start"]