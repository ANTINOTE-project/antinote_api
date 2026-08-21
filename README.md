# ANTINOTE API

> [!IMPORTANT]
> Le projet ANTINOTE n'est en aucun cas lié à Index-Education.

> [!NOTE] 
> L'utilisation de ce logiciel est régie par la licence
> MIT ; il est fourni "en l'état", sans garantie d'aucune sorte quant à son utilisation.

> [!WARNING]
> Veuillez suivre le lien suivant pour accéder à
> **[l'application ANTINOTE](https://github.com/ANTINOTE-project/antinote_app)**.

Librairie Dart permettant de communiquer avec une instance PRONOTE d'Index-Education.

## Fonctionnalités

Actuellement, nous supportons les fonctionnalités suivantes :

- [x] Connexion :
    - [x] Identifiant/MdP PRONOTE ;
    - [x] ENT/CAS ;
    - [x] QR Code ;
    - [x] Token (pour se reconnecter après avoir enregistré son compte).
- [x] Polling natif (mise à jour des discussions et des notifications en temps réel
  et maintien d'une session inactive en vie).
- [x] Sérialisation de la session sous forme de Protobuf : permet de stocker la session sous son état actuel en JSON
  ou en binaire afin de pouvoir la restaurer en cas de redémarrage du client.
- [x] Identifiants visuels : sert à pouvoir retrouver les objets *probablement* identiques selon les sessions.
- [x] Géolocalisation d'instances.
- [x] Pages :
    - [x] Accueil ;
    - [x] Emploi du temps ;
    - [x] Menu ;
    - [x] TaF (téléversement de fichiers dysfonctionnel pour le moment) / Contenus de séances ;
    - [x] Discussions ;
    - [x] Informations et sondages ;
    - [x] Notes / Bulletins ;
    - [x] Paramètres utilisateurs (instable).

## FAQ

- Est-ce que cette librairie est générée par intelligence artificielle ? Non, quasiment aucune utilisation de l'intelligence artificielle
  générative n'a été effectuée durant la conception de cette librairie.
- Avez-vous comme projet de rajouter plus de pages à cette librairie ? Pas exactement, nous ne souhaitons pas
  réimplémenter chaque page de PRONOTE pour l'instant. Nous nous focalisons sur les fonctionnalités essentielles
  (disponibles actuellement) et leur bon fonctionnement sur la durée. Nous acceptons possiblement des contributions
  pouvant rajouter des pages supplémentaires, si l'implémentation est de la même qualité que les autres pages déjà implémentées.
- Allez-vous ajouter le support pour d'autres types de comptes ? Oui ! Nous souhaitons ajouter le compte parent puis le
  compte professeur. Pour l'instant, nous voulons nous assurer de la stabilité de la librairie.

## Utilisation

Il est nécessaire d'ajouter une dépendance à la librairie dans votre `pubspec.yaml` :
```yaml
dependencies:
  antinote: ^0.0.1
```

Pour l'instant, nous marquons l'entièreté de nos API publiques comme **instables**. Une version `1.0.0` sera publiée dès
que nous serons sûrs de pouvoir honorer la stabilité de toutes les API que nous révélons.

--- 

Pour créer une session, il faut se procurer les identifiants correspondants :
```dart
final credentials = PasswordCredentials(
  username: 'demonstration',
  password: 'pronotevs',
  workspace: Workspace(
    type: .mobileEleve, // [1]
    label: '', // [2]
    pathSegment: 'mobile.eleve.html',
  ),
  baseUrl: .parse('https://demo.index-education.net/pronote'),
  deviceUuid: Credentials.generateDeviceUuid(), // [3]
);
```

1. Seulement les sessions élèves sont officiellement supportées pour l'instant (`.eleve` et `.mobileEleve`).
   Les sessions mobiles disposent de tokens de reconnexion (afin de ne pas avoir à stocker les identifiants de
   l'utilisateur ou de passer par le CAS à chaque reconnexion).
2. Le `label` peut être laissé vide ici. Le nom de l'espace peut être trouvé plus tard dans les paramètres d'instance de
   la session.
3. Nous fournissons une méthode permettant de générer un identifiant d'appareil. Nous recommandons cependant de la
   garder identique entre chaque interaction avec les services PRONOTE (quel que soit le compte).

Ensuite, il faut se connecter en utilisant les identifiants :
```dart
final (
  session: session,
  credentials: refreshCredentials
) = await credentials.login(options: .new(debugMode: true)); // Active les logs.
```
Les `refreshCredentials` sont à stocker afin de se reconnecter (ils sont d'ailleurs exportables en Protobuf).

La session est l'objet représentant la connexion avec PRONOTE avec le compte renseigné dans les identifiants.

Il peut y avoir des exceptions durant cet appel :
- `IOException` : quand la connexion ne peut pas être établie avec l'instance.
- `UnexpectedCASRedirect` : quand une connexion "naïve" se fait rediriger vers un CAS alors qu'elle ne s'y attendait pas.
- `AuthException` : quand les identifiants sont incorrects.

Il ne reste plus qu'à accéder à la ressource souhaitée :
```dart
final homePageWidgets = await session.access(
  HomePageAccessor(
    modules: [
      TravailAFaire.module(),
      Notes.module(),
      VieScolaire.module(),
      Actualites.module(),
      DS.module(),
    ]
  )
);
```

Durant toute interaction après la connexion à un compte, une requête incorrecte ou un problème autre peut arriver. Dans
ces cas, une erreur `RemoteException` est envoyée et signifie la mort de la session. À partir de ce moment-là, se
reconnecter est nécessaire pour continuer à interagir avec le compte connecté.

## Contribution
Les contributions sont encouragées. Nous n'interdisons pas l'usage de l'intelligence artificielle. Cependant, nous
demandons au contributeur d'être responsable de son code, de la comprendre, et de savoir le modifier en conséquence de
nos commentaires.

Veuillez vous rapprocher vers des contributeurs existants pour demander conseil. Ce contact peut se faire grâce à
l'onglet discussion sur GitHub, dans les issues et pull requests, ou bien en contactant directement les membres de
l'organisation sur leurs emails / réseaux sociaux listés publiquement.

Ces intéractions sont en accord avec notre [Code de Conduite](CODE_OF_CONDUCT.md).

L'utilisation du français pour toute intéraction en dehors de la documentation ou du code est privilégié, car PRONOTE
est un produit manifestement français et nous voulons réduire la friction pour intégrer l'équipe de développement.
L'anglais est toutefois toléré.

Dans le code, nous demandons l'utilisation exclusive de l'anglais pour le nommage de symboles ainsi que pour la
documentation.
 
Ce projet a comme objectif la mise à disposition d'un outil permettant l'interopérabilité en détachant le client PRONOTE
(l'application mobile, pour ordinateur, ou le site internet) de l'instance PRONOTE. Cette activité nous permet d'étudier
le code des différents services de PRONOTE (surtout l'application mobile et la version web) afin d'améliorer cette
librairie, en toute légalité (cf. Article L122-6-1 du Code de la Propriété Intellectuelle). L'utilisation de ce droit ne
devrait pas être abusive (par définition). En pratique, nous limitons l'extraction d'information aux énumérations, aux
champs et types attendus pour les objets reçus du serveur, et leur signification directe. Ces informations sont ensuite
reformulées avant d'être intégrées au code de la librairie.