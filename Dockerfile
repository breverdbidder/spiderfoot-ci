FROM python:3.11-slim

LABEL maintainer="Everest Capital USA"
LABEL description="SpiderFoot OSINT Platform for Competitive Intelligence"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    curl \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/spiderfoot

# Clone SpiderFoot
RUN git clone --depth 1 https://github.com/smicallef/spiderfoot.git .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create directories for data persistence
RUN mkdir -p /data/spiderfoot

# Environment variables
ENV SPIDERFOOT_DATA=/data/spiderfoot
ENV SF_DEBUG=0

# Expose port
EXPOSE 5001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5001/ || exit 1

# Copy entrypoint script
COPY entrypoint.sh /opt/spiderfoot/entrypoint.sh
RUN chmod +x /opt/spiderfoot/entrypoint.sh

# Start SpiderFoot with authentication
ENTRYPOINT ["/opt/spiderfoot/entrypoint.sh"]
