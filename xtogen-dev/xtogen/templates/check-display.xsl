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
<xsl:param name="structure_file"/>
<xsl:param name="file_url_prefix"/>

	<xsl:variable name="structure" select="document(concat($file_url_prefix,$structure_file))/application"/>

	<xsl:template match="/display/static">
		<xsl:message>Erreur : le bloc "static" doit maintenant se trouver dans la section "application"</xsl:message>
	</xsl:template>

	<xsl:template match="/">
		<xsl:if test="count(display/application)=0">
			<xsl:message>Erreur : pas de section application</xsl:message>
		</xsl:if>
		<xsl:if test="count(display/documenttypes)=0">
			<xsl:message>Attention : pas de section documenttypes</xsl:message>
		</xsl:if>

		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="/display/documenttypes/documenttype">
		<xsl:if test="not(@id)">
			<xsl:message>Erreur : la base de document n'a pas d'identifiant</xsl:message>
		</xsl:if>

		<xsl:variable name="id" select="@id"/>
		<xsl:choose>
			<xsl:when test="count($structure/documenttypes/documenttype[@id=$id])=0">
				<xsl:message>Erreur : la base de document <xsl:value-of select="$id"/> n'est pas déclarée dans le fichier structure.xml</xsl:message>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="edit"/>
				<xsl:apply-templates select="search"/>
				<xsl:apply-templates select="nav"/>
				<xsl:apply-templates select="meta"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="edit">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="search">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="nav">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- field -->
	<xsl:template match="on">
		<xsl:variable name="docid" select="../../@id"/>
		<xsl:variable name="section" select="name(parent::*)"/>
		<xsl:variable name="doctype" select="$structure/documenttypes/documenttype[@id=$docid]/fields"/>
		<xsl:variable name="f" select="@field"/>
		<xsl:variable name="field" select="$doctype/descendant-or-self::field[@name=$f]"/>

		<xsl:choose>
			<xsl:when test="not(@field)">
				<xsl:message>Erreur : le champ ne contient pas d'attribut field</xsl:message>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="count($field)=0 and not(contains(@field,'.label'))">
					<xsl:message>Attention : le champ "<xsl:value-of select="$f"/>" n'existe pas dans le type de document "<xsl:value-of select="$docid"/>"</xsl:message>
				</xsl:if>
				<xsl:if test="count(following-sibling::field[@name=$f]) != 0">
					<xsl:message>Attention : le champ "<xsl:value-of select="$f"/>" est défini plusieurs fois pour le type de document "<xsl:value-of select="$docid"/>"</xsl:message>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="@mode and $field/@type!='choice' and $field/@type!='relation' and $field/@type != 'attach'">
			<xsl:message>Attention : le champ "<xsl:value-of select="$f"/>" n'est pas de type choice, l'attribut mode est donc ignoré.</xsl:message>
		</xsl:if>

		<xsl:if test="@mode and @mode!='check' and @mode!='radio' and @mode!='combo' and @mode!='Mcombo' and @mode!='2cols' and @mode!='alpha' and @mode!='inline' and @mode!='link' and @mode!='upload'">
			<xsl:message>Erreur : valeur de mode non conforme : "<xsl:value-of select="@mode"/>"</xsl:message>
		</xsl:if>

		<xsl:if test="(@mode!='combo' and @mode='Mcombo') and $field/@type='relation'">
			<xsl:message>Erreur : un champ relation ne supporte que les modes combo et Mcombo</xsl:message>
		</xsl:if>

		<xsl:if test="(@mode!='link' and @mode!='inline' and @mode!='upload') and $field/@type='attach'">
			<xsl:message>Erreur : un champ attach ne supporte que les modes link et inline</xsl:message>
		</xsl:if>

		<xsl:if test="$section!='search' and @mode and (@mode='check' or @mode='Mcombo' or @mode='2cols') and $field/@repeat='no'">
			<xsl:message>Attention : le champ "<xsl:value-of select="$f"/>" est en mode "<xsl:value-of select="@mode"/>" mais n'est pas multivalué.</xsl:message>
		</xsl:if>

		<xsl:if test="@sort">
			<xsl:if test="$field/@type != 'choice' or not($field/@list)">
				<xsl:message>Attention : champ "<xsl:value-of select="$f"/>", l'attribut sort n'est utilisable que sur les champs de type liste externe</xsl:message>
			</xsl:if>
		</xsl:if>

	</xsl:template>

	<xsl:template match="meta">
		<xsl:apply-templates select="on" mode="meta"/>
	</xsl:template>

	<xsl:template match="on" mode="meta">
		<xsl:variable name="docid" select="../../@id"/>
		<xsl:variable name="doctype" select="$structure/documenttypes/documenttype[@id=$docid]/fields"/>
		<xsl:variable name="f" select="@field"/>
		<xsl:variable name="field" select="$doctype/descendant-or-self::field[@name=$f]"/>

		<xsl:choose>
			<xsl:when test="not(@field)">
				<xsl:message>Erreur : le champ ne contient pas d'attribut field</xsl:message>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="count($field)=0">
					<xsl:message>Attention : le champ "<xsl:value-of select="$f"/>" n'existe pas dans le type de document "<xsl:value-of select="$docid"/>"</xsl:message>
				</xsl:if>
				<xsl:if test="count(following-sibling::field[@name=$f]) != 0">
					<xsl:message>Attention : le champ "<xsl:value-of select="$f"/>" est défini plusieurs fois pour le type de document "<xsl:value-of select="$docid"/>"</xsl:message>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="lists">
		<xsl:apply-templates select="list"/>
	</xsl:template>

	<xsl:template match="list">
		<xsl:choose>
			<xsl:when test="not(@id)">
				<xsl:message>Erreur : Liste sans identifiant !</xsl:message>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="id" select="@id"/>
				<xsl:if test="not($structure/documenttypes/descendant-or-self::field[@type='choice' and @list=$id])">
					<xsl:message> Erreur : La liste "<xsl:value-of select="$id"/>" n'existe pas !</xsl:message>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
