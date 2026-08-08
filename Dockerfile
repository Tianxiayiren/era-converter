# Lightweight production image using nginx (alpine ships with curl, which
# the HEALTHCHECK uses; Debian-based nginx images ship without wget/curl).
# Override BASE_IMAGE when Docker Hub is unreachable, e.g.:
#   docker build --build-arg BASE_IMAGE=docker.m.daocloud.io/library/nginx:alpine .
ARG BASE_IMAGE=nginx:alpine
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
  CMD curl -fsS http://localhost/index.html > /dev/null || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
