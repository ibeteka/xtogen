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
<xsl:param name="file_url_prefix"/>
<xsl:param name="structure_file"/>
<xsl:output method="xml" indent="yes"/>

<xsl:variable name="docs_info"
	select="document(concat($file_url_prefix,$structure_file))/application/documenttypes"/>

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
<configuration_display>
	<xsl:apply-templates select="//static"/>
	<xsl:apply-templates select="//templates"/>
	<xsl:apply-templates select="//documenttypes"/>
</configuration_display>
</xsl:template>

<xsl:template match="static">
	<static>
		<xsl:for-each select="page">
			<xsl:copy>
				<xsl:variable name="page" select="."/>
				<xsl:if test="//security/domain[@id='interface']/domain[@id='static']/page/text()=$page">
					<xsl:attribute name="private">yes</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$page"/>
			</xsl:copy>
		</xsl:for-each>
	</static>
</xsl:template>

<xsl:template match="templates">
	<templates>
		<xsl:for-each select="template">
			<xsl:copy>
				<xsl:copy-of select="@*"/>
			</xsl:copy>
		</xsl:for-each>
	</templates>
</xsl:template>

<xsl:template match="documenttypes">
	<xsl:copy>
		<xsl:apply-templates select="documenttype"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="documenttype">
	<xsl:variable name="id" select="@id"/>
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:call-template name="security">
			<xsl:with-param name="doctype" select="@id"/>
		</xsl:call-template>
		<xsl:apply-templates select="edit"/>
		<xsl:apply-templates select="document"/>
		<xsl:apply-templates select="nav"/>
		<xsl:apply-templates select="search"/>
		<xsl:apply-templates select="sort">
			<xsl:with-param name="docinfo" select="$docs_info/documenttype[@id=$id]"/>
		</xsl:apply-templates>
	</xsl:copy>
</xsl:template>

<xsl:template match="edit|document|nav|search">
	<xsl:copy>
		<xsl:apply-templates select="global"/>
		<xsl:apply-templates select="on"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="global">
	<xsl:copy>
		<xsl:apply-templates select="input|textarea|select"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="input|textarea|select">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="on">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
	</xsl:copy>
</xsl:template>

<xsl:template name="security">
	<xsl:param name="doctype"/>

	<xsl:variable name="docnode" select="//security/domain[@id='document']/documenttype[@id=$doctype]"/>
	<xsl:if test="$docnode">
		<xsl:apply-templates select="$docnode/control"/>
	</xsl:if>
</xsl:template>

<xsl:template match="control">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:copy-of select="group"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="sort">
	<xsl:param name="docinfo"/>

	<sort>
		<on>
			<xsl:choose>
				<xsl:when test="@default"><xsl:attribute name="field"><xsl:value-of select="@default"/></xsl:attribute></xsl:when>
				<xsl:otherwise><xsl:attribute name="field"><xsl:value-of select="$docinfo/fields/descendant-or-self::field[@default]/@name"/></xsl:attribute></xsl:otherwise>
			</xsl:choose>
			<xsl:attribute name="default">true</xsl:attribute>
		</on>
		<xsl:apply-templates select="on"/>
	</sort>
</xsl:template>

</xsl:stylesheet>
