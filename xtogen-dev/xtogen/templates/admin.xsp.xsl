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
	xmlns:xsp="http://apache.org/xsp"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	exclude-result-prefixes="sdx">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="display_config_file"/>
<xsl:param name="file_url_prefix"/>

<xsl:variable name="doctypes" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes"/>

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
	<xsl:variable name="modules" select="document(concat($file_url_prefix,$display_config_file))/display/application/modules"/>
	<xsp:page language="java"
		xmlns:xsp="http://apache.org/xsp"
		xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
		xmlns:xtg="http://xtogen.tech.fr">
		<sdx:page langSession="lang" langParam="lang">
			<title id="title.admin"/>
			<bar/>
			<xtg:authentication domain="base|list|edit">
				<admin>
				<xsl:apply-templates select="//documenttype" mode="document"/>
				</admin>
				<xsl:variable name="fields" select="//documenttype/fields/descendant-or-self::field[@type='choice' and @list]"/>
				<xsl:if test="count($fields) != 0 and count($modules/module[@id='externallistedition' and @disable='true']) = 0">
					<lists>
					<xsp:logic>
						<xsl:variable name="defaultLang" select="//languages/lang[@default]/@id"/>
						String baseDir = fr.tech.sdx.xtogen.util.FileHelper.getBaseDir(context,request);
						String filePrefix = baseDir + File.separator + "xsl" + File.separator
							+ "lang" + File.separator + "liste" + File.separator
							+ "<xsl:value-of select="$defaultLang"/>"
							+ File.separator + "<xsl:value-of select="$defaultLang"/>_";
					</xsp:logic>
					<xsl:apply-templates select="$fields" mode="list"/>
					</lists>
				</xsl:if>
			</xtg:authentication>
		</sdx:page>
	</xsp:page>
</xsl:template>

<xsl:template match="documenttype" mode="document">
	<xsl:variable name="displaydoctype" select="$doctypes/documenttype[@id=current()/@id]"/>
	<xsl:element name="document">
		<xsl:attribute name="base"><xsl:value-of select="@id"/></xsl:attribute>
		<xsl:if test="location">
			<xsl:attribute name="external">yes</xsl:attribute>
		</xsl:if>
		<xsl:if test="fields/descendant-or-self::field[@type='attach' or @type='image'] and not($displaydoctype/edit/on[@mode='upload'])">
			<xsl:attribute name="with-attach">yes</xsl:attribute>
		</xsl:if>
	</xsl:element>
</xsl:template>

<xsl:template match="field" mode="list">
	<xsl:variable name="list" select="@list"/>
	<xsl:if test="count(preceding::field[@list=$list])=0">
		<list name="{@list}">
			<xsp:logic>
			<nb><xsp:expr>new fr.tech.sdx.xtogen.list.ExternalListEditor(new File(filePrefix + "<xsl:value-of select="@list"/>.xml")).getItemCount()</xsp:expr></nb>
			</xsp:logic>
		</list>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
