<?xml version="1.0"?>
<!--
	XtoGen - Générateur d'applications SDX2 - http://xtogen.tech.fr
    Copyright (C) 2003 Ministère de la culture et de la communication, PASS Technologie

    Ministère de la culture et de la communication,
    Mission de la recherche et de la technologie
    3 rue de Valois, 75042 Paris Cedex 01 (France)
    mrt@culture.fr, michel.bottin@culture.fr

    PASS Technologie, 23, rue Pierre et Marie Curie, 94200 Ivry Sur Seine
	Nader Boutros, nader.boutros@pass-tech.fr
    Pierre Dittgen, pierre.dittgen@pass-tech.fr

    Ce programme est un logiciel libre: vous pouvez le redistribuer
    et/ou le modifier selon les termes de la "GNU General Public
    License", tels que publiés par la "Free Software Foundation"; soit
    la version 2 de cette licence ou (à votre choix) toute version
    ultérieure.

    Ce programme est distribué dans l'espoir qu'il sera utile, mais
    SANS AUCUNE GARANTIE, ni explicite ni implicite; sans même les
    garanties de commercialisation ou d'adaptation dans un but spécifique.

    Se référer à la "GNU General Public License" pour plus de détails.

    Vous devriez avoir reçu une copie de la "GNU General Public License"
    en même temps que ce programme; sinon, écrivez à la "Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA".
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	xmlns:xtg="http://xtogen.tech.fr"
	xmlns:urle="java.net.URLEncoder"
	exclude-result-prefixes="sdx xsl xtg urle">

	<!-- Version de XtoGen -->
	<xsl:variable name="xtogenVersion">2.0.1</xsl:variable>

	<!-- Structure configuration -->
	<xsl:variable name="xtogenconf" select="document('config.xml')/configuration"/>

	<!-- Display configuration -->
	<xsl:variable name="conf_disp" select="document('config_display.xml')/configuration_display"/>

	<!-- Préfixe pour le nom des champs word -->
	<xsl:variable name="wordfieldprefix">xtgw_</xsl:variable>
	<!-- Préfixe pour le nom des champs choice -->
	<xsl:variable name="choicefieldprefix">xtgid_</xsl:variable>

	<!-- Chemin des urls de l'application -->
	<xsl:variable name="rootUrl" select="concat(/sdx:document/@server,'/',/sdx:document/@appbypath,'/')"/>

	<!-- Page actuelle -->
	<xsl:variable name="currentpage">
		<xsl:call-template name="baseuri">
			<xsl:with-param name="uri" select="/sdx:document/@uri"/>
		</xsl:call-template>
	</xsl:variable>

	<!-- Parametres de la page -->
	<xsl:variable name="urlparameter" select="/sdx:document/sdx:parameters/sdx:parameter"/>

	<!-- Champs simples -->
	<xsl:variable name="sfields" select="$xtogenconf/fields"/>
	<!-- Tous les champs -->
	<xsl:variable name="allfields" select="$xtogenconf/allfields"/>

	<!-- Nom du champ "titre" pour un type de document -->
	<xsl:variable name="titlefields" select="$xtogenconf/dbases"/>

	<!-- Relations entre type de documents -->
	<xsl:variable name="relations" select="$xtogenconf/relations"/>

	<!-- Langues -->
	<xsl:variable name="langs" select="$xtogenconf/languages"/>

	<!-- Type de document courant -->
	<xsl:variable name="currentdoctype">
		<xsl:choose>
			<xsl:when test="$urlparameter[@type='get' and @name='db']"><xsl:value-of select="$urlparameter[@type='get' and @name='db']/@value"/></xsl:when>
			<xsl:when test="starts-with($currentpage,'query_')"><xsl:value-of select="substring-before(substring-after($currentpage,'query_'),'.xsp')"/></xsl:when>
			<xsl:when test="starts-with($currentpage,'terms_')"><xsl:value-of select="substring-before(substring-after($currentpage,'terms_'),'.xsp')"/></xsl:when>
			<xsl:when test="starts-with($currentpage,'list_')"><xsl:value-of select="substring-before(substring-after($currentpage,'list_'),'.xsp')"/></xsl:when>
			<xsl:when test="starts-with($currentpage,'gallery_')"><xsl:value-of select="substring-before(substring-after($currentpage,'gallery_'),'.xsp')"/></xsl:when>
			<xsl:when test="starts-with($currentpage,'search_')"><xsl:value-of select="substring-before(substring-after($currentpage,'search_'),'.xsp')"/></xsl:when>
			<xsl:when test="starts-with($currentpage,'saisie_')"><xsl:value-of select="substring-before(substring-after($currentpage,'saisie_'),'.xsp')"/></xsl:when>
			<xsl:when test="starts-with($currentpage,'upload_')"><xsl:value-of select="substring-before(substring-after($currentpage,'upload_'),'.xsp')"/></xsl:when>
			<xsl:when test="starts-with($currentpage,'attach_browser_')"><xsl:value-of select="substring-before(substring-after($currentpage,'attach_browser_'),'.xsp')"/></xsl:when>
		</xsl:choose>
	</xsl:variable>

	<!-- Tri sur le type de document -->
	<xsl:variable name="currentdoctypesort" select="$conf_disp/documenttypes/documenttype[@id=$currentdoctype]/sort"/>
	<xsl:variable name="currentdoctypedefaultsortfield">
		<xsl:choose>
			<xsl:when test="$currentdoctypesort"><xsl:value-of select="$conf_disp/documenttypes/documenttype[@id=$currentdoctype]/sort/on[@default]/@field"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$titlefields/dbase[@id=$currentdoctype]"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Langue de l'application -->
	<xsl:variable name="defaultLang" select="$langs/lang[@default='true']/@id"/>
	<xsl:variable name="lang">
		<xsl:variable name="docLang" select="/sdx:document/@xml:lang"/>
		<xsl:variable name="sessionLang" select="$urlparameter[@type='session' and @name='lang']/@value"/>
		<xsl:choose>
			<!-- On utilise la langue de la session si on la trouve -->
			<xsl:when test="$sessionLang and $langs/lang[@id=$sessionLang]">
				<xsl:value-of select="$sessionLang"/>
			</xsl:when>

			<!-- On utilise la langue du document si elle est 
				 définie dans xtogen_lang -->
			<xsl:when test="$langs/lang[@id=$docLang]">
				<xsl:value-of select="$docLang"/>
			</xsl:when>

			<!-- Sinon, c'est la langue par défaut qui est utilisée -->
			<xsl:otherwise>
				<xsl:value-of select="$defaultLang"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Direction d'écriture -->
	<xsl:variable name="langDirection">
		<xsl:choose>
			<xsl:when test="$langs/lang[@id=$lang]/@direction = 'rtl'">rtl</xsl:when>
			<xsl:otherwise>ltr</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Alignement -->
	<xsl:variable name="alignDirection">
		<xsl:choose>
			<xsl:when test="$langDirection='ltr'">right</xsl:when>
			<xsl:otherwise>left</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Icônes -->
	<xsl:variable name="iconNext">
		<xsl:choose><xsl:when test="$langDirection='ltr'">icones/next.png</xsl:when>
		<xsl:otherwise>icones/prev.png</xsl:otherwise></xsl:choose>
	</xsl:variable>
	<xsl:variable name="iconPrev">
		<xsl:choose><xsl:when test="$langDirection='ltr'">icones/prev.png</xsl:when>
		<xsl:otherwise>icones/next.png</xsl:otherwise></xsl:choose>
	</xsl:variable>
	<xsl:variable name="iconNNext">
		<xsl:choose><xsl:when test="$langDirection='ltr'">icones/nnext.png</xsl:when>
		<xsl:otherwise>icones/pprev.png</xsl:otherwise></xsl:choose>
	</xsl:variable>
	<xsl:variable name="iconPPrev">
		<xsl:choose><xsl:when test="$langDirection='ltr'">icones/pprev.png</xsl:when>
		<xsl:otherwise>icones/nnext.png</xsl:otherwise></xsl:choose>
	</xsl:variable>

	<!-- Messages (traduits) de l'application -->
	<xsl:variable name="langpath" select="concat('lang/interface/',$lang,'/',$lang)"/>
	<xsl:variable name="messages"
		select="document(concat($langpath,'_interface.xml'))/messages/message"/>

	<!-- Labels (traduits) concernant les types de documents -->
	<xsl:variable name="labels"
				  select="document(concat('lang/document/',$lang,'_document.xml'))/labels"/>
	<!-- Labels (traduits) concernant la personnalisation de l'affichage -->
	<xsl:variable name="displaylabels"
				  select="document(concat($langpath,'_display.xml'))/labels"/>
	<!-- En-tête de page, inséré au début de chaque page -->
	<xsl:variable name="header" select="document(concat($langpath,'_header.xml'))"/>
	<!-- Pied de page, ajouté à la fin de chaque page -->
	<xsl:variable name="footer" select="document(concat($langpath,'_footer.xml'))"/>
	<!-- Barre de navigation -->
	<xsl:variable name="navbar" select="document(concat($langpath,'_nav.xml'))"/>

	<!-- Paramètres de l'URL -->
	<xsl:variable name="urlparamline" select="/sdx:document/@query"/>

	<!-- Pour la gestion des urls de langue -->
	<xsl:variable name="langprefixuri">
		<xsl:text/><xsl:value-of select="$currentpage"/>?<xsl:for-each select="$urlparameter[@type='get' and @name!='lang']">
			<xsl:text/><xsl:value-of select="@name"/>=<xsl:value-of select="urle:encode(@value,'UTF-8')"/>&amp;</xsl:for-each>lang=<xsl:text/>
	</xsl:variable>

	<!-- Pour la gestion des urls de tri -->
	<xsl:variable name="sortprefixuri">
		<xsl:text/><xsl:value-of select="$currentpage"/>?<xsl:for-each select="$urlparameter[@type='get' and @name!='sortfield' and @name!='order']">
			<xsl:text/><xsl:value-of select="@name"/>=<xsl:value-of select="urle:encode(@value,'UTF-8')"/>&amp;</xsl:for-each><xsl:text/>
	</xsl:variable>

	<!-- Parametres de la feuille de style -->
	<xsl:variable name="q" select="$urlparameter[@name='q']/@value"/>

	<!-- Application -->
	<xsl:variable name="currentapp" select="/sdx:document/@app"/>

	<!-- Utilisateur -->
	<xsl:variable name="currentuser" select="/sdx:document/descendant-or-self::sdx:user"/>
    <xsl:variable name="admin" select="boolean($currentuser/@admin) and $currentuser/@app = /sdx:document/@app"/>

	<!-- SDX document -->
	<xsl:variable name="sdxdocument" select="/sdx:document"/>

	<xsl:template name="baseuri">
		<xsl:param name="uri"/>
		<xsl:choose>
			<xsl:when test="contains($uri,'/')">
				<xsl:call-template name="baseuri">
					<xsl:with-param name="uri" select="substring-after($uri,'/')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$uri"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
