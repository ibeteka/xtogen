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
	exclude-result-prefixes="sdx">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="display_config_file"/>
<xsl:param name="file_url_prefix"/>

<xsl:include href="xtogen-common-functions.xsl"/>

<xsl:template match="/">
<xsl:comment>
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
</xsl:comment>
	<xsp:page language="java" xmlns:xsp="http://apache.org/xsp" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx">
		<sdx:page langSession="lang" langParam="lang">
			<bar/>
			<title id="title.nav"/>
			<xsl:variable name="info" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes"/>
			<xtg:authentication domain="nav">
				<xsl:for-each select="/application/documenttypes/documenttype">
					<xsl:variable name="docid" select="@id"/>
					<xsl:apply-templates select="$info/documenttype[@id=$docid]/nav">
						<xsl:with-param name="docstructure" select="."/>
					</xsl:apply-templates>
				</xsl:for-each>
			</xtg:authentication>
		</sdx:page>
	</xsp:page>
</xsl:template>

<xsl:template match="nav">
	<xsl:param name="docstructure"/>
	<documentbase id="{../@id}">
		<xsl:call-template name="copy-location">
			<xsl:with-param name="location" select="$docstructure/location"/>
		</xsl:call-template>
		<xsl:for-each select="on">
			<xsl:variable name="fieldname" select="@field"/>
			<xsl:element name="field">
				<xsl:attribute name="name"><xsl:value-of select="$fieldname"/></xsl:attribute>
				<xsl:variable name="field" select="$docstructure/fields/descendant-or-self::field[@name=$fieldname]"/>
				<xsl:attribute name="type"><xsl:choose><xsl:when test="$field/@type"><xsl:value-of select="$field/@type"/></xsl:when><xsl:otherwise>string</xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:if test="$field/@list">
					<xsl:attribute name="list"><xsl:value-of select="$field/@list"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@mode">
					<xsl:attribute name="mode"><xsl:value-of select="@mode"/></xsl:attribute>
				</xsl:if>
			</xsl:element>
		</xsl:for-each>
	</documentbase>
</xsl:template>
</xsl:stylesheet>
