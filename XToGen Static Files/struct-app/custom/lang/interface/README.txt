Ce r�pertoire contient un r�pertoire par langue de l'interface
de l'application. Chaque r�pertoire est nomm� <lang>-<country> o�
<lang> est le code iso � 2 lettres de la langue et <country> le 
code iso � 2 lettres du pays.
Chaque r�pertoire contient les fichiers d'ent�te, d'�dito, de pied de page,
de barre de navigation et d'interface dans la langue.

Ainsi, on trouvera par exemple les fichiers pour le fran�ais
dans le r�pertoire fr-FR. ils seront nomm�s :
* fr-FR_edito.xml : fichier edito (apparaissant sur la page d'accueil)
* fr-FR_footer.xml : fichier de bas de page (apparaissant sur chaque page)
* fr-FR_header.xml : fichier d'en-t�te de page (apparaissant sur chaque page)
* fr-FR_nav.xml : fichier de barre de navigation (apparaissant sur chaque page)
* fr-FR_interface.xml : fichier de messages standard

Commencez par personnaliser edito, footer et header pour les adapter � votre
application (ajoutez votre logo...).
La barre de navigation en l'�tat actuel devrait fonctionner.
Le fichier de messages est �galement standard, vous n'avez pas besoin de le
personnaliser.

Les fichiers edito, footer, header et nav sont au format XHTML.
Dans les fichiers footer, header et nav vous pouvez de plus ajouter certains
�l�ments dynamiques qui seront transform�s � l'ex�cution. En voici la liste :
* <xtg:language-bar/> : liste des langues de l'application avec possibilit�
	de passer de l'une � l'autre.
* <xtg:search-form/> : formulaire de recherche plein-texte dans toutes les
	bases de l'application.
* <xtg:user-info/> : Information sur l'utilisateur actuellement connect�.
* <xtg:link-index/> : Lien vers la page d'accueil
* <xtg:link-nav/> : Liste de liens navigation
* <xtg:link-search/> : Liste de liens recherche
* <xtg:link-static/> : Liste de liens vers les pages statiques
* <xtg:link-login/> : Lien vers la page d'authentification
* <xtg:link-admin/> : Lien vers la page d'administration (affich� seulement si
	l'utilisateur est administrateur)
