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
	xmlns:xtg="http://xtogen.tech.fr"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="saxon xtg">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="dest_dir">.</xsl:param>

<xsl:include href="xtogen-common-functions.xsl"/>

<xsl:template match="/">
	<xsl:apply-templates select="//documenttype"/>
</xsl:template>

<xsl:template match="documenttype">
	<xsl:variable name="output" select="concat($dest_dir,'/csv_base_',@id,'_export.xsl')"/>
	<saxon:output href="{$output}">
	<xsl:variable name="currentid" select="@id"/>
	<xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
		<xsl:copy-of select="document('csv_base_doctype_export.xsl.xsl')//namespace::*[.='http://www.culture.gouv.fr/ns/sdx/sdx']"/>
		<xsl:attribute name="version">1.0</xsl:attribute>
		<xsl:attribute name="exclude-result-prefixes">xsl</xsl:attribute>
		<xsl:element name="xsl:output">
			<xsl:attribute name="method">xml</xsl:attribute>
			<xsl:attribute name="indent">yes</xsl:attribute>
			<xsl:attribute name="encoding">UTF-8</xsl:attribute>
		</xsl:element>
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

		<xsl:text>

	</xsl:text>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match">/sdx:document/admin</xsl:attribute>
			<csv>
				<conf>
					<format><xsl:element name="xsl:value-of"><xsl:attribute name="select">csvformat</xsl:attribute></xsl:element></format>
					<separator><xsl:element name="xsl:value-of"><xsl:attribute name="select">csvsep</xsl:attribute></xsl:element></separator>
					<quote><xsl:element name="xsl:value-of"><xsl:attribute name="select">csvquote</xsl:attribute></xsl:element></quote>
					<mvseparator><xsl:element name="xsl:value-of"><xsl:attribute name="select">csvmvsep</xsl:attribute></xsl:element></mvseparator>
				</conf>
				<data>
					<header>
						<col>id</col><xsl:for-each select="fields/descendant-or-self::field[not(@type) or @type!='attach']"><col><xsl:value-of select="@name"/></col></xsl:for-each>
					</header>
					<xsl:element name="xsl:for-each">
						<xsl:attribute name="select">//<xsl:value-of select="@id"/></xsl:attribute>
					<row>
						<value col="id">
							<xsl:element name="xsl:choose">
								<xsl:element name="xsl:when">
									<xsl:attribute name="test">@id</xsl:attribute>
									<xsl:element name="xsl:value-of"><xsl:attribute name="select">@id</xsl:attribute></xsl:element>
								</xsl:element>
								<xsl:element name="xsl:otherwise">
									<xsl:element name="xsl:value-of"><xsl:attribute name="select">../sdx:field[@name='sdxdocid']/@value</xsl:attribute></xsl:element>
								</xsl:element>
							</xsl:element>
						</value>
						<xsl:for-each select="fields/descendant-or-self::field[not(@type) or @type!='attach']">
						<xsl:variable name="fp">
							<xsl:call-template name="computeUniqueFullPath">
								<xsl:with-param name="field" select="."/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:element name="xsl:if">
							<xsl:attribute name="test">count(<xsl:value-of select="$fp"/>)=1</xsl:attribute>
							<value col="{@name}"><xsl:element name="xsl:value-of"><xsl:attribute name="select"><xsl:value-of select="$fp"/></xsl:attribute></xsl:element></value>
						</xsl:element>
						<xsl:element name="xsl:if">
							<xsl:attribute name="test">count(<xsl:value-of select="$fp"/>)&gt;1</xsl:attribute>
							<xsl:element name="xsl:for-each">
								<xsl:attribute name="select"><xsl:value-of select="$fp"/></xsl:attribute>
								<value col="{@name}"><xsl:element name="xsl:value-of"><xsl:attribute name="select">.</xsl:attribute></xsl:element></value>
							</xsl:element>
						</xsl:element>
						</xsl:for-each>
					</row>
					</xsl:element>
				</data>
			</csv>
		</xsl:element>
	</xsl:element>
	</saxon:output>
</xsl:template>

</xsl:stylesheet>
