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
<xsl:param name="display_config_file"/>
<xsl:param name="file_url_prefix"/>

<xsl:include href="xtogen-common-functions.xsl"/>

<xsl:template match="documenttypes/documenttype">
	<xsl:variable name="docid" select="@id"/>
	<xsl:variable name="docsearch" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes/documenttype[@id=$docid]/search"/>
	<xsl:variable name="output" select="concat($dest_dir,'/search_',$docid,'.xsp')"/>
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
	<xsp:page language="java" xmlns:xsp="http://apache.org/xsp" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx">
		<sdx:page langSession="lang" langParam="lang">
			<title id="title.linearsearch"/>
			<bar/>
		
			<xtg:authentication domain="search">
			<xsl:variable name="mlfs" select="fields/descendant-or-self::field[@lang='multi']"/>
			<xsl:if test="count($mlfs)!=0">
				<xsp:logic>
					<xsl:for-each select="$mlfs">
						String xtg_<xsl:value-of select="@name"/> = "<xsl:value-of select="$xtg_wordprefix"/><xsl:value-of select="@name"/>_"
							+ request.getParameter("<xsl:value-of select="$xtg_wordprefix"/><xsl:value-of select="@name"/>.lang").replace('-','_');
					</xsl:for-each>
				</xsp:logic>
			</xsl:if>
			<resultats>
				<sdx:executeComplexQuery>
					<!-- Tri -->
					<sdx:sort fieldParam="sortfield" orderParam="order"/>

					<!-- Champs -->
					<xsl:apply-templates select="$docsearch/on">
						<xsl:with-param name="docstructure" select="."/>
					</xsl:apply-templates>

					<!-- Base -->
					<xsl:choose>
						<xsl:when test="location">
							<xsl:call-template name="copy-location">
								<xsl:with-param name="location" select="location"/>
								<xsl:with-param name="sdxlocation">yes</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<sdx:location base="{$docid}"/>
						</xsl:otherwise>
					</xsl:choose>
				</sdx:executeComplexQuery>
			</resultats>
			</xtg:authentication>
		</sdx:page>
	</xsp:page>
	</saxon:output>
</xsl:template>

<xsl:template match="on">
	<xsl:param name="docstructure"/>
	<xsl:variable name="fieldname" select="@field"/>
	<xsl:variable name="field" select="$docstructure/fields/descendant-or-self::field[@name=$fieldname]"/>
	<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="$field/@type"><xsl:value-of select="$field/@type"/></xsl:when>
			<xsl:otherwise>string</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:choose>
		<xsl:when test="$type='string' or $type='text' or $type='email'">
			<sdx:simpleQuery queryParam="{$xtg_wordprefix}{@field}">
			<xsl:choose>
				<xsl:when test="$field/@lang='multi'">
					<xsl:attribute name="fieldString">xtg_<xsl:value-of select="@field"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="field"><xsl:value-of select="$xtg_wordprefix"/><xsl:value-of select="@field"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="position()!=1">
				<xsl:attribute name="complexopParam">complex.query.op</xsl:attribute>
			</xsl:if>
			</sdx:simpleQuery>
		</xsl:when>
		<!-- Listes -->
		<xsl:when test="$type='choice'">
			<xsl:variable name="f">
				<xsl:if test="$field/@list"><xsl:value-of select="$xtg_choiceidprefix"/></xsl:if><xsl:value-of select="@field"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="not($field/@mode) or $field/@mode='Mcombo' or $field/@mode='check'">
					<sdx:linearQuery field="{$f}" valueParam="{$f}" opParam="{@field}.op">
						<xsl:if test="position()!=1">
							<xsl:attribute name="complexopParam">complex.query.op</xsl:attribute>
						</xsl:if>
					</sdx:linearQuery>
				</xsl:when>
				<xsl:otherwise>
					<sdx:fieldQuery field="{$f}" valueParam="{$f}" op="and">
						<xsl:if test="position()!=1">
							<xsl:attribute name="complexopParam">complex.query.op</xsl:attribute>
						</xsl:if>
					</sdx:fieldQuery>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<sdx:simpleQuery field="{@field}" queryParam="{$xtg_wordprefix}{@field}" complexopParam="complex.query.op">
			<xsl:if test="position()!=1">
				<xsl:attribute name="complexopParam">complex.query.op</xsl:attribute>
			</xsl:if>
			</sdx:simpleQuery>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
