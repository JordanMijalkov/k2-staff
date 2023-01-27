FROM nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
ADD build/web /usr/share/nginx/html
EXPOSE 80