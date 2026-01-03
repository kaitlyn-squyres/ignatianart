FROM nginx:stable-alpine

# Copy site files into nginx html root. The Site files expect Images&Docs to be
# available at /Images&Docs, so copy that folder into the html directory as well.
COPY Site/ /usr/share/nginx/html/
COPY "Images&Docs"/ /usr/share/nginx/html/Images&Docs/

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 and run nginx in the foreground
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
