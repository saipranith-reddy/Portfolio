FROM ubuntu:latest

LABEL maintainer="Pranith Reddy"

# Install Nginx
RUN apt-get update && \
    apt-get install -y nginx && \ 
    apt-get clean

# Set working directory
WORKDIR /var/www/html

# Copy website files from build context into image
COPY . /var/www/html/

# Expose port 80
EXPOSE 80

# Run nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
