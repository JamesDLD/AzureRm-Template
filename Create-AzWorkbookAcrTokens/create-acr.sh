#!/bin/bash

# Variables
RESOURCE_GROUP="monresourcegroup"
LOCATION="eastus"
PREFIX="monacr"
TOKEN_PREFIX="montoken"
SCOPE_MAP_NAME="pullscopemap"

# Créer le groupe de ressources s'il n'existe pas
az group create --name $RESOURCE_GROUP --location $LOCATION

for i in {1..5}
do
  ACR_NAME="${PREFIX}${i}"
  TOKEN_NAME="${TOKEN_PREFIX}${i}"

  # Créer le registre ACR
  az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --location $LOCATION

  # Vérifier si le scope map existe
  SCOPE_MAP_EXISTS=$(az acr scope-map show --name $SCOPE_MAP_NAME --registry $ACR_NAME --query "name" -o tsv 2>/dev/null)

  if [ -z "$SCOPE_MAP_EXISTS" ]; then
    # Créer un scope map vide
    az acr scope-map create --name $SCOPE_MAP_NAME --registry $ACR_NAME --description "Scope map pour pull"
    # Ajouter l'action repository:pull
    az acr scope-map update --name $SCOPE_MAP_NAME --registry $ACR_NAME --add actions repository:pull
  fi

  # Générer une date d'expiration aléatoire entre 1 et 30 jours à partir d'aujourd'hui
  EXPIRATION_DATE=$(date -d "+$((RANDOM % 30 + 1)) days" --utc +%Y-%m-%dT%H:%M:%SZ)

  # Créer un token pour le registre avec le scope map
  az acr token create --name $TOKEN_NAME --registry $ACR_NAME --scope-map $SCOPE_MAP_NAME --status enabled

  # Générer un mot de passe pour le token avec expiration
  az acr token credential generate --name $TOKEN_NAME --registry $ACR_NAME --password1-expiration $EXPIRATION_DATE

  echo "ACR $ACR_NAME créé avec token $TOKEN_NAME expirant le $EXPIRATION_DATE"
done