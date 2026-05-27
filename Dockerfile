# Stage 1: Build the Angular application
FROM node:20-alpine AS build
WORKDIR /app

# Allocate more memory for the build process
ENV NODE_OPTIONS="--max-old-space-size=4096"

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build --configuration=production
FROM nginx:alpine

# Copy your custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy your LOCALLY built files straight into the Nginx directory
COPY ./dist/myapp/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]