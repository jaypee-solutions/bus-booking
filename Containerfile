# syntax=docker/dockerfile:1
# check=error=true

####################################################################################################
#
# Multi-stage build for Python docker containers
#
# base
#   Python + uv pre-installed from official uv image
#
# build
#   Python-related artifacts are built (caches, venv)
#
# app-build
#   Final, uv tooling installed, current uv cache available. Used to _build_ Python projects and run
#   code checkers.
#
# app-run
#   Final, with venv where Python projects are installed and ready to run commands in CI.
####################################################################################################

# globally shared vars:
ARG VERSION=0.0.0
ARG HOME=/opt/python

# renovate: datasource=docker depName=ghcr.io/astral-sh/uv
ARG UV_IMAGE=ghcr.io/astral-sh/uv:0.11.1-python3.14-bookworm-slim

FROM ${UV_IMAGE} AS base

# create non-root user:
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --create-home appuser

# configure Python:
ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random

# configure uv and pyright:
ENV UV_CACHE_DIR=/var/cache/pyuv \
    PYRIGHT_PYTHON_IGNORE_WARNINGS=1

FROM base AS build

ARG VERSION
ARG HOME

WORKDIR /home/appuser
COPY . app

WORKDIR /home/appuser/app
RUN sed -i "s/^version = \"0.0.0\"/version = \"$VERSION\"/" pyproject.toml && \
    uv sync

# create app run environment:
RUN uv build && \
    uv export --no-emit-project > dist/requirements.txt && \
    python3 -m venv $HOME && \
    $HOME/bin/pip install -U setuptools pip wheel && \
    $HOME/bin/pip install -r dist/requirements.txt && \
    $HOME/bin/pip install dist/*.whl && \
    ln -s $HOME/bin/bus_booking $HOME/bus_booking

# Install pyright npm package by calling the Python wrapper installed through uv, fills the
# pyright npm cache.
# hadolint ignore=DL3059
RUN uv run pyright --version

FROM base AS app-build

# remove apt cache:
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=build $UV_CACHE_DIR $UV_CACHE_DIR

# let appuser read/write the caches:
RUN chown -R appuser:appuser "$UV_CACHE_DIR"

# switch to appuser for use by CI:
USER appuser

FROM base AS app-run

ARG HOME

COPY --from=build $HOME $HOME

# let all users execute bus_booking:
RUN chmod -R a+rX $HOME

# provide bus_booking on PATH and venv for potential use by other scripts:
ENV PATH="$HOME:$PATH" \
    APP_VENV=$HOME

# switch to appuser for use by CI:
USER appuser

# point UV cache to the home directory of the appuser user to avoid permission issues for ops repo
# creation. The cache dir set during build stage is not allowed to be written by default.
ENV UV_CACHE_DIR=/home/appuser/.cache/uv
