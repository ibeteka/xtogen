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
<xsl:param name="structure_file"/>
<xsl:param name="dest_dir"/>
<xsl:param name="file_url_prefix"/>

<xsl:variable name="langs" select="document(concat($file_url_prefix,$structure_file))/application/languages"/>

<xsl:template match="/display/application">
	<xsl:variable name="node" select="."/>
	<xsl:for-each select="$langs/lang">
		<xsl:variable name="lang_code" select="@id"/>
		<xsl:variable name="output"
			select="concat($dest_dir,'/',$lang_code,'/',$lang_code,'_display_gen.xml')"/>
		<xsl:call-template name="generate-file">
			<xsl:with-param name="output" select="$output"/>
			<xsl:with-param name="node" select="$node"/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template name="generate-file">
	<xsl:param name="output"/>
	<xsl:param name="node"/>
	<saxon:output href="{$output}">
<xsl:text>
</xsl:text>
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
	<xsl:for-each select="$node/static/page">
<xsl:text>
	</xsl:text>
		<xsl:comment>&#160;Page statique "<xsl:value-of select="."/>"&#160;</xsl:comment>
		<label id="static.bouton.{.}">[<xsl:value-of select="."/>]</label>
		<label id="static.tooltip.{.}">[<xsl:value-of select="."/>]</label>
		<label id="static.pagetitle.{.}">[<xsl:value-of select="."/>]</label>
	</xsl:for-each>
</labels>
	</saxon:output>
</xsl:template>

</xsl:stylesheet>
