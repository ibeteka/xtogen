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
	<xsl:variable name="formDisplay" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes"/>
	<xsp:page
		language="java"
		xmlns:xsp="http://apache.org/xsp"
		xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx">
		<sdx:page langSession="lang" langParam="lang">
		<bar/>
		<script/>
		<title id="title.search"/>

			<xtg:authentication domain="search">
			<xsl:apply-templates select="/application/documenttypes/documenttype">
				<xsl:with-param name="formDisplay" select="$formDisplay"/>
			</xsl:apply-templates>
			</xtg:authentication>

		</sdx:page>

	</xsp:page>
</xsl:template>
<xsl:template match="documenttype">
	<xsl:param name="formDisplay"/>
	<xsl:variable name="id" select="@id"/>
	<xsl:if test="count($formDisplay/documenttype[@id=$id]/search/on) &gt; 0">
		<recherche db="{$id}">
			<xsl:call-template name="copy-location">
				<xsl:with-param name="location" select="location"/>
			</xsl:call-template>
			<xsl:apply-templates select="$formDisplay/documenttype[@id=$id]/search/on">
				<xsl:with-param name="docstructure" select="."/>
			</xsl:apply-templates>
		</recherche>
	</xsl:if>
</xsl:template>

<xsl:template match="on">
	<xsl:param name="docstructure"/>
	<xsl:variable name="doc" select="$docstructure/@id"/>
	<xsl:variable name="fieldname" select="@field"/>
	<xsl:variable name="field" select="$docstructure/fields/descendant-or-self::field[@name=$fieldname]"/>
	<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="$field/@type"><xsl:value-of select="$field/@type"/></xsl:when>
			<xsl:otherwise>string</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:if test="$type='string' or $type='text' or $type='email'">
		<zone type="texte" name="{$xtg_wordprefix}{@field}">
			<xsl:if test="$field/@lang='multi'"><xsl:attribute name="lang">multi</xsl:attribute></xsl:if>
		</zone>
	</xsl:if>
	<xsl:if test="$type = 'choice'">
		<xsl:element name="zone">
			<xsl:attribute name="type">choice</xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="@field"/></xsl:attribute>
			<xsl:if test="$field/@list">
				<xsl:attribute name="list"><xsl:value-of select="$field/@list"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="mode">
				<xsl:choose>
					<xsl:when test="@mode"><xsl:value-of select="@mode"/></xsl:when>
					<xsl:otherwise>Mcombo</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="sort">
				<xsl:choose>
					<xsl:when test="@sort='true'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:element>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
