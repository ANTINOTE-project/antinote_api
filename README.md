# ANTINOTE API

> Le projet ANTINOTE n'est en aucun cas lié à Index-Education. L'utilisation de ce logiciel est régie par la license
> MIT, nous ne procurons aucune guarantie quant à son utilisation.

> [!WARNING]
> Veuillez suivre le lien suivant pour accéder à
> **[l'application ANTINOTE](https://github.com/ANTINOTE-project/antinote_app)**.

Librairie permettant de communiquer avec une instance PRONOTE d'Index-Education.

## Fonctionnalités

Actuellement, nous supportons les fonctionnalités suivantes :

- [x] Connexion :
    - [x] Identifiant/MdP PRONOTE ;
    - [x] ENT/CAS ;
    - [x] QR Code ;
    - [x] Token (pour se reconnecter après avoir enregistré son compte).
- [x] Polling natif (mise à jour des discussions et des notifications en temps réel
  et maintient une session inactive en vie).
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
    - [x] Paramètres utilisateurs (beta).

## FAQ

- Est-ce que cette librairie est "vibe-codée" (créée grâce à une intelligence artificielle générative en tant que "
  conducteur" dans le processus de développement) ? Non, quasiment aucune utilisation de l'intelligence artificielle
  générative n'a été effectué durant la conception de cette librairie.
- Avec vous comme projet de rajouter plus de pages à cette librairie ? Pas exactement, nous ne souhaitons pas
  réimplémenter chaque page de PRONOTE pour l'instant. Nous nous focalisons sur les fonctionnalités essentielles (
  disponibles actuellement) et leur bon-fonctionnement sur la durée. Nous acceptons possiblement des contributions
  pouvant rajouter des pages supplémentaires, si l'implémentation est à la qualité convenue.
- Allez-vous ajouter le support pour d'autres types de comptes ? Oui ! Nous souhaitons ajouter le compte parent puis le compte professeur. Pour l'instant, nous voulons nous assurer de la stabilité de la librairie.

## Utilisation

Pour créer une session :

Il faut se procurer les identifiants correspondants :
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
   Les sessions mobiles disposent de tokens de reconnexion (afin de ne pas avoir à stocker les identifiants de l'utilisateur ou de passer par le CAS à chaque reconnexion).
2. Le `label` peut être laissé vide ici. Le nom de l'espace peut être trouvé plus tard dans les paramètres d'instance de la session.
3. Nous procurons une méthode permettant de générer un identifiant d'appareil. Nous recommandons cependant de la garder identique entre chaque interaction avec les services PRONOTE (quel-que-soit le compte).

Ensuite, il faut se connecter en utilisant les identifiants :
```dart
final (
  session: session,
  refreshCredentials: refreshCredentials
) = await credentials.login(options: .new(debugMode: true)); // Par exemple.
```
Les `refreshCredentials` sont à stocker afin de se reconnecter (ils sont d'ailleurs exportables en Protobuf).

La session est l'objet représentant la connexion avec PRONOTE avec le compte renseigné dans les identifiants.

Il peut y avoir des exceptions durant cet appel :
- `IOException` : quand la connexion ne peut pas être établie avec l'instance.
- `UnexpectedCASRedirect` : quand une connexion "naïve" se fait rediriger vers un CAS alors qu'elle ne s'y attendait pas.
- `AuthException` : quand les identifiants sont incorrects.

Finalement, il suffit de se positionner dans la bonne page en faisant appel à :
```dart
await session.ensurePage(7); // Page d'accueil
```

Un annuaire des numéros de pages n'est pas encore disponible. Pour savoir quelle page utiliser, rendez-vous sur un compte PRONOTE et naviguez vers la page désirée tout en ayant votre outil DevTools d'ouvert sur la page "réseau". Vous trouverez une requête POST sous format JSON avec un champ `id` égal à `Navigation`. Depuis, trouvez le champ `onglet` **dans la requête que vous envoyez**. L'identifiant est celui à renseigner dans `RemoteSession.ensurePage`.

Et d'accéder à la ressource souhaitée :
```dart
final homePageWidgets = await session.access(
  HomePageAccessor(
    modules: [
      EDT.module()
    ]
  )
);
```

Durant toute interaction après la connexion à un compte, une requête incorrecte ou un problème autre peut arriver. Dans ces cas, une erreur `RemoteException` est envoyée et signifie la mort de la session. À partir de ce moment-là, se reconnecter est nécéssaire pour continuer à intéragir avec le compte de connecté.