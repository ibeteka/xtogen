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
	exclude-result-prefixes="sdx saxon">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="dest_dir">.</xsl:param>

<xsl:include href="xtogen-common-functions.xsl"/>

<xsl:template match="documenttype">
	<xsl:variable name="output" select="concat($dest_dir,'/terms_',@id,'.xsp')"/>
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
	<xsp:page language="java" xmlns:xsp="http://apache.org/xsp" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx">
		<sdx:page langSession="lang" langParam="lang">
			<xsp:logic>
				request.setCharacterEncoding("UTF8");

				// On vérifie l'accès à la XSP
				if (request.getRequestURI().endsWith(".xsp"))
				{
					<bar/>
					<title id="title.liste"/>
					<xtg:authentication domain="nav">
						<xsl:element name="documentbase">
							<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
							<xsl:for-each select="location">
								<app><xsl:value-of select="@app"/></app>
							</xsl:for-each>
						</xsl:element>
						<sdx:terms>
							<xsl:variable name="base" select="@id"/>
							<xsl:choose>
								<xsl:when test="location">
									<xsl:call-template name="copy-location">
										<xsl:with-param name="location" select="location"/>
										<xsl:with-param name="sdxlocation">yes</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<sdx:location base="{$base}"/>
								</xsl:otherwise>
							</xsl:choose>
						</sdx:terms>
					</xtg:authentication>
				}
				// Sinon autorisé seulement en accès local
				else //if ("127.0.0.1".equals(request.getRemoteAddr()))
				{
					<sdx:terms>
						<xsl:variable name="base" select="@id"/>
						<xsl:choose>
							<xsl:when test="location">
								<xsl:call-template name="copy-location">
									<xsl:with-param name="location" select="location"/>
									<xsl:with-param name="sdxlocation">yes</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<sdx:location base="{$base}"/>
							</xsl:otherwise>
						</xsl:choose>
					</sdx:terms>
				}
			</xsp:logic>
		</sdx:page>
	</xsp:page>
	</saxon:output>
</xsl:template>

</xsl:stylesheet>
