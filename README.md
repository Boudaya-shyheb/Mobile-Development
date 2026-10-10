# CarShare --- Installation, Firebase/Firestore et lancement

Ce guide explique comment récupérer le projet Flutter **CarShare**, le
connecter au projet Firebase partagé par l'équipe et lancer
l'application sur Android.

## 1. Prérequis

Installer et configurer :

-   [Flutter SDK](https://docs.flutter.dev/get-started/install)
-   [Android Studio](https://developer.android.com/studio), avec Android
    SDK 14 API 34 et un émulateur ou un téléphone Android
-   [Git](https://git-scm.com/downloads)
-   Un compte Google ayant accès au projet Firebase CarShare

Vérifier l'environnement dans un terminal :

``` bash
flutter doctor
flutter --version
```

Si des licences Android sont en attente, exécuter :

``` bash
flutter doctor --android-licenses
```

Accepter les licences proposées. Pour développer uniquement sur Android,
l'avertissement concernant Visual Studio pour les applications Windows
n'est pas bloquant.

## 2. Installer les dépendances Flutter

``` bash
flutter pub get
```

## 3. Configurer Firebase pour Flutter/Android

### 3.1 Vérifier l'identifiant Android

Dans `android/app/build.gradle.kts`, vérifier la valeur de
`applicationId`. Pour la configuration actuelle du projet, elle est
normalement :

``` kotlin
applicationId = "com.example.carshare"
```

L'identifiant doit correspondre exactement à celui de l'application
Android enregistrée dans Firebase. Si le projet utilise un autre
identifiant, utilisez celui qui est réellement déclaré dans Gradle.

### 3.2 Vérifier les fichiers Firebase

La configuration Flutter/Android utilise normalement :

``` text
lib/firebase_options.dart
android/app/google-services.json
```

-   `firebase_options.dart` contient les options générées pour les
    plateformes Flutter configurées.
-   `google-services.json` contient la configuration de l'application
    Android Firebase.

Si ces fichiers sont déjà présents et correspondent au projet Firebase
de l'équipe, ne les régénérez pas inutilement.

Si un fichier manque ou si la configuration pointe vers le mauvais
projet :

1.  Ouvrir un terminal à la racine du projet.
2.  Installer Firebase CLI si nécessaire, puis se connecter :

``` bash
npm install -g firebase-tools
firebase login
```

3.  Installer FlutterFire CLI :

``` bash
dart pub global activate flutterfire_cli
```

4.  Configurer l'application en sélectionnant le projet Firebase
    **existant** de l'équipe :

``` bash
flutterfire configure
```

Sélectionner Android et, si demandé, les autres plateformes réellement
utilisées. Vérifier que l'identifiant Android correspond à celui de
Gradle. Cette commande génère ou met à jour `lib/firebase_options.dart`.
Télécharger également `google-services.json` depuis les paramètres du
projet Firebase, dans l'application Android correspondante, puis le
placer dans `android/app/google-services.json`.

Ne créez pas un nouveau projet Firebase par membre. Ne remplacez pas les
fichiers de configuration partagés sans coordination avec l'équipe.

### 3.3 Initialisation et dépendances

Le code doit initialiser Firebase avant `runApp()`, généralement dans
`lib/main.dart` :

``` dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Les packages utilisés par le module utilisateur comprennent normalement
:

-   `firebase_core`
-   `firebase_auth`
-   `cloud_firestore`

Les dépendances sont déclarées dans `pubspec.yaml`. Pour les installer :

``` bash
flutter pub get
```

Ne copiez pas manuellement des versions fictives dans `pubspec.yaml`;
laissez Flutter résoudre les versions compatibles.

## 4. Lancer l'application

### Sur un téléphone Android

1.  Activer les options développeur et le débogage USB sur le téléphone.
2.  Connecter le téléphone au PC et accepter l'autorisation de débogage.
3.  À la racine du projet, exécuter :

``` bash
flutter devices
```

Le téléphone doit apparaître dans la liste.

### Sur un émulateur Android

Dans Android Studio, ouvrir **Tools → Device Manager**, démarrer un
émulateur, puis vérifier sa présence avec `flutter devices`.

### Démarrer CarShare

À la racine du projet :

``` bash
flutter pub get
flutter analyze
flutter run
```

Pour générer un APK de débogage :

``` bash
flutter build apk --debug
```

Le fichier APK est normalement généré ici :

``` text
build/app/outputs/flutter-apk/app-debug.apk
```

Si Gradle signale que le SDK Android 34 manque, ouvrir **Tools → SDK
Manager → SDK Platforms**, installer **Android 14 / API 34** si
nécessaire, puis relancer la compilation. Si Gradle ne peut pas
télécharger un plugin, vérifier d'abord la connexion Internet, les
dépôts Gradle et le message d'erreur complet avant de changer les
versions.

## 5. Dépannage rapide

  ------------------------------------------------------------------------
Problème                            Vérifications
  ----------------------------------- ------------------------------------
`google-services.json` introuvable  Vérifier
`android/app/google-services.json`
et l'identifiant Android.

`DefaultFirebaseOptions`            Vérifier `lib/firebase_options.dart`
introuvable                         et exécuter `flutterfire configure`
avec le projet partagé.

`PERMISSION_DENIED` dans Firestore  Vérifier les règles publiées, l'UID
du document, les champs et le type
de `createdAt`.

E-mail ou mot de passe incorrect    Vérifier l'adresse exacte, le mot de
passe et le compte dans
Authentication.

Plugin Gradle introuvable           Vérifier Internet, les dépôts Gradle
et la version déclarée; conserver
l'erreur complète.

Téléphone non détecté               Vérifier le câble USB, le débogage
USB et `flutter devices`.

Dépendances Flutter non résolues    Exécuter `flutter pub get` et
examiner le message d'erreur.
  ------------------------------------------------------------------------
