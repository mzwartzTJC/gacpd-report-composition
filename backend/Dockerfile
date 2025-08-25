# Base image with OpenJDK 11
FROM openjdk:11

# Install Node.js (LTS) manually 
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy backend files
COPY backend/ ./

# Copy stylesheets and images
COPY stylesheets/ /app/stylesheets/

# Install Node.js dependencies
RUN npm install

# Create uploads and downloads folder
RUN mkdir -p uploads downloads

# Expose port
EXPOSE 5000

# Start the server
CMD ["node", "server.js"]