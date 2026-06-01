# ── Stage 1: Builder ──────────────────────────────────────────────────────────
# Install dependencies in a separate stage to keep the final image clean
FROM node:20-alpine AS builder

# Update npm to latest to patch vulnerabilities in npm's own dependencies
# (tar, pacote, minimatch, glob, brace-expansion, cross-spawn)
RUN npm install -g npm@latest

WORKDIR /usr/src/app

# Copy lockfile and manifest, then install only production dependencies
COPY --chown=node:node package*.json ./
RUN npm ci --only=production

# ── Stage 2: Runtime ──────────────────────────────────────────────────────────
# Use a fresh minimal image — does NOT include npm or its vulnerable deps
FROM node:20-alpine

# Run as non-root user
USER node

WORKDIR /usr/src/app

# Copy only the app code and production node_modules from builder stage
COPY --chown=node:node --from=builder /usr/src/app/node_modules ./node_modules
COPY --chown=node:node . .

# Expose app port
EXPOSE 3000

# Start the app directly with node (not npm)
CMD ["node", "server.js"]
