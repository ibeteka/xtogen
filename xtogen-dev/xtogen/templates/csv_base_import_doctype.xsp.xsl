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
	exclude-result-prefixes="sdx saxon">
<xsl:output method="xml"/>
<xsl:param name="dest_dir">.</xsl:param>

<xsl:include href="xtogen-common-functions.xsl"/>

<xsl:template match="/">
	<xsl:apply-templates select="//documenttype"/>
</xsl:template>

<xsl:template match="documenttype">
	<xsl:variable name="output" select="concat($dest_dir,'/csv_base_import_',@id,'.xsp')"/>
	<saxon:output href="{$output}">
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
			<xtg:authentication domain="base">
				<xsp:logic>
					request.setCharacterEncoding("UTF8");
					fr.tech.sdx.xtogen.util.TimeTracker tt
						= new fr.tech.sdx.xtogen.util.TimeTracker();
					tt.start("init");
					// Base directory
					String baseDir
						= fr.tech.sdx.xtogen.util.FileHelper.getBaseDir(context,request);

					File csvFile = new File(request.getParameter("csv.file"));
					String csvFormat = request.getParameter("csv.format");
					String csvSeparator = request.getParameter("csv.sep");
					String csvQuote = request.getParameter("csv.quote");
					fr.tech.sdx.xtogen.list.CSVListParser clp
						= new fr.tech.sdx.xtogen.list.CSVListParser(csvFile, csvFormat, csvSeparator, csvQuote);
					
					clp.reset();
					clp.getHeaders();
					
					Properties	values				= null;
					String 		id					= null;
					String		idColumn			= request.getParameter("identcol");
					boolean		idHasToBeGenerated	= "generated".equals(request.getParameter("ident"));
					<xsl:for-each select="fields/descendant-or-self::field[not(@type) or @type!='attach']">
					String param<xsl:value-of select="generate-id(.)"/> = request.getParameter("field.<xsl:value-of select="@name"/>");</xsl:for-each>
					String paramLang = request.getParameter("csv.lang");

					<xsl:variable name="base" select="@id"/>
					fr.tech.sdx.xtogen.sdx.SDXUtil xtgSDXUtil
						= new fr.tech.sdx.xtogen.sdx.SDXUtil("<xsl:value-of select="$base"/>", sdx_application);
					tt.stop("init");
					int			rowCount			= 0;
					int			indexedDoc			= 0;
					while (clp.hasRow())
					{
						values = clp.getRow();
						if (clp.isEmpty(values))
							continue;

						rowCount++;

						tt.start("docb");
						if (idHasToBeGenerated)
								id = "xtg" + new java.util.Date().getTime();
						else	id = values.getProperty(idColumn);

						fr.tech.sdx.xtogen.dom.DOMBuilder builder
							= new fr.tech.sdx.xtogen.dom.DOMBuilder("<xsl:value-of select="@id"/>", id, paramLang);
						
					<xsl:for-each select="fields/descendant-or-self::field[not(@type) or @type!='attach']">
						<xsl:variable name="fp">
							<xsl:call-template name="computeFullPath">
								<xsl:with-param name="field" select="."/>
							</xsl:call-template>
						</xsl:variable>
						if (param<xsl:value-of select="generate-id(.)"/> != null &amp;&amp; !"---".equals(param<xsl:value-of select="generate-id(.)"/>))
							builder.populateField("<xsl:value-of select="@name"/>","<xsl:value-of select="$fp"/>",values.getProperty(param<xsl:value-of select="generate-id(.)"/>));</xsl:for-each>
						tt.stop("docb");
						tt.start("seri");
						File tempFile = File.createTempFile("xtg","tmp");
						builder.saveDom(tempFile);
						tt.stop("seri");
						tt.start("inde");
						try
						{
							xtgSDXUtil.indexFile(tempFile, id, contentHandler);
							indexedDoc++;
						}
						catch (Exception ex)
						{
							ex.printStackTrace();
						}
						tt.stop("inde");
						tempFile.delete();
					}
					tt.print();
					
					csvFile.delete();
					
					<xsp:element name="success">
						<xsp:logic><base><xsp:expr>request.getParameter("db")</xsp:expr></base></xsp:logic>
						<xsp:logic><rownumber><xsp:expr>rowCount</xsp:expr></rownumber></xsp:logic>
						<xsp:logic><docnumber><xsp:expr>indexedDoc</xsp:expr></docnumber></xsp:logic>
					</xsp:element>
				</xsp:logic>
			</xtg:authentication>
		</sdx:page>
	</xsp:page>
	</saxon:output>
</xsl:template>

<xsl:template name="varName">
	<xsl:param name="lang"/>ele<xsl:call-template name="idlang"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>
</xsl:template>

<xsl:template name="idlang">
	<xsl:param name="lang"/><xsl:value-of select="concat(substring-before($lang,'-'),substring-after($lang,'-'))"/>
</xsl:template>

</xsl:stylesheet>
