FROM python:3.12-slim

# Install uv by copying the static binary from its official image —
# faster and more reliable than pip-installing uv into the container
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Copy only dependency files first — not the whole project yet
COPY pyproject.toml uv.lock ./

# Install dependencies into a project-local venv, using the lockfile exactly as-is
RUN uv sync --frozen --no-install-project

# Now copy the rest of your actual application code
COPY . .

# Install the project itself (picks up anything not caught by the layer above)
RUN uv sync --frozen

EXPOSE 8000

CMD ["uv", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]