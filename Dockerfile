# Stage 1: Build the app
FROM node:18-alpine AS build
WORKDIR /app
# Install dependencies
COPY package.json package-lock.json* yarn.lock* ./
RUN npm install
# Copy the rest of the source code and build the app
COPY . .
RUN npm run build

# Stage 2: Serve the app with Nginx
FROM nginx:alpine
# Remove default Nginx website
RUN rm -rf /usr/share/nginx/html/*
# Copy built files from Stage 1
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]