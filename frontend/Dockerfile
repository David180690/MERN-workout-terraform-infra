

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

EXPOSE 3000

# Set the command to start the app
CMD ["npm", "start"]