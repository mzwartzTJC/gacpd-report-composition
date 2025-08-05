# Use a lightweight Java runtime
FROM openjdk:11-jre-slim

# Set environment variables
ENV FOP_VERSION=2.9

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip python3 python3-pip && \
    pip3 install flask

# Download and install Apache FOP
RUN wget https://downloads.apache.org/xmlgraphics/fop/binaries/fop-${FOP_VERSION}.zip && \
    unzip fop-${FOP_VERSION}.zip && \
    mv fop-${FOP_VERSION} /fop && \
    rm fop-${FOP_VERSION}.zip

# Copy stylesheets and app code
COPY stylesheets/ /fop/stylesheets/
COPY app/server.py /fop/app/server.py

# Set working directory
WORKDIR /fop/app

# Expose port for Flask
EXPOSE 80

# Start the Flask server
CMD ["python3", "server.py"]
