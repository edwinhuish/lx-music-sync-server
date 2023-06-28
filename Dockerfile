FROM node:16.20.1-bullseye AS builder
WORKDIR /app
COPY . .
# RUN npm install
RUN npm ci
RUN npm run build


FROM node:16.20.1-bullseye AS final
WORKDIR /app
COPY --from=builder /app/server ./server
COPY package.json package-lock.json config.js index.js ./
RUN npm ci --omit=dev

EXPOSE 9527
ENV NODE_ENV 'production'
ENV PORT 9527
ENV BIND_IP '0.0.0.0'
# ENV PROXY_HEADER 'x-real-ip'
# ENV SERVER_NAME 'My Sync Server'
# ENV MAX_SNAPSHOT_NUM '10'
# ENV LIST_ADD_MUSIC_LOCATION_TYPE 'top'
# ENV LX_USER_user1 '123.123'
# ENV LX_USER_user2 '{ "password": "123.456", "maxSnapshotNum": 10, "list.addMusicLocationType": "top" }'
# ENV CONFIG_PATH '/app/config.js'
# ENV LOG_PATH '/app/logs'
# ENV DATA_PATH '/app/data'


COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh", "docker-entrypoint.sh" ]

CMD su node -c "npm start"
