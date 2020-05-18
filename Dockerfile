FROM node:14-alpine as builder

COPY . wirvsvirus-testergebnis-ui/

# fix backend URL, build and reconfigure serve parameters
# TODO: replace first sed when URL is configurable
RUN cd wirvsvirus-testergebnis-ui && \
  sed -i -e 's#https://joemat-crtest.azurewebsites.net/#http://backend:8080/#g' src/app/data.service.ts && \
  npm install && \
  npm run build --if-present -- --prod && \
  sed -i -e "s#ng serve#ng serve --host 0.0.0.0#g" package.json

# TARGET IMAGE
FROM nginx:stable-alpine

RUN rm -rf /usr/share/nginx/html/*
COPY --chown=nginx --from=builder /wirvsvirus-testergebnis-ui/dist/* /usr/share/nginx/html/

CMD ["nginx", "-g", "daemon off;"]
