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
<xsl:output method="xml" indent="no"/>
<xsl:param name="dest_dir">.</xsl:param>
<xsl:param name="display_config_file"/>
<xsl:param name="file_url_prefix"/>
<xsl:param name="application_id"/>

<xsl:variable name="forminfo" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes"/>

<xsl:template match="documenttype">
	<xsl:variable name="currentid" select="@id"/>
	<xsl:variable name="output" select="concat($dest_dir,'/saisie_',$currentid,'.xsp')"/>
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
	<xsl:variable name="docinfo" select="$forminfo/documenttype[@id=$currentid]/edit"/>
	<xsp:page language="java" xmlns:xsp="http://apache.org/xsp" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx">
		<sdx:page langSession="lang" langParam="lang" show="post session user header">
			<title id="title.saisie"/>
			<bar/>
			<xtg:authentication domain="edit">
<xsl:text>

		</xsl:text>
				<xsl:comment> Traitement du formulaire </xsl:comment>

				<xsp:logic>
				// Force to make it work
				request.setCharacterEncoding("UTF8");

				fr.tech.sdx.xtogen.dom.DOMHelper helper
					= new fr.tech.sdx.xtogen.dom.DOMHelper("<xsl:value-of select="$currentid"/>");
				<xsl:if test="$docinfo/on[@mode='upload']">helper.setUploadDir(new File(fr.tech.sdx.xtogen.util.FileHelper.getBaseDir(context, request)
					+ File.separator + "documents" + File.separator + "<xsl:value-of select="$currentid"/>" + File.separator + "attach"));</xsl:if>
				helper.setDefaultField("<xsl:value-of select="fields/descendant-or-self::field[@default='true']/@name"/>");
				<xsl:if test="@versioning='true'">helper.setVersioning();</xsl:if>
				<xsl:apply-templates select="fields/field|fields/fieldgroup" mode="var">
					<xsl:with-param name="docinfo" select="$docinfo"/>
				</xsl:apply-templates>

<xsl:text>

				</xsl:text>
				<xsl:comment> On construit un DOM </xsl:comment>
				org.w3c.dom.Document doc
					= helper.createDom(request);

				<xsl:if test="fields/descendant-or-self::field[@unique='true']">
<xsl:text>
				</xsl:text>
				fr.tech.sdx.xtogen.dom.DOMHelper.Result[] myNotUniques
					= helper.findNotUniques(doc, sdx_frame, "<xsl:value-of select="$application_id"/>");
				<xsl:comment> Test de l'unicité </xsl:comment>
				if (helper.isNewDocument(request) &amp;&amp; myNotUniques.length != 0)
				{
					<uniques>
					<xsp:logic>
					for (int i=0; i&lt;myNotUniques.length; i++)
					{
						fr.tech.sdx.xtogen.dom.DOMHelper.Result res = myNotUniques[i];
						<unique>
							<xsp:attribute name="field"><xsp:expr>res.getFieldName()</xsp:expr></xsp:attribute>
							<xsp:attribute name="occ"><xsp:expr>res.getOccurrence()</xsp:expr></xsp:attribute>
							<xsp:attribute name="value"><xsp:expr>res.getValue()</xsp:expr></xsp:attribute>
						</unique>
					}
					</xsp:logic>
					</uniques>
				}
				else </xsl:if>if (!helper.isMinimumFilled())
				{
					String[] fields = helper.emptyFields();
					for (int i=0; i&lt;fields.length; i++)
					{
						<echec>
							<xsp:attribute name="field"><xsp:expr>fields[i]</xsp:expr></xsp:attribute>
						</echec>
					}
					<echec/>
				}
				else
				{
					<xsl:comment> On sérialise le dom </xsl:comment>
					String baseDir = fr.tech.sdx.xtogen.util.FileHelper.getBaseDir(context,request);
					File dirPath = new File(baseDir+File.separator+"documents"+File.separator+"<xsl:value-of select="$currentid"/>");
					if (!dirPath.exists())
						dirPath.mkdirs();
					File docFile = new File(dirPath, "xtogen_generated_" + helper.getDocumentId(request) + ".xml");
					helper.serializeToFile(doc, docFile);

					// Recreates attached files before indexation
					Collection downloadedFiles
						= helper.downloadAttachedFiles(sdx_application.getId(), baseDir, request);

					// Index the document
					fr.tech.sdx.xtogen.sdx.SDXUtil xtgSdxUtil =
						new fr.tech.sdx.xtogen.sdx.SDXUtil("<xsl:value-of select="$currentid"/>", sdx_application);
					xtgSdxUtil.indexFile(docFile, helper.getDocumentId(request), contentHandler);

					// And deletes them after
					for (java.util.Iterator it=downloadedFiles.iterator();it.hasNext();)
					{
						((File)it.next()).delete();
					}

					<xsp:element name="succes">
						<xsp:attribute name="docId"><xsp:expr>helper.getDocumentId(request)</xsp:expr></xsp:attribute>
					</xsp:element>
				}

				</xsp:logic>

			</xtg:authentication>
		</sdx:page>
	</xsp:page>
	
	</saxon:output>
</xsl:template>

<xsl:template match="field" mode="var">
	<xsl:param name="docinfo"/>
				<xsl:variable name="name" select="@name"/>
				helper.addField("<xsl:value-of select="@name"/>", "<xsl:value-of select="@path"/>", "<xsl:value-of select="@type"/>"<xsl:if test="name(parent::*)='fieldgroup'">, "<xsl:value-of select="../@name"/>"</xsl:if>);<xsl:if test="@lang='multi'">
				helper.setMultilingualField("<xsl:value-of select="@name"/>");</xsl:if><xsl:if test="@mandatory">
				helper.addMandatoryField("<xsl:value-of select="@name"/>");</xsl:if><xsl:if test="@type='attach' and $docinfo/on[@field=$name and @mode='upload']">
				helper.setUploadField("<xsl:value-of select="@name"/>");</xsl:if><xsl:if test="@unique='true'">
				helper.setUniqueField("<xsl:value-of select="@name"/>");</xsl:if></xsl:template>

<xsl:template match="fieldgroup" mode="var">
	<xsl:param name="docinfo"/>
				helper.addField("<xsl:value-of select="@name"/>", "<xsl:value-of select="@path"/>", "group"<xsl:if test="name(parent::*)='fieldgroup'">, "<xsl:value-of select="../@name"/>"</xsl:if>);<xsl:apply-templates select="fieldgroup|field" mode="var"><xsl:with-param name="docinfo" select="$docinfo"/></xsl:apply-templates></xsl:template>

</xsl:stylesheet>
