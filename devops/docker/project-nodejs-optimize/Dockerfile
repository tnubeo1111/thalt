# Stage 1: Build

FROM node:23.0 AS build-stage 

WORKDIR /app

COPY package*.json ./

RUN npm install 

COPY . .

# Stage 2: Run

FROM node:23.0-slim 

WORKDIR /app

COPY --from=build-stage /app .

EXPOSE 3000

ENV NODE_ENV=production

CMD ["node", "server.js"]