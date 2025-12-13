# Use the official Nginx Alpine image (very stable)
FROM nginx:alpine

# Install tools
RUN apk add --no-cache curl unzip

# Go to the Nginx standard directory
WORKDIR /usr/share/nginx/html

# Clear existing default files
RUN rm -rf ./*

# Download the game
RUN curl -o master.zip -L https://github.com/gabrielecirulli/2048/archive/master.zip

# Unzip and move to current folder
RUN unzip master.zip && mv 2048-master/* . && rm -rf 2048-master master.zip

# --- THE CRITICAL FIX ---
# Grant Read Permissions to EVERYONE so Nginx can definitely read the files
RUN chmod -R 755 /usr/share/nginx/html
# ------------------------

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]