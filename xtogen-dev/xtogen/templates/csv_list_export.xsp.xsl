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
<xsl:output method="xml"/>

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
	<xsp:page language="java" xmlns:xsp="http://apache.org/xsp" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx" xmlns:xtg="http://xtogen.tech.fr">
		<sdx:page langSession="lang" langParam="lang">
			<xtg:authentication domain="list">
				<xsl:variable name="defaultLang" select="//languages/lang[@default]/@id"/>
				<xsp:logic>
					request.setCharacterEncoding("UTF8");
				</xsp:logic>
				<csv>
					<conf>
						<format><xsp:expr>request.getParameter("csv.format")</xsp:expr></format>
						<separator><xsp:expr>request.getParameter("csv.sep")</xsp:expr></separator>
						<quote><xsp:expr>request.getParameter("csv.quote")</xsp:expr></quote>
					</conf>
					<data>
						<header>
							<col>id</col>
							<col><xsl:value-of select="$defaultLang"/></col>
							<xsl:for-each select="//languages/lang[not(@default)]">
							<col><xsl:value-of select="@id"/></col></xsl:for-each>
						</header>

				<xsp:logic>
					// Base directory
					String baseDir
						= fr.tech.sdx.xtogen.util.FileHelper.getBaseDir(context,request)
						+ File.separator + "xsl"
						+ File.separator + "lang"
						+ File.separator + "liste"
						+ File.separator;

					<xsl:for-each select="//languages/lang">
						fr.tech.sdx.xtogen.list.StringOrderedMap <xsl:call-template name="varName"><xsl:with-param name="lang" select="@id"/></xsl:call-template>
						= new fr.tech.sdx.xtogen.list.ExternalListEditor(new File(baseDir
						+ "<xsl:value-of select="@id"/>" + File.separator + "<xsl:value-of select="@id"/>_"
						+ request.getParameter("list") + ".xml")).getValues();
					</xsl:for-each>

					// Et valeurs
					String[] keys = <xsl:call-template name="varName"><xsl:with-param name="lang" select="$defaultLang"/></xsl:call-template>.keys();
					for (int i=0; i&lt;keys.length; i++)
					{
						String id = keys[i];
						<row>
						<value col="id"><xsp:expr>id</xsp:expr></value>
						<value col="{$defaultLang}"><xsp:expr><xsl:call-template name="varName"><xsl:with-param name="lang" select="$defaultLang"/></xsl:call-template>.get(id)</xsp:expr></value>
						<xsl:for-each select="//languages/lang[not(@default)]">
						<value col="{@id}"><xsp:expr><xsl:call-template name="varName"><xsl:with-param name="lang" select="@id"/></xsl:call-template>.get(id)</xsp:expr></value></xsl:for-each>
						</row>
					}
				</xsp:logic>
					</data>
				</csv>
			</xtg:authentication>
		</sdx:page>
	</xsp:page>
</xsl:template>

<xsl:template name="varName">
	<xsl:param name="lang"/>som<xsl:value-of select="concat(substring-before($lang,'-'),substring-after($lang,'-'))"/>
</xsl:template>

</xsl:stylesheet>
