
 

# FROM node:14-slim

# WORKDIR /usr/src/app

# COPY ./package.json ./
# COPY ./package-lock.json ./

# RUN npm install

# COPY . .

# EXPOSE 5000

# CMD [ "npm", "start" ]


# Use a Node.js base image
FROM node:14.17.0-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire app directory to the container
COPY . .

# Build the React app
RUN npm run build

# Set the command to start the app
CMD ["npm", "start"]