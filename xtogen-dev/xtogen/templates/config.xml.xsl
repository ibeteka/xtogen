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
	exclude-result-prefixes="sdx">
<xsl:output method="xml" indent="yes"/>

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
<configuration>
	<xsl:apply-templates select="//languages"/>
	<dbases>
		<xsl:apply-templates select="//documenttype" mode="dbase"/>
	</dbases>

	<relations>
		<xsl:apply-templates select="//documenttype" mode="relation"/>
	</relations>

	<lists>
		<xsl:apply-templates select="//documenttype" mode="list"/>
	</lists>

	<fields>
		<xsl:apply-templates select="//documenttype" mode="field"/>
	</fields>

</configuration>
</xsl:template>

<xsl:template match="languages">
	<languages>
	<xsl:for-each select="lang">
		<xsl:copy-of select="."/>
	</xsl:for-each>
	</languages>
</xsl:template>

<!-- DBase -->
<xsl:template match="documenttype" mode="dbase">
	<xsl:element name="dbase">
		<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
		<xsl:if test="location">
			<xsl:attribute name="external">yes</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="fields/descendant-or-self::field[@default]/@name"/>
	</xsl:element>
</xsl:template>

<!-- Relation -->
<xsl:template match="documenttype" mode="relation">
	<xsl:variable name="docid" select="@id"/>
	<xsl:for-each select="fields/descendant-or-self::field[@type='relation']">
		<relation doc="{$docid}" field="{@name}"><xsl:value-of select="@to"/></relation>
	</xsl:for-each>
</xsl:template>

<!-- List -->
<xsl:template match="documenttype" mode="list">
	<xsl:variable name="docid" select="@id"/>
	<xsl:for-each select="fields/descendant-or-self::field[@type='choice']">
		<list doc="{$docid}" field="{@name}"><xsl:value-of select="@list"/></list>
	</xsl:for-each>
</xsl:template>

<!-- Field -->
<xsl:template match="documenttype" mode="field">
	<document id="{@id}">
		<xsl:apply-templates select="fields/field[not(@type) or @type!='attach']|fields/fieldgroup" mode="field">
			<xsl:with-param name="path"/>
		</xsl:apply-templates>
	</document>
</xsl:template>

<xsl:template match="field" mode="field">
	<xsl:param name="path"/>

	<xsl:variable name="fp">
		<xsl:value-of select="$path"/>
		<xsl:if test="$path!=''">/</xsl:if>
		<xsl:choose>
			<xsl:when test="@path"><xsl:value-of select="@path"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="@type"><xsl:value-of select="@type"/></xsl:when>
			<xsl:otherwise>string</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<field name="{@name}" path="{$fp}" type="{$type}"/>
</xsl:template>

<xsl:template match="fieldgroup" mode="field">
	<xsl:param name="path"/>

	<xsl:variable name="fp">
		<xsl:value-of select="$path"/>
		<xsl:if test="$path!=''">/</xsl:if>
		<xsl:choose>
			<xsl:when test="@path"><xsl:value-of select="@path"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<fieldgroup name="{@name}">
	<xsl:apply-templates select="field[not(@type) or @type!='attach']|fieldgroup" mode="field">
		<xsl:with-param name="path" select="$fp"/>
	</xsl:apply-templates>
	</fieldgroup>
</xsl:template>

</xsl:stylesheet>
