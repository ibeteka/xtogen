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
				<xsp:logic>
					// Base directory
					String baseDir
						= fr.tech.sdx.xtogen.util.FileHelper.getBaseDir(context,request)
						+ File.separator + "xsl"
						+ File.separator + "lang"
						+ File.separator + "liste"
						+ File.separator;

					<xsl:variable name="defaultLang" select="//languages/lang[@default]/@id"/>
					<xsl:for-each select="//languages/lang">
						fr.tech.sdx.xtogen.list.ExternalListEditor <xsl:call-template name="varName"><xsl:with-param name="lang" select="@id"/></xsl:call-template>
						= new fr.tech.sdx.xtogen.list.ExternalListEditor(new File(baseDir
						+ "<xsl:value-of select="@id"/>" + File.separator + "<xsl:value-of select="@id"/>_"
						+ request.getParameter("list") + ".xml"));
						String col<xsl:call-template name="idlang"><xsl:with-param name="lang" select="@id"/></xsl:call-template> = request.getParameter("lang.<xsl:call-template name="idlang"><xsl:with-param name="lang" select="@id"/></xsl:call-template>");
					</xsl:for-each>

					File csvFile = new File(request.getParameter("csv.file"));
					String csvFormat = request.getParameter("csv.format");
					String csvSeparator = request.getParameter("csv.sep");
					String csvQuote = request.getParameter("csv.quote");
					fr.tech.sdx.xtogen.list.CSVListParser clp
						= new fr.tech.sdx.xtogen.list.CSVListParser(csvFile, csvFormat, csvSeparator, csvQuote);
					clp.reset();
					clp.getHeaders();
					
					java.util.Properties	values				= null;
					String 		id					= null;
					String		idColumn			= request.getParameter("identcol");
					boolean		idHasToBeGenerated	= "generated".equals(request.getParameter("ident"));
					int			rowCount			= 0;
					while (clp.hasRow())
					{
						values = clp.getRow();

						if (idHasToBeGenerated)
								id = <xsl:call-template name="varName"><xsl:with-param name="lang" select="$defaultLang"/></xsl:call-template>.newId();
						else	id = values.getProperty(idColumn);

					<xsl:for-each select="//languages/lang">
						if (col<xsl:call-template name="idlang"><xsl:with-param name="lang" select="@id"/></xsl:call-template> != null &amp;&amp; !"---".equals(col<xsl:call-template name="idlang"><xsl:with-param name="lang" select="@id"/></xsl:call-template>))	
							<xsl:call-template name="varName"><xsl:with-param name="lang" select="@id"/></xsl:call-template>.changeValue(id, values.getProperty(col<xsl:call-template name="idlang"><xsl:with-param name="lang" select="@id"/></xsl:call-template>));
					</xsl:for-each>
						rowCount++;
					}
					clp.close();
					
					<xsl:for-each select="//languages/lang">
						<xsl:call-template name="varName"><xsl:with-param name="lang" select="@id"/></xsl:call-template>.save();
					</xsl:for-each>

					csvFile.delete();
					
					<xsp:element name="success">
						<list><xsp:expr>request.getParameter("list")</xsp:expr></list>
						<rownumber><xsp:expr>rowCount</xsp:expr></rownumber>
					</xsp:element>
				</xsp:logic>
			</xtg:authentication>
		</sdx:page>
	</xsp:page>
</xsl:template>

<xsl:template name="varName">
	<xsl:param name="lang"/>ele<xsl:call-template name="idlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>
</xsl:template>

<xsl:template name="idlang">
	<xsl:param name="lang"/><xsl:value-of select="concat(substring-before($lang,'-'),substring-after($lang,'-'))"/>
</xsl:template>

</xsl:stylesheet>
