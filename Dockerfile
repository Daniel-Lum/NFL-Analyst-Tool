FROM apache/airflow:latest-python3.9

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    && apt-get autoremove -yqq --purge \
    && apt-get -y install libpq-dev gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER airflow

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/airflow/.bashrc

# Set environment variables for Poetry
ENV POETRY_HOME="/home/airflow/.local"
ENV PATH="$POETRY_HOME/bin:$PATH"

# Copy pyproject.toml and poetry.lock (if available)
COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock  # Optional, remove if not using poetry.lock

# Install dependencies using Poetry
RUN poetry install --no-dev

# If you need to include any specific requirements from a requirements.txt, you can do that as well
# RUN pip install --no-cache-dir --user -r requirements.txt
