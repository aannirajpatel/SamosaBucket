# Base image
FROM node:14-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Install app dependencies
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Build the React frontend
RUN cd frontend && npm install && npm run build

# Expose ports
EXPOSE 5000
EXPOSE 80
EXPOSE 443

# Set environment variables (these will be provided by the hosting service)
# ENV DB_URL=<your-db-url>
# ENV JWT_SECRET=<your-jwt-secret>
# ENV REACT_APP_BACKEND_API=<your-backend-api-url>
# ENV REACT_APP_CLOUDINARY_CLOUDNAME=<your-cloudinary-cloudname>
# ENV REACT_APP_CLOUDINARY_FOLDER=<your-cloudinary-folder>
# ENV REACT_APP_CLOUDINARY_UPLOADPRESET=<your-cloudinary-upload-preset>
# ENV REACT_APP_POSITIONSTACK_ENABLED=<true-or-false>
# ENV REACT_APP_POSITIONSTACK_API=<your-positionstack-api-url>
# ENV REACT_APP_POSITIONSTACK_API_KEY=<your-positionstack-api-key>
# ENV REACT_APP_STRIPE_PUBLIC_KEY=<your-stripe-public-key>
# ENV REACT_APP_INFO_TAB_NAME=<your-info-tab-name>
# ENV STRIPE_SK=<your-stripe-secret-key>
# ENV ENFORCE_HTTPS=false
# ENV WEBAPP_ORIGIN=<samosabucket-webapp-origin-url>

# Install NGINX
RUN apk add --no-cache nginx

# Create an empty default.conf file
RUN mkdir -p /etc/nginx/conf.d && touch /etc/nginx/conf.d/default.conf

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx configuration
ADD nginx/nginx.dev.conf /etc/nginx/nginx.conf

# Start Nginx and the Node.js server
CMD nginx && node index.js