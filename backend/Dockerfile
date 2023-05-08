FROM node:latest

WORKDIR /app

COPY ./package.json ./
COPY ./package-lock.json ./

RUN npm install

COPY . .

EXPOSE 5000

CMD ["node", "server.js" ]



# FROM node:latest: This line specifies the base image to use for the Docker container, which in this case is the latest version of the official Node.js image.

# WORKDIR /app: This sets the working directory to /app within the container, which is where the application will be installed and run.

# COPY ./package.json ./ and COPY ./package-lock.json ./: These lines copy the package.json and package-lock.json files from the local machine to the container. These files are needed to install the application's dependencies.

# RUN npm install: This installs the dependencies specified in package.json using the npm package manager.

# COPY . .: This copies the rest of the application files from the local machine to the container.

# EXPOSE 5000: This exposes port 5000 on the container, which is where the application will listen for incoming requests.

# CMD ["node", "server.js" ]: This specifies the command to run when the container is started, which in this case is to run the server.js file using the node command.