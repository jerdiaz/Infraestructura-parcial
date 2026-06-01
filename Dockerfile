# Use official Node.js LTS with minimal Alpine base
FROM node:20-alpine

# Update npm to latest version to patch its bundled vulnerable dependencies:
# - tar: Symlink Attack + Directory Traversal
# - pacote: Denial of Service
# - minimatch: ReDoS + Inefficient Algorithmic Complexity
# - glob: Command Injection
# - cross-spawn: Regular Expression DoS
# - brace-expansion: Infinite loop
RUN npm install -g npm@latest && npm cache clean --force

# Run as non-root user (principle of least privilege)
USER node

# Set working directory
WORKDIR /usr/src/app

# Copy only the application file (no external dependencies needed)
COPY --chown=node:node server.js .

# Expose app port
EXPOSE 3000

# Start with node directly (better signal handling than npm start)
CMD ["node", "server.js"]
