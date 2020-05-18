FROM node:14-alpine as builder

COPY . wirvsvirus-testergebnis-ui/

RUN cd wirvsvirus-testergebnis-ui && \
  npm install && \
  npm run build --if-present --configuration=docker --prod

# TARGET IMAGE
FROM nginx:stable-alpine

RUN rm -rf /usr/share/nginx/html/*
COPY --chown=nginx --from=builder /wirvsvirus-testergebnis-ui/dist/* /usr/share/nginx/html/

# configure reverse proxy for backend
RUN sed -i -e 's#^}# location /api { \
         proxy_pass http://backend:8080/; \
       } \
     }#' /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
