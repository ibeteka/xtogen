Ce répertoire contient un répertoire par langue de l'interface
de l'application. Chaque répertoire est nommé <lang>-<country> où
<lang> est le code iso à 2 lettres de la langue et <country> le 
code iso à 2 lettres du pays.
Chaque répertoire contient les fichiers d'entête, d'édito, de pied de page,
de barre de navigation et d'interface dans la langue.

Ainsi, on trouvera par exemple les fichiers pour le français
dans le répertoire fr-FR. ils seront nommés :
* fr-FR_edito.xml : fichier edito (apparaissant sur la page d'accueil)
* fr-FR_footer.xml : fichier de bas de page (apparaissant sur chaque page)
* fr-FR_header.xml : fichier d'en-tête de page (apparaissant sur chaque page)
* fr-FR_nav.xml : fichier de barre de navigation (apparaissant sur chaque page)
* fr-FR_interface.xml : fichier de messages standard

Commencez par personnaliser edito, footer et header pour les adapter à votre
application (ajoutez votre logo...).
La barre de navigation en l'état actuel devrait fonctionner.
Le fichier de messages est également standard, vous n'avez pas besoin de le
personnaliser.

Les fichiers edito, footer, header et nav sont au format XHTML.
Dans les fichiers footer, header et nav vous pouvez de plus ajouter certains
éléments dynamiques qui seront transformés à l'exécution. En voici la liste :
* <xtg:language-bar/> : liste des langues de l'application avec possibilité
	de passer de l'une à l'autre.
* <xtg:search-form/> : formulaire de recherche plein-texte dans toutes les
	bases de l'application.
* <xtg:user-info/> : Information sur l'utilisateur actuellement connecté.
* <xtg:link-index/> : Lien vers la page d'accueil
* <xtg:link-nav/> : Liste de liens navigation
* <xtg:link-search/> : Liste de liens recherche
* <xtg:link-static/> : Liste de liens vers les pages statiques
* <xtg:link-login/> : Lien vers la page d'authentification
* <xtg:link-admin/> : Lien vers la page d'administration (affiché seulement si
	l'utilisateur est administrateur)
