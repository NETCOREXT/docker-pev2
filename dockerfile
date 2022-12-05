FROM keymetrics/pm2:16-alpine AS base

LABEL maintainer="Aren Chen <gucci313031@gmail.com>"
LABEL org.opencontainers.image.title="Postgres Explain Visualizer V2" \
      org.opencontainers.image.description="Run pev2 with Alpine, PM2." \
      org.opencontainers.image.authors="Aren Chen <gucci313031@gmail.com>" \
      org.opencontainers.image.vendor="netcorext" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/NETCOREXT/docker-pev2" \
      org.opencontainers.image.source="https://github.com/NETCOREXT/docker-pev2.git"

WORKDIR /app
EXPOSE 80
ENTRYPOINT ["pm2", "serve", "--no-daemon", "--spa", ".", "80" ]

FROM node:lts-alpine AS build
RUN apk --update --no-cache add \
    git curl
RUN git config --global http.sslVerify false
RUN git clone https://github.com/dalibo/pev2.git
RUN cd pev2 \
    && npm install \
    && npm run build \
    && mv ./dist-app /dist

FROM base AS final
COPY --from=build /dist/ .
