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
	xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
	xmlns:saxon="http://icl.com/saxon"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="saxon">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="dest_dir">.</xsl:param>


<!-- Squelette général du fichier -->
<xsl:template match="documenttype">
	<xsl:variable name="output" select="concat($dest_dir,'/zip_export_',@id,'.xsl')"/>
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
	<xsl:variable name="currentid" select="@id"/>
	<xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
		<xsl:copy-of select="document('zip_export_doctype.xsl.xsl')//namespace::*[.='http://www.culture.gouv.fr/ns/sdx/sdx']"/>
		<xsl:copy-of select="document('zip_export_doctype.xsl.xsl')//namespace::*[.='http://apache.org/cocoon/zip-archive/1.0']"/>
		<xsl:attribute name="version">1.0</xsl:attribute>
		<xsl:attribute name="exclude-result-prefixes">xsl</xsl:attribute>

		<xsl:text>

		</xsl:text>
		<xsl:comment> Type de document <xsl:value-of select="@id"/> </xsl:comment>

		<xsl:element name="xsl:template">
			<xsl:attribute name="match">/sdx:document/database[@id='<xsl:value-of select="@id"/>']</xsl:attribute>
			<zip:archive>
				<!-- documents -->
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name">manageDocuments</xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">results</xsl:attribute>
						<xsl:attribute name="select">sdx:results/sdx:result</xsl:attribute>
					</xsl:element>
				</xsl:element>

				<!-- Documents attachés -->
				<xsl:element name="xsl:if">
					<xsl:attribute name="test">$urlparameter[@name='withattach']/@value='yes'</xsl:attribute>
					<xsl:element name="xsl:for-each">
						<xsl:attribute name="select">sdx:results/sdx:result</xsl:attribute>
						<xsl:for-each select="fields/descendant-or-self::field[@type='attach']">
							<xsl:element name="xsl:call-template">
								<xsl:attribute name="name">manageAttach</xsl:attribute>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">attachfieldname</xsl:attribute>
									<xsl:attribute name="select">'<xsl:value-of select="@name"/>'</xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">result</xsl:attribute>
									<xsl:attribute name="select">.</xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</zip:archive>
		</xsl:element>
	</xsl:element>
	</saxon:output>
</xsl:template>

</xsl:stylesheet>

