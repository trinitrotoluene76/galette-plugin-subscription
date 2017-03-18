[plugin subscription chart]: doc/plugin_subscription.png
[Presentation plugin]: doc/AS_Nexter_presentation_galette_subscription_indD.pptx
[git model branching]: http://nvie.com/posts/a-successful-git-branching-model/
[version de Galette modifiée]: https://github.com/trinitrotoluene76/galette
[Site officiel de Galette]: http://galette.eu/dc/index.php
[repo plugin subscription]: https://github.com/trinitrotoluene76/galette-plugin-subcription.git
# galette-plugin-subscription
## Description :
**Plugin Galette de gestion d'abonnements sportifs avec un circuit de validation**
![graphique plugin subscription][plugin subscription chart]

* Le statut de l’abonnement est partagé avec les responsables de groupe et le bureau en temps réel
* Validé ou payé -> ajout de l’adhérent dans les groupes  automatiquement
* Chacun peut écrire/voir les messages liés à l’abonnement
* Chaque responsable de groupe peut valider ou refuser l’abonnement (=abonnement partiel)

## Présentation complète :
* [Site officiel de Galette][Site officiel de Galette]
* [Présentation du plugin subscription][Presentation plugin]

## Fonctionnalités résumées :
* Développement spécifiquement pour les besoins de l’AS Nexter
* Suffisamment ouvert pour correspondre à un besoin plus large
* Cycle de validation d’un abonnement
    * Gestion des sommes dues, 
    * sommes payées, 
    * messages de confirmation ou de refus
* Gestion automatique de l’activité parente (adhésion AS) lors 	d’un abonnement
* La classe groupe a été étendue (classe activity pour inclure les 	tarifs et les renseignements propres à ces derniers)
* Tarification automatiquement calculée en fonction de l‘âge et de 	la provenance de l'adhérent (appartient à l'entreprise, extérieur, 	militaire...)
* Upload de fichiers avec barre de chargement pour les groupes et 	pour chaque adhérent (certif. Méd., autorisations parentales…)
* Envoi automatique de mail à l'adhérent lors d'un changement de 	statut de son abonnement
* Suppression de tous les abonnements en fin de saison + 	enlèvement des adhérents des groupes par un bouton accessible 	par le président
* Extraction formatée (Excel) de la base de données pour chaque 	responsable de groupe (adhérents + abonnements)

## Description des branches de développement :
J'ai suivi les règles de développement de ce site: [git model branching]
j'utilise git flow avec les branches:
* master (version stable)
* develop (version de développement).

J'ai dû modifier la version de Galette pour les besoins de l'Association:
[version de Galette modifiée]
```
*---*------------* master (Version officielle, Johan)
 \     \*--------------* develop (Version officielle, Johan)
  \*----------*---*-------* galette_amaury2 (~master amaury)
                    \*-----------galette_amaury2_dev (~develop amaury)
```
## Règles de nommage :
* Les versions de galette modifiées sont tagguées dans la branche stable `{version officielle}-amaury-{ma version majeure.ma version mineure}`. exemple `0.8.3.3-amaury-0.1`
* Les versions du plugin subscriptions sont taggués dans la branche master `v{ma version majeure.ma version mi-neure}`. exemple `v0.1`.

## Procédure d'installation :
1. télécharger ma [version de Galette modifiée], branche: galette_amauryx
2. télécharger la dernière release du plugin : [repo plugin subscription], branche master
3. copier coller le tout sur votre serveur (les plugins sont à mettre dans galette/plugins/)
4. installer Galette conformément à la procédure décrite sur leur site (dans un navigateur taper l'url IPduserveur/galette/install)
5. Installer le plugin depuis le tableau de bord en cliquant sur plugin puis sur le bouton BDD pour installer les tables sql propres au plugin. (Procédure classique de Galette)
FIN