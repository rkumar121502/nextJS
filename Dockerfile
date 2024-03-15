# Stage 1: install dependencies
FROM node:17-alpine AS stage1
WORKDIR /app
COPY package*.json .
RUN npm install

# Stage 2: build
FROM node:17-alpine AS builder
WORKDIR /app
COPY --from=stage1 /app/node_modules ./node_modules
COPY src ./src
COPY public ./public
COPY package.json next.config.js jsconfig.json ./
RUN npm run build

# Stage 3: run
FROM node:17-alpine
WORKDIR /app
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
CMD ["npm", "run", "start"]
