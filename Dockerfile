# Build stage: mory
FROM node:lts-alpine AS mory-build-stage
WORKDIR /app
COPY mory/package*.json ./
RUN npm install
COPY mory/. .
COPY .env.mory .env
RUN npm run build

# Build stage: moried
FROM rust:latest AS moried-build-stage
WORKDIR /usr/src/app
COPY moried/Cargo.toml .
COPY moried/Cargo.lock .
COPY moried/src src
RUN cargo build --release

# Production stage
FROM nginx:stable AS production-stage
WORKDIR /app
COPY start.sh .
# mory
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx-default.conf /etc/nginx/conf.d/default.conf
RUN rm /usr/share/nginx/html/*
COPY --from=mory-build-stage /app/dist /usr/share/nginx/html
# moried
COPY --from=moried-build-stage /usr/src/app/target/release/moried .
COPY .env.moried .env
ENV MORIED_GIT_DIR /notes
ENV MORIED_LISTEN 127.0.0.1:3030

# Run
VOLUME $MORIED_GIT_DIR
EXPOSE 80
CMD ["./start.sh"]
