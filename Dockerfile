# =========================
# Stage 1 - Build Angular
# =========================
FROM node:22-alpine AS build

WORKDIR /app

ENV NODE_OPTIONS=--max-old-space-size=4096

COPY package*.json ./

RUN npm install --include=dev

COPY . .

RUN ./node_modules/.bin/ng build --configuration=production

# =========================
# Stage 2 - Nginx Server
# =========================
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/dist/myapp/browser /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
