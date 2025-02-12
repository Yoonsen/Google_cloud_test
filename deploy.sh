#!/bin/bash

# Deploy script for Google Cloud Run
# Usage: ./deploy.sh <app_name>

# Check if app name is provided
if [ -z "$1" ]
then
    echo "Please provide an app name"
    echo "Usage: ./deploy.sh <app_name>"
    exit 1
fi

APP_NAME=$1
PROJECT_ID="jupyterhub-379311"
REGION="europe-north1"

echo "🚀 Starting deployment pipeline for $APP_NAME"

# Build the Docker image
echo "📦 Building Docker image..."
docker build -t $APP_NAME .

# Tag the image for Google Container Registry
echo "🏷️ Tagging image for GCR..."
docker tag $APP_NAME gcr.io/$PROJECT_ID/$APP_NAME

# Push to Google Container Registry
echo "⬆️ Pushing to Google Container Registry..."
docker push gcr.io/$PROJECT_ID/$APP_NAME

# Deploy to Cloud Run
echo "🌩️ Deploying to Cloud Run..."
gcloud run deploy $APP_NAME \
  --image gcr.io/$PROJECT_ID/$APP_NAME \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --set-env-vars APP_NAME=$APP_NAME

echo "✅ Deployment complete!"
echo "Your app should be available at: dh.nb.no/run/$APP_NAME/"