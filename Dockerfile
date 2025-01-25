# Use a lightweight web server to serve the Flutter app
FROM nginx:alpine

# Set the working directory in the container
WORKDIR /usr/share/nginx/html

# Remove the default nginx static files
RUN rm -rf ./*

# Copy the Flutter build output into the container
COPY ./build/web .

# Copy the custom Nginx configuration file into the container
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Ensure the correct file permissions
RUN chmod -R 755 /usr/share/nginx/html

# Expose port 8080 for Cloud Run
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
