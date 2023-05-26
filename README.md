# Rapport TP3

## Running the program
- Open a terminal and run:
```
curl "http://devops-20220575.germanywestcentral.azurecontainer.io:8081?lat=<your-latitude>&lon=<your-longitude>"
```
For example:
```
curl "http://devops-20220575.germanywestcentral.azurecontainer.io:8081?lat=5.902785&lon=102.754175"
```

## Etape 1: Récupérer le code du TP2

## Etape 2: Configurer le fichier .yml
Ce fichier décrit le processus de déploiement d'une image Docker vers Azure Container Instances (ACI). Voici les points importants :
### Job `build-and-push-image`
1. **Checkout code** : Récupérer le code à partir du référentiel.
2. **Azure Login** : Effectuer la connexion à Azure à l'aide de `AZURE_CREDENTIALS`.
3. **Login to ACI** : Effectuer la connexion au registre Docker d'ACI à l'aide de `REGISTRY_LOGIN_SERVER`, `REGISTRY_USERNAME` et `REGISTRY_PASSWORD`.
4. **Build and push Docker image** : Construire l'image Docker et la pousse vers le registre spécifié.
5. **Deploy to Azure Container Instances** : Déployer l'image Docker sur Azure Container Instances. Les paramètres de déploiement sont configurés via les secrets et les valeurs fournies.
   - `resource-group` : Nom du groupe de ressources Azure cible.
   - `dns-name-label` : Étiquette DNS pour l'instance ACI déployée.
   - `image` : L'image Docker à déployer, avec le nom et la version spécifiés.
   - `registry-login-server`, `registry-username`, `registry-password` : Informations d'identification pour se connecter au registre Docker.
   - `name` : Nom de l'instance ACI.
   - `ports` : Ports exposés par l'instance ACI (port 8081 dans ce cas).
   - `location` : Région Azure où déployer l'instance ACI.
   - `environment-variables` : Variables d'environnement à définir lors du déploiement.

## Difficultés rencontrées
Lors du déploiement vers ACI, j'ai rencontré les difficultés suivantes liées à la configuration des ports et des variables d'environnement :

- **Ports** : Par défaut, le port utilisé est 80 dans le fichier de configuration. Cependant, le code `main.py` écoute sur le port 8081. Par conséquent, j'ai dû reconfigurer les ports dans le fichier YAML pour refléter ce changement et s'assurer que l'instance ACI écoute sur le port correct.

- **Variables d'environnement** : Pour cacher la clé d'API, je l'ai stocké dans les secrets de Github et j'y accède par une variable d'environnement nommée `API_KEY`. La difficulté rencontrée est de trouver la syntaxe appropriée dans le fichier YAML pour référencer et utiliser cette variable d'environnement dans l'API.

## Bonus
1. **Aucune données sensibles stockées dans l'image ou le code source**
- Pour la clé API: la stocker dans les secrets de Github et la récupérer dans le fichier YAML avec
```
environment-variables: |
    API_KEY=${{ secrets.API_KEY }}
```
- Pour les credentials: les stocker dans les secrets de Github et les appeller directement dans le fichier YAML avec
```
{{ secrets.<nom-du-credential> }}
```