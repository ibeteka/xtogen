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
<xsl:output method="xml" indent="yes"/>
<xsl:param name="file_url_prefix"/>
<xsl:param name="display_config_file"/>

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
	<xsl:variable name="listInfo" select="document(concat($file_url_prefix,$display_config_file))/display/lists"/>
	<xsp:page language="java" xmlns:xsp="http://apache.org/xsp" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx" xmlns:xtg="http://xtogen.tech.fr">
		<sdx:page langSession="lang" langParam="lang">
			<title id="title.admin"/>
			<bar/>
			<xtg:authentication domain="list">
				<xsp:logic>
					// To be sure, it's ok
					request.setCharacterEncoding("UTF8");

					// Base directory
					String baseDir
						= fr.tech.sdx.xtogen.util.FileHelper.getBaseDir(context,request)
						+ File.separator + "xsl"
						+ File.separator + "lang"
						+ File.separator + "liste"
						+ File.separator;
					String fileName = null;
					String myLang	= null;

					String op = request.getParameter("op");
					if ("mod".equals(op))
					{
						String id		= request.getParameter("id");
						String list		= request.getParameter("list");
						String value	= request.getParameter("value");

						myLang			= request.getParameter("myLang");
						
						
						fr.tech.sdx.xtogen.list.ExternalListEditor elt = null;
						<xtg:createExternalListEditor var="elt" dirvar="baseDir" langvar="myLang" op="mod" id="id" value="value"/>
					}
					else if ("predel".equals(op))
					{
						<question/>
					}
					else if ("del".equals(op))
					{
						String id		= request.getParameter("id");
						String list		= request.getParameter("list");
						
						fr.tech.sdx.xtogen.list.ExternalListEditor elt = null;
						<xsl:for-each select="//languages/lang">
							myLang = "<xsl:value-of select="@id"/>";
							<xtg:createExternalListEditor var="elt" dirvar="baseDir" langvar="myLang" op="del" id="id"/>
						</xsl:for-each>
					}
					else if ("add".equals(op))
					{
						<xsl:variable name="defaultLang" select="//languages/lang[@default]/@id"/>
						String list				= request.getParameter("list");
						String id				= request.getParameter("id");
						String defaultFilename	= baseDir + "<xsl:value-of select="$defaultLang"/>" + File.separator
							+ "<xsl:value-of select="$defaultLang"/>_"  + list + ".xml";
						fr.tech.sdx.xtogen.list.ExternalListEditor defaultEle
							= new fr.tech.sdx.xtogen.list.ExternalListEditor(new File(defaultFilename));

						if ("".equals(id))
						{
							<error key="valeursvides"/>
						}
						else if (defaultEle.containsId(id))
						{
							<error key="iddejautilise">
								<xsp:attribute name="file"><xsp:expr>defaultFilename</xsp:expr></xsp:attribute>
							</error>
						}
						else if (<xsl:for-each select="//languages/lang"><xsl:if test="position()!=1"> &amp;&amp; </xsl:if>"".equals(request.getParameter("value_<xsl:value-of select="@id"/>"))</xsl:for-each>)
						{
							<error key="valeursvides"/>
						}
						else
						{
						String value = null;
						fr.tech.sdx.xtogen.list.ExternalListEditor elt = null;
						<xsl:for-each select="//languages/lang">
							myLang = "<xsl:value-of select="@id"/>";
							value = request.getParameter("value_<xsl:value-of select="@id"/>");
							<xtg:createExternalListEditor var="elt" dirvar="baseDir" langvar="myLang" op="add" id="id" value="value"/>
						</xsl:for-each>
						}
					}
				</xsp:logic>
				<file>
					<basedir><xsp:expr>baseDir</xsp:expr></basedir>
					<list><xsp:expr>request.getParameter("list")</xsp:expr></list>
					<files>
						<xsl:for-each select="//languages/lang">
							<xsp:logic>
								fileName = baseDir + "<xsl:value-of select="@id"/>"
									+ File.separator + "<xsl:value-of select="@id"/>_"
									+ request.getParameter("list");
							</xsp:logic>
							<file lang="{@id}"><xsl:value-of select="$file_url_prefix"/><xsp:expr>fileName</xsp:expr>.xml</file>
						</xsl:for-each>
					</files>
					<langs>
						<xsl:for-each select="//languages/lang">
							<lang id="{@id}">
								<xsl:if test="@default">
									<xsl:attribute name="default"><xsl:value-of select="@default"/></xsl:attribute>
								</xsl:if>
								<xsl:if test="@label">
									<xsl:attribute name="label"><xsl:value-of select="@label"/></xsl:attribute>
								</xsl:if>
							</lang>
						</xsl:for-each>
					</langs>
					<lists>
						<xsl:for-each select="$listInfo/list">
							<xsl:copy>
								<xsl:copy-of select="@*"/>
							</xsl:copy>
						</xsl:for-each>
					</lists>
				
				</file>
			</xtg:authentication>
		</sdx:page>
	</xsp:page>
</xsl:template>

</xsl:stylesheet>
