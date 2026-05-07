FROM python:3.11-slim

WORKDIR /app

# Install system dependencies (wkhtmltopdf is required for PDF/image generation)
RUN apt-get update && apt-get install -y wkhtmltopdf && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY pyproject.toml poetry.lock* /app/

# Install poetry and dependencies (without creating a virtual environment)
RUN pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi

# Copy the rest of the application
COPY . .

# Expose the port Railway expects
EXPOSE 8000

# Run the FastAPI app (app:api is correct because the app instance is named 'api' in app/__main__.py)
CMD ["uvicorn", "app:api", "--host", "0.0.0.0", "--port", "8000"]
