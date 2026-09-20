# God's Eye View — container image
# NOTE: This app's data relays (flights, ships, quakes, CCTV, radio, voice
# proxies) are Vite dev-server middleware by design, so the image runs the
# Vite server rather than a static build. See SECURITY.md before exposing
# it publicly, and put your own auth in front if you do.
FROM node:24-slim

WORKDIR /app

# Puppeteer is only used by QA scripts; skip its ~300MB Chromium download.
ENV PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    HOST=0.0.0.0 \
    PORT=4173

# Install dependencies first for better layer caching.
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund

# Copy the rest of the app (see .dockerignore for exclusions).
COPY . .

EXPOSE 4173

CMD ["npm", "run", "dev"]
