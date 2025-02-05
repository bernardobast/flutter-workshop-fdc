# Use a lightweight web server to serve the Flutter app.
# Uses nginx:alpine, a minimal and efficient version of NGINX optimized for small container sizes.
FROM nginx:alpine

# Defines the working directory inside the container where NGINX serves static files (/usr/share/nginx/html).
WORKDIR /usr/share/nginx/html

# Remove the default nginx static files
RUN rm -rf ./*

# Copies the compiled Flutter web application (expected to be in ./build/web) into the NGINX static content directory.
COPY ./build/web .

# Replaces the default NGINX configuration with a custom one (default.conf) tailored for the Flutter app.
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Ensures proper file permissions so that NGINX can read and serve all files.
RUN chmod -R 755 /usr/share/nginx/html

# Exposes port 8080 for communication, which is required when running on platforms like Google Cloud Run.
EXPOSE 8080

# Starts NGINX with daemon off;, preventing it from running in the background and ensuring the container keeps running.
CMD ["nginx", "-g", "daemon off;"]
