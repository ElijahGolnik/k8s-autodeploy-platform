# Using node image
FROM node:18

# Working dir
WORKDIR /app

# Copy over package files
COPY package*.json ./

# Run dependency installs
RUN npm install

# Copy over the rest of the app
COPY . .

# Expose our server.js port
EXPOSE 5000

# Platform basic executables
CMD ["node", "server.js"]