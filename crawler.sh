#!/bin/bash

# Vérifier si un paramètre a été fourni
if [ -z "$1" ]; then
    echo "Erreur : Veuillez fournir une URL en paramètre."
    echo "Usage : $0 URL=https://www.example.com/sitemap.xml"
    exit 1
fi

# Extraire l'URL à partir du paramètre
if [[ "$1" =~ ^URL=(.+)$ ]]; then
    SITEMAP_URL="${BASH_REMATCH[1]}"
else
    echo "Erreur : Le paramètre doit être au format URL=https://www.example.com/sitemap.xml"
    exit 1
fi

# Télécharger le contenu du sitemap
echo "Téléchargement du sitemap..."
SITEMAP_CONTENT=$(curl -s "$SITEMAP_URL")

# Vérifier si le téléchargement a réussi
if [ -z "$SITEMAP_CONTENT" ]; then
    echo "Erreur : Impossible de télécharger le sitemap."
    exit 1
fi

# Extraire les URLs du sitemap
echo "Extraction des URLs..."
URLS=$(echo "$SITEMAP_CONTENT" | sed -n -e 's|.*<loc><!\[CDATA\[\(.*\)\]\]></loc>.*|\1|p')

# Vérifier si des URLs ont été trouvées
if [ -z "$URLS" ]; then
    echo "Erreur : Aucune URL trouvée dans le sitemap."
    exit 1
fi

# Parcourir chaque URL et mesurer le temps
echo "Début du crawl des URLs..."
for URL in $URLS; do
    echo "Crawling: $URL"

    # Effectuer la requête avec mesure du temps
    START_TIME=$(date +%s.%N) # Début du chronomètre
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
    END_TIME=$(date +%s.%N)   # Fin du chronomètre

    # Calcul du temps pris
    TIME_TAKEN=$(echo "$END_TIME - $START_TIME" | bc)

    if [ "$RESPONSE" -eq 200 ]; then
        echo "Succès : $URL (Temps : ${TIME_TAKEN}s)"
    else
        echo "Erreur ($RESPONSE) : $URL (Temps : ${TIME_TAKEN}s)"
    fi
done

echo "Crawl terminé."
