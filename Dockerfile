# Stage 1: Build the Angular application
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of the application code and build it
COPY . .

RUN ./node_modules/.bin/ng build --configuration production
# Stage 2: Serve the application using Nginx
FROM nginx:alpine
# Copy the custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the build output from Stage 1 to Nginx's HTML folder
# NOTE: Check your local dist folder structure. It might be /app/dist/myapp/browser
COPY --from=build /app/dist/myapp/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]