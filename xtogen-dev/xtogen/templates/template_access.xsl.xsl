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
	<xsl:variable name="config_display" select="document(concat($file_url_prefix,$display_config_file))/display"/>
	<xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
		<xsl:attribute name="version">1.0</xsl:attribute>
		<xsl:attribute name="exclude-result-prefixes">xsl</xsl:attribute>


<xsl:text>
</xsl:text>
	<xsl:element name="xsl:template">
		<xsl:attribute name="name">getfieldtype</xsl:attribute>
		<xsl:element name="xsl:param">
			<xsl:attribute name="name">doctype</xsl:attribute>
		</xsl:element>
		<xsl:element name="xsl:param">
			<xsl:attribute name="name">field</xsl:attribute>
		</xsl:element>
		<xsl:element name="xsl:choose">
			<xsl:for-each select="//documenttype">
				<xsl:element name="xsl:when">
					<xsl:attribute name="test">$doctype = '<xsl:value-of select="@id"/>'</xsl:attribute>

					<xsl:element name="xsl:choose">
						<xsl:for-each select="fields/descendant-or-self::field">
							<xsl:element name="xsl:when">
								<xsl:attribute name="test">$field = '<xsl:value-of select="@name"/>'</xsl:attribute>
								<xsl:choose>
									<xsl:when test="@type"><xsl:value-of select="@type"/></xsl:when>
									<xsl:otherwise>string</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:element>

<xsl:text>
</xsl:text>
		<xsl:element name="xsl:template">
			<xsl:attribute name="name">getnamedfield</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">field</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">doctype</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:choose">
				<xsl:for-each select="//documenttype">
					<xsl:element name="xsl:when">
						<xsl:attribute name="test">$doctype = '<xsl:value-of select="@id"/>'</xsl:attribute>

						<xsl:element name="xsl:choose">
							<xsl:for-each select="fields/descendant-or-self::field|fields/descendant-or-self::fieldgroup">
								<xsl:element name="xsl:when">
									<xsl:attribute name="test">$field = '<xsl:value-of select="@name"/>'</xsl:attribute>
									<xsl:choose>
										<xsl:when test="not(@path)"><xsl:value-of select="@name"/></xsl:when>
										<xsl:otherwise><xsl:call-template name="cleanpath"><xsl:with-param name="path" select="@path"/></xsl:call-template></xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>

<xsl:text>
</xsl:text>
		<xsl:element name="xsl:template">
			<xsl:attribute name="name">getparentfield</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">field</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">doctype</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:choose">
				<xsl:for-each select="//documenttype">
					<xsl:element name="xsl:when">
						<xsl:attribute name="test">$doctype = '<xsl:value-of select="@id"/>'</xsl:attribute>

						<xsl:element name="xsl:choose">
							<xsl:for-each select="fields/descendant-or-self::field|fields/descendant-or-self::fieldgroup">
								<xsl:element name="xsl:when">
									<xsl:attribute name="test">$field = '<xsl:value-of select="@name"/>'</xsl:attribute>
									<xsl:choose>
										<xsl:when test="name(parent::*)='fields'"><xsl:value-of select="ancestor::documenttype/@id"/></xsl:when>
										<xsl:when test="parent::*/@path"><xsl:value-of select="parent::*/@path"/></xsl:when>
										<xsl:otherwise><xsl:value-of select="parent::*/@name"/></xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<!--

	roro => roro
	foo/bar/dodo  => dodo
	@popo => @popo
	lolo/@popo => lolo/@popo
	foo/bar/dodo/@kiki => dodo/@kiki
  
  -->
<xsl:template name="cleanpath">
	<xsl:param name="path"/>

	<xsl:choose>
		<xsl:when test="contains($path,'@')">
			<xsl:call-template name="easypath">
				<xsl:with-param name="path" select="$path"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="not(contains($path,'@'))">
			<xsl:call-template name="basepath">
				<xsl:with-param name="path" select="$path"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<!--
	foo/bar/dodo => dodo
  -->
<xsl:template name="basepath">
	<xsl:param name="path"/>

	<xsl:choose>
		<xsl:when test="contains($path,'/')">
			<xsl:call-template name="basepath">
				<xsl:with-param name="path" select="substring-after($path,'/')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$path"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
	lolo/@popo => lolo/@popo
  	foo/bar/fofo/@popo => fofo/@popo
  -->
<xsl:template name="easypath">
	<xsl:param name="path"/>

	<xsl:choose>
		<xsl:when test="contains($path,'/')">
			<xsl:variable name="beg" select="string-length(substring-before($path,'/'))"/>
			<xsl:variable name="end" select="string-length(substring-after($path,'/'))"/>
			<xsl:choose>
				<xsl:when test="string-length($path) = number($beg) + number($end) + 1">
					<xsl:value-of select="$path"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="easypath">
						<xsl:with-param name="path" select="substring-after($path,'/')"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$path"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
