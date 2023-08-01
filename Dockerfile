FROM node:carbon

WORKDIR usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080

CMD ["npm", "start"]
# Stage 1: Build stage
# FROM node:carbon-alpine AS builder

# WORKDIR /usr/src/app

# COPY package*.json ./

# RUN npm install

# COPY . .

# # Build the application (replace "build" with the build command of your specific app)

# # Stage 2: Runtime stage
# FROM node:carbon-alpine

# WORKDIR /usr/src/app

# # Copy only the necessary files from the build stage
# COPY --from=builder /usr/src/app/package*.json ./
# COPY --from=builder /usr/src/app/dist ./dist

# # Install production dependencies only
# RUN npm install --only=production

# EXPOSE 8080

# CMD ["npm", "start"]
