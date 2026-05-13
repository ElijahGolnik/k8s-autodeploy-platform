# Stage 1: Build environment
# Using node image as builder
FROM node:18-alpine AS build

# Working dir
WORKDIR /app

# Copy over package files
COPY package*.json .

# Run dependency installs
RUN npm ci --omit=dev

# Copy application code
COPY server.js .

# Stage 2: Runtime environment
FROM node:18-alpine

# Create user again in secondary stage
RUN adduser -D appuser

# Secondary working dir
WORKDIR /app

# Copy over server.js code and changing ownership
COPY --from=build --chown=appuser:appuser /app/node_modules ./node_modules
COPY --from=build --chown=appuser:appuser /app/server.js .

# Expose our server.js port
EXPOSE 5000

# Swapping to non-root user for security
USER appuser

# Platform basic executables
CMD ["node", "server.js"]