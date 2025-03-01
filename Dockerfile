# Use a specific Python 3.6 tag to ensure reproducibility.
FROM python:3.6.15-slim-buster

# --- Standard Binder Dockerfile requirements ---

# 1) Create a non-root user with uid=1000
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER=${NB_USER}
ENV NB_UID=${NB_UID}
ENV HOME=/home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# 2) Install the necessary packages:
#    - The classic notebook (pinned at 6.1.1)
#    - JupyterLab (choose a version compatible with Python 3.6)
#    - jupyterhub (optional; only necessary if you want authenticated Binder use)
#    - And your pinned dependencies
RUN python -m pip install --no-cache-dir \
    "notebook==6.1.1" \
    "jupyterlab==2.2.9" \
    "jupyterhub==1.1.0" \
    "matplotlib==3.1.1" \
    "numpy==1.13.3" \
    "scipy==0.19.0" \
    "xlrd==2.0.1" \
    "openpyxl==3.0.7" \
    "version_information==1.0.3"

# 3) Copy your repo contents into the home directory and chown them
WORKDIR ${HOME}
COPY . ${HOME}

USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Expose notebook port (Binder will pass arguments to override command)
EXPOSE 8888

# By default, Binder launches with:
#     jupyter notebook --NotebookApp.default_url=/lab/ --ip=0.0.0.0 --port=8888
# so we do not define CMD or ENTRYPOINT here.