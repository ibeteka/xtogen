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
	<xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
		<xsl:attribute name="version">1.0</xsl:attribute>
		<xsl:attribute name="exclude-result-prefixes">xsl</xsl:attribute>

		<xsl:apply-templates select="//documenttype" mode="import"/>

<xsl:text>
</xsl:text>
		<xsl:element name="xsl:template">
			<xsl:attribute name="name">getdefaultfield</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">doc</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">doctype</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:choose">
				<xsl:for-each select="//documenttype">
					<xsl:element name="xsl:when">
						<xsl:attribute name="test">$doctype = '<xsl:value-of select="@id"/>'</xsl:attribute>

						<xsl:element name="xsl:value-of">
							<xsl:attribute name="select">$doc/<xsl:call-template name="computeFullPath">
									<xsl:with-param name="field" select="fields/descendant-or-self::field[@default]"/>
								</xsl:call-template></xsl:attribute>
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
				<xsl:attribute name="name">doc</xsl:attribute>
			</xsl:element>
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
							<xsl:for-each select="fields/descendant-or-self::field">
								<xsl:element name="xsl:when">
									<xsl:attribute name="test">$field = '<xsl:value-of select="@name"/>'</xsl:attribute>
									<xsl:element name="xsl:value-of">
										<xsl:attribute name="select">$doc/<xsl:call-template name="computeFullPath">
												<xsl:with-param name="field" select="."/>
											</xsl:call-template></xsl:attribute>
									</xsl:element>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="documenttype" mode="import">
	<xsl:element name="xsl:import">
		<xsl:attribute name="href">
			<xsl:value-of select="concat('pdf_export_',@id,'.xsl')"/>
		</xsl:attribute>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>
