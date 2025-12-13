# upload image 
# Update all packages 
#install utilities CURL, NGINX,ZIP
#Set nginx to run foreground 
#

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl nginx zip 

RUN echo "daemon off;" >> /etc/nginx/nginx.conf 

RUN curl -o /var/www/html/master.zip -L https://github.com/gabrielecirulli/2048/archive/master.zip

RUN cd /var/www/html && unzip master.zip && mv 2048-master/* . && rm -rf 2048-master master.zip 

RUN mkdir -p /usr/share/nginx/html && cp -r /var/www/html/* /usr/share/nginx/html



EXPOSE 80 

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]

