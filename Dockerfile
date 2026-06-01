# Use official Node.js LTS image with minimal Alpine base (reduces attack surface)
FROM node:20-alpine

# Run as non-root user for security (node user exists in node:alpine images)
USER node

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package files with correct ownership
COPY --chown=node:node package*.json ./

# Use npm ci for deterministic, clean installs from package-lock.json
RUN npm ci --only=production

# Copy the rest of the application code with correct ownership
COPY --chown=node:node . .

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run the application
CMD ["node", "server.js"]
