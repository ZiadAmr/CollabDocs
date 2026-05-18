# TODO:
# TEST migrate


.PHONY: help install install-backend install-frontend \
	dev dev-backend dev-frontend \
	build lint format \
	migrate migrate-create db-reset \
	clean

# CONFIG

PYTHON := python3
VENV := venv
BACKEND_DIR := backend
FRONTEND_DIR := frontend

ifeq ($(OS), Windows_NT)
    PIP      := $(VENV)/Scripts/pip
    UVICORN  := $(VENV)/Scripts/uvicorn
    ALEMBIC  := $(VENV)/Scripts/alembic
else
    PIP      := $(VENV)/bin/pip
    UVICORN  := $(VENV)/bin/uvicorn
    ALEMBIC  := $(VENV)/bin/alembic
endif


# Help

help:
	@echo ""
	@echo "  Google Docs Clone — available commands"
	@echo ""
	@echo "  Setup"
	@echo "    make install           Install all dependencies (backend + frontend)"
	@echo "    make install-backend   Install Python dependencies only"
	@echo "    make install-frontend  Install Node dependencies only"
	@echo ""
	@echo "  Development"
	@echo "    make dev               Run backend and frontend concurrently"
	@echo "    make dev-backend       Run FastAPI dev server (port 8000)"
	@echo "    make dev-frontend      Run Vite dev server (port 5173)"
	@echo ""
	@echo "  Database"
	@echo "    make migrate           Apply all pending Alembic migrations"
	@echo "    make migrate-create    Create a new migration (set MSG=your message)"
	@echo "    make db-reset          Drop all tables and re-run migrations"
	@echo ""
	@echo "  Code quality"
	@echo "    make lint              Lint backend (ruff) and frontend (eslint)"
	@echo "    make format            Format backend (ruff) and frontend (prettier)"
	@echo ""
	@echo "  Build"
	@echo "    make build             Build frontend for production"
	@echo ""
	@echo "  Cleanup"
	@echo "    make clean             Remove build artifacts and caches"
	@echo ""

# Install

install: install-backend install-frontend

install-backend:
	@echo "Creating virtual environment..."
	$(PYTHON) -m venv $(VENV)
	@echo "Installing python dependencies..."
	$(PIP) install -r $(BACKEND_DIR)/requirements.txt
	@echo "Backend ready"

install-frontend:
	@echo "Installing Node dependencies..."
	cd $(FRONTEND_DIR) && npm install
	@echo "Frontend ready"

# Development

dev: 
	@echo "Starting backend and frontend..."
	@make -j2 dev-backend dev-frontend

dev-backend:
	@echo "Starting FastAPI on http://localhost:8000"
	$(UVICORN) $(BACKEND_DIR).main:app --reload --port 8000

dev-frontend:
	@echo "Starting Vite on http://localhost:5173"
	cd $(FRONTEND_DIR) && npm run dev

# Database

migrate:
	@echo "Applying migrations..."
	$(ALEMBIC) --config $(BACKEND_DIR)\alembic.ini upgrade head
	@echo "Migrations applied"

migrate-create:
	$(ALEMBIC) --config $(BACKEND_DIR)/alembic.ini revision --autogenerate -m "$(MSG)"
	@echo "Migration created"

db-reset:
	@echo "This will drop all tables and re-run migrations."
	@read -p "Are you sure? [y/N] " confirm && ["$$confirm" = "y"]
	cd $(BACKEND_DIR) && ../$(ALEMBIC) downgrade base
	cd $(BACKEND_DIR) && ../$(ALEMBIC) upgrade head
	@echo "Database reset"

# Code Quality 

lint:
	@echo "Linting backend..."
	$(VENV)/bin/ruff check $(BACKEND_DIR)
	@echo "Linted frontend..."
	cd $(FRONTEND_DIR) && npm run lint
	@echo "Lint complete"

format:
	@echo "Formatting backend..."
	$(VENV)/bin/ruff format $(BACKEND_DIR)
	@echo "Formatting frontend..."
	cd $(FRONTEND_DIR) && npm run format
	@echo "Format complete"

# Build

build:
	@echo "buidling frontend for production"
	cd $(FRONTEND_DIR) && npm run build
	@echo "Build output in $(FRONTEND_DIR)/dist"

# Clean

clean:
	@echo "Cleaning up..."
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf $(FRONTEND_DIR)/dist
	rm-rf $(FRONTEND_DIR)/.vite
	@echo "Clean complete"
