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
	<xsp:page language="java"
		xmlns:xsp="http://apache.org/xsp"
		xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
		xmlns:xtg="http://xtogen.tech.fr">
		<sdx:page langSession="lang" langParam="lang">
			<title id="title.static"/>
			<xsp:logic>
			String pageToDisplay = request.getParameter("page");

			// Paramètre non renseigné
			if (pageToDisplay == null)
			{
				<error id="pasdepagedemandee"/>
			}

			<xsl:if test="count(/display/application/static/page[@private='true'])!=0">
			// Pages privées
			else if (<xsl:call-template name="testPrivatePages"/>)
			{
				<xtg:authentication domain="static">
					<static/>
				</xtg:authentication>
			}
			</xsl:if>

			<xsl:if test="count(/display/application/static/page[not(@private)])!=0">
			// Pages publiques
			else if (<xsl:call-template name="testPublicPages"/>)
			{
				<static/>
			}
			</xsl:if>

			// Pages non déclarées
			else
			{
				<error id="pagenondeclaree">
					<page><xsp:expr>pageToDisplay</xsp:expr></page>
				</error>
			}
			</xsp:logic>
		</sdx:page>
	</xsp:page>
</xsl:template>

<xsl:template name="testPrivatePages">
	<xsl:for-each select="/display/application/static/page[@private='true']">
		<xsl:if test="position()!=1"> || </xsl:if>pageToDisplay.equals("<xsl:value-of select="."/>")</xsl:for-each>
</xsl:template>

<xsl:template name="testPublicPages">
	<xsl:for-each select="/display/application/static/page[not(@private)]">
		<xsl:if test="position()!=1"> || </xsl:if>pageToDisplay.equals("<xsl:value-of select="."/>")</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
