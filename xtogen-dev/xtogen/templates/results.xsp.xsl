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
	<xsp:page language="java" xmlns:xsp="http://apache.org/xsp" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx">
		<sdx:page langSession="lang" langParam="lang">
			<bar/>
			<title id="title.results"/>
			<xsl:variable name="sf">sdxdbid<xsl:apply-templates select="//documenttype" mode="title"/></xsl:variable>
			<xtg:authentication domain="search">
			<xsp:logic>
				request.setCharacterEncoding("UTF8");

				String myField = "xtgpleintexte";
				String myValue = request.getParameter("q") == null ? "" : request.getParameter("q");

				String queryLanguage = request.getParameter("qlang");
				if (queryLanguage != null &amp;&amp; !"".equals(queryLanguage))
				{
					myField = "xtgpleintexte_" + queryLanguage.replace('-','_');

					if (queryLanguage.startsWith("ar-"))
					{
						<!-- Code de traitement des requêtes en arabe 
							 de Pierrick Brihaye, merci à lui !       -->
						gpl.pierrick.brihaye.aramorph.AraMorph araMorph
							= new gpl.pierrick.brihaye.aramorph.AraMorph();
						if (!"".equals(myValue))
						{
							// Arabize a query in the Buckwalter transliteration			
							myValue = araMorph.arabizeWord(myValue);
						}
					}
				}
			</xsp:logic>
			<sdx:executeSimpleQuery sf="{normalize-space($sf)}" hilite="true" queryString="myValue" fieldString="myField">
				<xsl:apply-templates select="//documenttype"/>
			</sdx:executeSimpleQuery>
			</xtg:authentication>
		</sdx:page>
	</xsp:page>
</xsl:template>

<xsl:template match="documenttype" mode="title">
<xsl:text> </xsl:text><xsl:value-of select="fields/descendant-or-self::field[@default]/@name"/>
</xsl:template>

<xsl:template match="documenttype">
	<xsl:choose>
		<xsl:when test="location">
			<xsl:variable name="base" select="@id"/>
			<xsl:call-template name="copy-location">
				<xsl:with-param name="location" select="location"/>
				<xsl:with-param name="sdxlocation">yes</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<sdx:location base="{@id}"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
