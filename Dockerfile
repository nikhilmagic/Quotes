FROM python:3.11-slim

WORKDIR /app

# Install system dependencies (wkhtmltopdf dependencies + others)
RUN apt-get update && apt-get install -y \
    wget \
    xfonts-75dpi \
    xfonts-base \
    fontconfig \
    libjpeg62-turbo \
    && rm -rf /var/lib/apt/lists/*

# Download and install wkhtmltopdf (static build)
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bookworm_amd64.deb \
    && dpkg -i wkhtmltox_0.12.6.1-2.bookworm_amd64.deb \
    && apt-get install -f -y \
    && rm wkhtmltox_0.12.6.1-2.bookworm_amd64.deb

# Copy dependency files
COPY pyproject.toml poetry.lock* /app/

# Install poetry and dependencies
RUN pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi

# Copy the rest of the application
COPY . .

EXPOSE 8000

CMD ["uvicorn", "app:api", "--host", "0.0.0.0", "--port", "8000"]
