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
	exclude-result-prefixes="sdx xsl xtg">

	<!-- Template général -->
	<xsl:template match="node()|@*" mode="component">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="component"/>
		</xsl:copy>
	</xsl:template>

	<!-- type de document -->
	<xsl:template match="xtg:doctype" mode="component">
		<big>DOCTYPE = <xsl:value-of select="$currentdoctype"/></big>
	</xsl:template>

	<!-- Barre de langue -->
	<xsl:template match="xtg:language-bar" mode="component">
		<small>
		<xsl:choose>
			<!-- Pas de barre si une seule langue -->
			<xsl:when test="count($langs/lang[@label]) &lt; 2"/>

			<!-- Affiche la barre -->
			<xsl:otherwise>
				<!-- On passe les langues en revue -->
				<xsl:for-each select="$langs/lang[@label]">
					<xsl:choose>
						<!-- Pas de lien sur la langue en cours -->
						<xsl:when test="@id = $lang">
							<xsl:value-of select="@label"/>
						</xsl:when>
						<!-- Un lien sur les autres langues-->
						<xsl:otherwise>
							<a class="nav" href="{$langprefixuri}{@id}" title="{@label}"><xsl:value-of select="@label"/></a>
						</xsl:otherwise>
					</xsl:choose>
					<br/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		</small>
	</xsl:template>

	<!-- Formulaire de recherche -->
	<xsl:template match="xtg:search-form" mode="component">
		<form action="results.xsp" method="get">
			<input type="text" name="q" value="{$q}" size="15"/>
			<xsl:choose>
				<xsl:when test="count($langs/lang[@label]) &gt; 1">
					<select name="qlang">
						<xsl:for-each select="$langs/lang[@label]">
							<option value="{@id}">
								<xsl:if test="@id=$lang">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="@label"/>
							</option>
						</xsl:for-each>
					</select>
				</xsl:when>
				<xsl:otherwise>
					<input type="hidden" name="qlang" value="{$lang}"/>
				</xsl:otherwise>
			</xsl:choose>
			<input type="image" value="submit" src="icones/ok.png" title="{$messages[@id='bouton.recherchepleintexte']}"/>
		</form>
	</xsl:template>

	<!-- Information sur l'utilisateur connecté -->
	<xsl:template match="xtg:user-info" mode="component">
	    <xsl:apply-templates select="$currentuser" mode="userident" />
	</xsl:template>

	<!-- ================================================================= -->
	<!-- == Liens de la barre de navigation ============================== -->
	<!-- ================================================================= -->

	<!-- Accueil -->
	<xsl:template match="xtg:link-index" mode="component">
		<a class="barnav" href="index.xsp" title="{$messages[@id='tooltip.accueil']}">
			<xsl:value-of select="$messages[@id='bouton.accueil']"/>
		</a>
	</xsl:template>

	<!-- Navigation -->
	<xsl:template match="xtg:link-nav" mode="component">
		<xsl:variable name="dtroot" select="$conf_disp/documenttypes/documenttype"/>

		<xsl:call-template name="searchandnav">
			<xsl:with-param name="href">nav.xsp</xsl:with-param>
			<xsl:with-param name="section">navigation</xsl:with-param>
			<xsl:with-param name="doctypes" select="$dtroot[nav/on]"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Recherche -->
	<xsl:template match="xtg:link-search" mode="component">
		<xsl:variable name="dtroot" select="$conf_disp/documenttypes/documenttype"/>

		<xsl:call-template name="searchandnav">
			<xsl:with-param name="href">search.xsp</xsl:with-param>
			<xsl:with-param name="section">recherche</xsl:with-param>
			<xsl:with-param name="doctypes" select="$dtroot[search/on]"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="searchandnav">
		<xsl:param name="section"/>
		<xsl:param name="doctypes"/>
		<xsl:param name="href"/>

		<xsl:variable name="tooltip" select="concat('tooltip.',$section)"/>
		<xsl:variable name="bouton" select="concat('bouton.',$section)"/>
		<xsl:choose>
			<xsl:when test="count($doctypes) = 1">
				<a class="barnav" href="{$href}?db={$titlefields/dbase[1]/@id}" title="{$messages[@id=$tooltip]}">
					<xsl:value-of select="$messages[@id=$bouton]"/></a>
			</xsl:when>
			<xsl:when test="count($doctypes) &gt; 1">
				<fieldset>
				<legend>
					<xsl:value-of select="$messages[@id=$bouton]"/>
				</legend>
				<xsl:variable name="url" select="$href"/>
				<xsl:for-each select="$doctypes">
					<xsl:variable name="db" select="@id"/>
					<a class="barnav" href="{$url}?db={$db}" title="{$labels/doctype[@name=$db]/label}">
					<xsl:value-of select="$labels/doctype[@name=$db]/label"/></a>
				</xsl:for-each>
				</fieldset>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- Partie statique -->
	<xsl:template match="xtg:link-static" mode="component">
		<table cellpadding="0" cellspacing="0" width="100%">
		<xsl:for-each select="$conf_disp/static/page">
			<xsl:variable name="labelid" select="concat('static.bouton.', .)"/>
			<xsl:variable name="tooltipid" select="concat('static.tooltip.', .)"/>
			<tr><td>
				<a class="barnav" href="static.xsp?page={.}" title="{$displaylabels/label[@id=$tooltipid]}">
					<xsl:value-of select="$displaylabels/label[@id=$labelid]"/></a>
			</td></tr>
		</xsl:for-each>
		</table>
	</xsl:template>

	<!-- Login -->
	<xsl:template match="xtg:link-login" mode="component">
		<a class="barnav" href="login.xsp" title="{$messages[@id='tooltip.identification']}">
			<xsl:value-of select="$messages[@id='bouton.identification']"/>
		</a>
	</xsl:template>

	<!-- Administration -->
	<xsl:template match="xtg:link-admin" mode="component">
		<xsl:choose>
			<xsl:when test="$admin">
				<tr><td nowrap="nowrap">
					<a class="barnav" href="admin.xsp" title="{$messages[@id='tooltip.administration']}">
					<xsl:value-of select="$messages[@id='bouton.administration']"/></a>
				</td></tr>
			</xsl:when>
			<xsl:when test="$currentuser/sdx:group[@id='saisie'] and $currentuser/@app=$currentapp">
				<tr><td nowrap="nowrap">
					<a class="barnav" href="admin.xsp" title="{$messages[@id='tooltip.saisie']}">
					<xsl:value-of select="$messages[@id='bouton.saisie']"/></a>
				</td></tr>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
