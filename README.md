# Extract Links application - Docker and Kubernetes Deployment

A lightweight Dockerized application to extract all unique links from a given URL using a Bash script. This project includes a Kubernetes deployment and CI/CD pipeline for automated builds and deployments.

---

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Setup and Usage](#setup-and-usage)
  - [Run Locally with Docker](#run-locally-with-docker)
  - [Deploy on Kubernetes](#deploy-on-kubernetes)
- [CI/CD Pipeline](#cicd-pipeline)
- [Project Structure](#project-structure)
- [Author](#author)

---

## Overview

This project automates the extraction of hyperlinks from given URLs and formats the output in either `stdout` or `json`. It leverages:
- **Docker**: For containerized application execution.
- **Kubernetes**: For deploying and managing the application in a cluster.
- **CI/CD**: To automate building, pushing, and deploying Docker images.

---

## Features
- Extract links from one or more URLs.
- Output links in plain text (`stdout`) or JSON format.
- Kubernetes support for seamless deployment.
- Lightweight and minimal dependencies (Alpine Linux).

---

## Requirements

- **Docker**: Installed on local machine.
- **Kubernetes**: Cluster setup (e.g., Minikube, Kind, or a cloud provider).
- **kubectl**: Installed and configured to interact with Kubernetes cluster.
- **GitLab CI/CD**: Set up with Docker Hub credentials stored as CI/CD variables.

---

## Setup and Usage

### Run Locally with Docker

1. **Build the Docker image**:
   ```bash
   docker build -t extract-links:latest .
   ```

2. **Run the container**:
   ```bash
   docker run --rm extract-links:latest -u http://quotes.toscrape.com/ -o stdout
   docker run --rm extract-links:latest -u http://quotes.toscrape.com/ -o json
   ```

   Replace `http://quotes.toscrape.com/` with your desired URL.

3. **Output formats**:
   - `stdout`: Prints links to the terminal.
   - `json`: Outputs links in JSON format.

---

### Deploy on Kubernetes

1. **Build and Push Docker Image**:
   Modify the `REGISTRY` and `TAG` variables in the CI/CD pipeline or build manually:
   ```bash
   docker build -t your-docker-id/extract-links:latest .
   docker push your-docker-id/extract-links:latest
   ```

2. **Update Kubernetes Configuration**:
   Update the `image` field in `kubernetes/deployment.yaml` with your Docker Hub image.

3. **Apply Kubernetes Resources**:
   Deploy the application:
   ```bash
   kubectl apply -f kubernetes/deployment.yaml
   kubectl apply -f kubernetes/service.yaml
   ```

4. **Check Deployment**:
   Verify the deployment status:
   ```bash
   kubectl rollout status deployment/extract-links-deployment
   ```

---

## CI/CD Pipeline

The project includes a GitLab CI/CD pipeline (`.gitlab-ci.yml`) to:
1. **Build**: Create a Docker image and push it to Docker Hub.
2. **Deploy**: Automatically deploy the latest image to your Kubernetes cluster.

### GitLab CI/CD Setup

1. Add the following **variables** in your GitLab project:
   - `DOCKER_USERNAME`: Your Docker Hub username.
   - `DOCKER_PASSWORD`: Your Docker Hub password.
   - `KUBERNETES_CLUSTER_CONFIG`: Path to your kubeconfig file.
   - Update the `REGISTRY` field in `.gitlab-ci.yml`.

2. Ensure the pipeline runs automatically on commits to the `main` branch.

---

## Project Structure

```plaintext
.
├── Dockerfile                # Docker configuration for building the image
├── kubernetes/
│   ├── deployment.yaml       # Kubernetes Deployment configuration
│   └── service.yaml          # Kubernetes Service configuration
├── README.md                 # Project documentation
└── scripts/
    └── extract_links.sh      # Bash script to extract links
```
