# Lightweight production image using nginx
# Override BASE_IMAGE when Docker Hub is unreachable, e.g.:
#   docker build --build-arg BASE_IMAGE=docker.m.daocloud.io/library/nginx:latest .
ARG BASE_IMAGE=nginx:latest
FROM ${BASE_IMAGE}
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Chinese Imperial Era Converter - Static Web Application"

# Remove default nginx config and static files
RUN rm -rf /etc/nginx/conf.d/default.conf /usr/share/nginx/html/*

# Copy all static assets to nginx html directory
COPY index.html data.js images-12-logo-red3.png LXGWWenKai-subset.woff2 /usr/share/nginx/html/

# Copy optimized nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/index.html || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
