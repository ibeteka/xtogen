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

<!-- Constants definition -->
<xsl:variable name="xtg_wordprefix">xtgw_</xsl:variable>
<xsl:variable name="xtg_choiceidprefix">xtgid_</xsl:variable>

<!--
	Transforms a "normal" field name into a name that causes no trouble to SDX
	At this time, just transform '-' into '_'
 -->
<xsl:template name="sdxname">
	<xsl:param name="name"/>

	<xsl:value-of select="translate($name,'-','_')"/>
</xsl:template>

<!--
	Computes the path of a field inside the structure.xml file
	(including ancestors fieldgroup path)

	param: field


	example:
		<fields>
			<fieldgroup name="fg1" path="p1/p2">
				<field name="f1" path="p5/p7"/>
			</fieldgroup>
		</fields>

  	computeFullPath(f1) -&gt; p1/p2/p5/p7
  -->
<xsl:template name="computeFullPath">
	<xsl:param name="field"/>

	<xsl:variable name="fp">
		<xsl:choose>
			<xsl:when test="$field/@path"><xsl:value-of select="$field/@path"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$field/@name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:if test="name($field/parent::*) != 'fields'">
		<xsl:call-template name="computeFullPath"><xsl:with-param name="field" select="$field/parent::*"/></xsl:call-template>/</xsl:if>
	<xsl:value-of select="$fp"/>
</xsl:template>

<!--
	Computes the path of the parent fieldgroup of a field
	(including ancestors fieldgroup path)

	param: field


	example:
		<fields>
			<fieldgroup name="fg1" path="p1/p2">
				<field name="f1" path="p5/p7"/>
			</fieldgroup>
		</fields>

  	computeParentFieldGroupFullPath(f1) -&gt; p1/p2
  -->
<xsl:template name="computeParentFullPath">
	<xsl:param name="field"/>

	<xsl:choose>
		<xsl:when test="name($field/parent::*) = 'fieldgroup'">
			<xsl:call-template name="computeFullPath">
				<xsl:with-param name="field" select="$field/parent::*"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise/>
	</xsl:choose>
</xsl:template>

<!--
	Computes the path of a field using [1] to avoid problem with fieldgroup
	(including ancestors fieldgroup path)

	param: field
  -->
<xsl:template name="computeUniqueFullPath">
	<xsl:param name="field"/>

	<xsl:variable name="fp">
		<xsl:choose>
			<xsl:when test="$field/@path"><xsl:value-of select="$field/@path"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$field/@name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:if test="name($field/parent::*) != 'fields'">
		<xsl:call-template name="computeUniqueFullPath"><xsl:with-param name="field" select="$field/parent::*"/></xsl:call-template>/</xsl:if>
	<xsl:value-of select="$fp"/><xsl:if test="name($field)='fieldgroup'">[1]</xsl:if>
</xsl:template>

<xsl:template name="copy-location">
	<xsl:param name="location"/>
	<xsl:param name="sdxlocation">no</xsl:param>

	<xsl:variable name="name">
		<xsl:choose>
			<xsl:when test="$sdxlocation='no'">location</xsl:when>
			<xsl:otherwise>sdx:location</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:for-each select="$location">
		<xsl:element name="{$name}">
			<xsl:if test="not(@base)">
				<xsl:attribute name="base"><xsl:value-of select="../@id"/></xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@*"/>
		</xsl:element>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
