<?xml version="1.0" encoding="utf-8"?>
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
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
   	xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
	version="1.0" exclude-result-prefixes="xsl sdx">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

	<xsl:import href="vars.xsl"/>
	<xsl:import href="zip_export_all_docs.xsl"/>

	<!-- Base -->
	<xsl:variable name="base" select="$urlparameter[@name='db']/@value"/>

	<!-- Pour traiter les documents XML -->
	<xsl:template name="manageDocuments">
		<xsl:param name="results"/>

		<xsl:variable name="exportUrl" select="concat(/sdx:document/@server,'/',/sdx:document/@appbypath,'/export.xsp?db=',$base,'&amp;')"/>

		<xsl:for-each select="$results">
			<xsl:variable name="docid" select="sdx:field[@name='sdxdocid']/@value"/>
			<xsl:variable name="resultid" select="@no"/>
			<zip:entry>
				<xsl:attribute name="name">
					<xsl:value-of select="concat($base,'_',sdx:field[@name='sdxdocid']/@value,'.xml')"/>
				</xsl:attribute>
				<xsl:attribute name="src">
					<xsl:value-of select="concat($exportUrl,'id=',sdx:field[@name='sdxdocid']/@value)"/>
				</xsl:attribute>
			</zip:entry>
		</xsl:for-each>
	</xsl:template>
	
	<!-- Pour traiter les attachements -->
	<xsl:template name="manageAttach">
		<xsl:param name="result"/>
		<xsl:param name="attachfieldname"/>

		<xsl:variable name="docid" select="$result/sdx:field[@name='sdxdocid']/@value"/>
		<xsl:variable name="attachUrl" select="concat(/sdx:document/@api-url,'/getatt?app=',/sdx:document/@app,'&amp;base=',$base,'&amp;')"/>

		<xsl:for-each select="$result/sdx:field[@name=$attachfieldname]">
			<xsl:variable name="thn" select="substring-before(@value,'||')"/>
			<xsl:if test="$thn!=''">
				<zip:entry name="{$thn}" src="{$attachUrl}id={$thn}&amp;doc={$docid}"/>
			</xsl:if>
			<xsl:variable name="attach" select="substring-after(substring-after(@value,'||'),'||')"/>
			<xsl:if test="$attach!=''">
				<zip:entry name="{$attach}" src="{$attachUrl}id={$attach}&amp;doc={$docid}"/>
			</xsl:if>
		</xsl:for-each>
   </xsl:template>
</xsl:stylesheet>
