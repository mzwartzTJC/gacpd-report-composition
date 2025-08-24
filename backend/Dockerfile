# Base image with OpenJDK 11
FROM openjdk:11

# Install Node.js (LTS) manually 
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Copy backend files
WORKDIR /app
COPY backend/ ./backend/

# Copy stylesheets and images
WORKDIR /app
COPY stylesheets/ ./stylesheets/

# Install Node.js dependencies
WORKDIR /app/backend
RUN npm install

# Create uploads and downloads folder
RUN mkdir -p /app/backend/uploads
RUN mkdir -p /app/backend/downloads

# Expose port
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]
