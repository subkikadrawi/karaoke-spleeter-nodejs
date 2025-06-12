FROM node:20.19.2-slim

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of your app
COPY . .

# Expose the port your app runs on
EXPOSE 5500

# Start the app
CMD ["npm", "start"]