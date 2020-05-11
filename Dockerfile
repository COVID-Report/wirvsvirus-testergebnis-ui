FROM node:14-alpine as builder

COPY . wirvsvirus-testergebnis-ui/
RUN cd wirvsvirus-testergebnis-ui && \
  npm install && \
  npm run build --if-present -- --prod && \
  sed -i -e "s#ng serve#ng serve --host 0.0.0.0#g" package.json

# TARGET IMAGE
FROM nginx:stable-alpine

RUN rm -rf /usr/share/nginx/html/*
COPY --chown=nginx --from=builder /wirvsvirus-testergebnis-ui/dist/* /usr/share/nginx/html/

CMD ["nginx", "-g", "daemon off;"]
