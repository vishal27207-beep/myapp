# Stage 1: Build the Angular application
FROM node:20-alpine AS build
WORKDIR /app

# Allocate more memory for the build process
ENV NODE_OPTIONS="--max-old-space-size=4096"

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build --configuration=production
# Stage 2: Serve the application using Nginx
FROM nginx:alpine
# Copy the custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the build output from Stage 1 to Nginx's HTML folder
# NOTE: Check your local dist folder structure. It might be /app/dist/myapp/browser
COPY --from=build /app/dist/myapp/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]