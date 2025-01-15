# crawler
Script Bash permet de récupérer et d’analyser un fichier sitemap XML, puis de mesurer le temps de réponse pour chaque URL contenue dans le sitemap. 
Il utilise curl pour télécharger le contenu du sitemap et effectuer des requêtes HTTP pour chaque URL, en mesurant le temps nécessaire pour obtenir une réponse. 
Les résultats sont affichés avec le statut de chaque URL (succès ou erreur) et le temps de réponse en secondes.

# Exécution
./crawler.sh URL=https://www.example.com/sitemap.xml

