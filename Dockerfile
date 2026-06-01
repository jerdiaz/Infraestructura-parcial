# ── Stage 1: Builder ──────────────────────────────────────────────────────────
# Update npm to latest version to patch its bundled vulnerable dependencies:
# tar (Symlink Attack, Directory Traversal), pacote (DoS), minimatch (ReDoS),
# glob (Command Injection), cross-spawn (ReDoS), brace-expansion (Infinite loop)
FROM node:20-alpine AS builder

RUN npm install -g npm@latest && npm cache clean --force

WORKDIR /usr/src/app

COPY --chown=node:node package*.json ./

# Install production dependencies (creates node_modules if any deps exist)
RUN npm ci --only=production && mkdir -p node_modules

# ── Stage 2: Runtime ──────────────────────────────────────────────────────────
# Clean minimal image — copies only app + node_modules, leaves out npm tooling
FROM node:20-alpine

# Run as non-root user
USER node

WORKDIR /usr/src/app

# Copy production dependencies and app code from builder stage
COPY --chown=node:node --from=builder /usr/src/app/node_modules ./node_modules
COPY --chown=node:node server.js .

# Expose app port
EXPOSE 3000

# Start directly with node (not npm) for better signal handling
CMD ["node", "server.js"]
