# Use official Python image
FROM python:3.11-slim

# Update apt and install curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
    # && pip install gunicorn

# Copy source code
COPY . .

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=5 \
  CMD curl -f http://localhost:5000/ || exit 1

# Start the app
# CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
CMD ["python", "app.py"]