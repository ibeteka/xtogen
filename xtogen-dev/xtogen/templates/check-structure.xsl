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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/application">
	
		<xsl:if test="count(languages)=0">
			<xsl:message>Erreur : section "languages" manquante</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="languages"/>

		<xsl:if test="count(documenttypes)=0">
			<xsl:message>Erreur : section "documenttypes" manquante</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="documenttypes"/>
	
	</xsl:template>

	<!-- languages -->
	<xsl:template match="languages">
		<xsl:choose>
			<xsl:when test="count(lang)=0">
				<xsl:message>Erreur : aucune langue définie</xsl:message>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="count(lang[@default='yes'])!=0">
					<xsl:message>Erreur : n'utilisez pas 'yes' mais 'true' pour l'attribut 'default' d'une langue</xsl:message>
				</xsl:if>
				<xsl:if test="count(lang[@default='true'])!=1">
					<xsl:message>Erreur : pas de langue par défaut ou plus d'une</xsl:message>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- lang -->
	<xsl:template match="lang">
		<xsl:if test="not(@id)">
			<xsl:message>Erreur : attribut id manquant pour la langue</xsl:message>
		</xsl:if>
	</xsl:template>

	<!-- documenttypes -->
	<xsl:template match="documenttypes">
		<xsl:if test="count(documenttype)=0">
			<xsl:message>Erreur : aucun type de document défini</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="documenttype"/>
	</xsl:template>

	<!-- documenttype -->
	<xsl:template match="documenttype">
		<xsl:if test="not(@id)">
			<xsl:message>Erreur : attribut id non défini pour le type de document</xsl:message>
		</xsl:if>
		<xsl:variable name="id" select="@id"/>
		<xsl:if test="count(following-sibling::documenttype[@id=$id]) != 0">
			<xsl:message>Erreur : le type de document "<xsl:value-of select="$id"/>" n'est pas unique</xsl:message>
		</xsl:if>
		<xsl:if test="count(fields)=0">
			<xsl:message>Erreur : section "fields" manquante</xsl:message>
		</xsl:if>
		<xsl:apply-templates select="fields"/>
		<xsl:if test="count(nav)!=0">
			<xsl:message>Attention : la section "nav" doit être maintenant placée dans le fichier display.xml</xsl:message>
		</xsl:if>
		<xsl:if test="count(search)!=0">
			<xsl:message>Erreur : la section "search" doit être maintenant placée dans le fichier display.xml</xsl:message>
		</xsl:if>
	</xsl:template>
	
	<!-- fields -->
	<xsl:template match="fields">
		<xsl:if test="count(field|fieldgroup) = 0">
			<xsl:message>Erreur : Aucun champ défini</xsl:message>
		</xsl:if>
		<xsl:if test="count(descendant-or-self::field[@default])!=1">
			<xsl:message>Erreur : Aucun champ par défaut défini ou plusieurs champs</xsl:message>
		</xsl:if>
		<xsl:variable name="fields" select="."/>
		<xsl:for-each select="descendant-or-self::field|descendant-or-self::fieldgroup">
			<xsl:variable name="name" select="@name"/>
			<xsl:if test="count($fields/descendant-or-self::field[@name=$name]|$fields/descendant-or-self::fieldgroup[@name=$name])&gt;1">
				<xsl:message> Erreur : Plusieurs champs ou groupes répétables portent le nom <xsl:value-of select="$name"/></xsl:message>
			</xsl:if>
		</xsl:for-each>
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- fieldgroup -->
	<xsl:template match="fieldgroup">
		<xsl:if test="not(@name)">
			<xsl:message>Erreur : Attribut name manquant pour un champ répétable</xsl:message>
		</xsl:if>
		<xsl:if test="@path and starts-with(@path,'@')">
			<xsl:message>Erreur : Le chemin d'un fieldgroup ne peut commencer par un @</xsl:message>
		</xsl:if>
		<xsl:if test="@path and starts-with(@path,'/')">
			<xsl:message>Erreur : Le chemin d'un fieldgroup ne peut être absolu</xsl:message>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- field -->
	<xsl:template match="field">
		<xsl:if test="not(@name)">
			<xsl:message>Erreur : Attribut name manquant pour un champ</xsl:message>
		</xsl:if>
		<xsl:if test="@path and starts-with(@path,'/')">
			<xsl:message>Erreur : Le chemin d'un field ne peut être absolu</xsl:message>
		</xsl:if>
		<xsl:if test="@type and @type!='string' and @type!='choice' and @type!='email' and @type!='url' and @type!='text' and @type!='relation' and @type!='attach' and @type!='image'">
			<xsl:message>Erreur : Type de champ "<xsl:value-of select="@type"/>" inconnu</xsl:message>
		</xsl:if>
		<xsl:if test="@type='image'">
			<xsl:message>Attention : Utilisez le type "attach" plutot que "image"</xsl:message>
		</xsl:if>
		<xsl:if test="@mode">
			<xsl:message>Erreur : Le mode d'affichage des champs choice doit maintenant être configuré dans display.xml</xsl:message>
		</xsl:if>
		<xsl:if test="@type='relation'">
			<xsl:if test="not(@to)">
				<xsl:message>Erreur : la destination du champ relation n'est pas précisée</xsl:message>
			</xsl:if>
			<xsl:variable name="to" select="@to"/>
			<xsl:if test="count(//documenttype[@id=$to])=0">
				<xsl:message>Erreur : le champ relation référence un type de document "<xsl:value-of select="$to"/> inconnu</xsl:message>
			</xsl:if>
		</xsl:if>
		<xsl:variable name="docid" select="../../@id"/>
		<xsl:variable name="f" select="@name"/>
		<xsl:if test="count(following-sibling::field[@name=$f]) != 0">
			<xsl:message>Attention : le champ "<xsl:value-of select="$f"/>" est défini plusieurs fois pour le type de document "<xsl:value-of select="$docid"/>"</xsl:message>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
