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
	xmlns:saxon="http://icl.com/saxon"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="sdx">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="dest_dir">.</xsl:param>
<xsl:param name="appli_name"/>
<xsl:param name="display_config_file"/>
<xsl:param name="file_url_prefix"/>

<xsl:variable name="langs" select="//languages"/>

<xsl:template match="/">
	<xsl:for-each select="$langs/lang">
		<xsl:variable name="output"
			select="concat($dest_dir,'/', @id, '_document_gen.xml')"/>
		<xsl:call-template name="generate-file">
			<xsl:with-param name="output" select="$output"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template name="generate-file">
	<xsl:param name="output"/>

	<saxon:output href="{$output}">
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
<labels>
	<application><xsl:value-of select="$appli_name"/></application>
	<xsl:apply-templates select="//documenttype"/>
</labels>
	</saxon:output>
</xsl:template>

<xsl:template match="documenttype">
	<xsl:variable name="doctype" select="@id"/>
	<xsl:text>
</xsl:text>
	<xsl:comment><xsl:text> </xsl:text><xsl:value-of select="@id"/><xsl:text> </xsl:text></xsl:comment>
	<doctype name="{@id}">
		<label>[<xsl:value-of select="@id"/>]</label>
		<xsl:apply-templates select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes/documenttype[@id=$doctype]/sort">
			<xsl:with-param name="defaultfield" select="fields/descendant-or-self::field[@default]/@name"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes/documenttype[@id=$doctype]/nav"/>
		<xsl:apply-templates select="fields/field|fields/fieldgroup"/>
		<xsl:for-each select="//documenttype/fields/descendant-or-self::field[@type='relation' and @to=$doctype]">
			<xsl:variable name="reldoc" select="../ancestor::documenttype/@id"/>
			<vfield doc="{$reldoc}" field="{@name}">
				<one>[<xsl:value-of select="$reldoc"/> associé:]</one>
				<more>[<xsl:value-of select="$reldoc"/> associés:]</more>
			</vfield>
		</xsl:for-each>
	</doctype>
</xsl:template>

<xsl:template match="sort">
	<xsl:param name="defaultfield"/>

	<xsl:choose>
		<xsl:when test="@default"><sort field="{@default}">[<xsl:value-of select="@default"/>]</sort></xsl:when>
		<xsl:otherwise><sort field="{$defaultfield}">[<xsl:value-of select="$defaultfield"/>]</sort></xsl:otherwise>
	</xsl:choose>
	<xsl:for-each select="on">
		<sort field="{@field}">[<xsl:value-of select="@field"/>]</sort>
	</xsl:for-each>
</xsl:template>

<xsl:template match="nav">
	<xsl:for-each select="on">
		<nav field="{@field}">
			<link>[Liste par <xsl:value-of select="@field"/>]</link>
			<title>[<xsl:value-of select="@field"/>]</title>
			<subtitle>[<xsl:value-of select="../../@id"/> par <xsl:value-of select="@field"/> = #]</subtitle>
		</nav>
	</xsl:for-each>
</xsl:template>

<xsl:template match="field">
	<field name="{@name}">[<xsl:value-of select="@name"/>:]</field>
</xsl:template>

<xsl:template match="fieldgroup">
	<fieldgroup name="{@name}">[<xsl:value-of select="@name"/>]</fieldgroup>
	<xsl:apply-templates select="field|fieldgroup"/>
</xsl:template>

</xsl:stylesheet>
