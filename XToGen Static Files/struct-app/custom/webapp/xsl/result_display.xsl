<?xml version="1.0" encoding="UTF-8"?>
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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx" exclude-result-prefixes="sdx">

	<xsl:template name="display-results">
		<table border="0" width="100%">
			<xsl:apply-templates select="sdx:result"/>
		</table>
	</xsl:template>

	<!-- Pour afficher les résultats de recherche -->
	<xsl:template name="display-result">
		<xsl:param name="item"/>

		<tr>
		<td align="right"><b><xsl:value-of select="$item/@no"/></b>&#160;</td>
			<td>
				<xsl:call-template name="display-result-doc">
					<xsl:with-param name="item" select="$item"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

	<!-- Pour afficher juste le lien -->
	<xsl:template name="display-result-doc">
		<xsl:param name="item"/>
		<xsl:param name="admin">no</xsl:param>

		<xsl:variable name="docid" select="$item/sdx:field[@name='sdxdocid']"/>
		<xsl:variable name="dbid" select="$item/sdx:field[@name='sdxdbid']"/>
		<xsl:variable name="title" select="$titlefields/dbase[@id=$dbid]"/>
		<xsl:variable name="docurl" select="concat('document.xsp?app=',$item/sdx:field[@name='sdxappid'],'&amp;db=',$dbid,'&amp;id=',$docid,'&amp;qid=',$item/../@id,'&amp;n=',$item/@no,'&amp;q=',$urlparameter[@name='q']/@value)"/>
		<xsl:variable name="pdfurl" select="concat('pdf_export.xsp?app=',$item/sdx:field[@name='sdxappid'],'&amp;db=',$dbid,'&amp;id=',$docid)"/>
		<xsl:variable name="value" select="$item/sdx:field[@name=$title]"/>

		<a class="nav" href="{$docurl}">
			<xsl:choose>
				<xsl:when test="$value!=''"><xsl:value-of select="$value"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$docid"/></xsl:otherwise>
			</xsl:choose>
		</a>
<xsl:text> </xsl:text><a class="nav" href="{$pdfurl}" title="{$messages[@id='page.admin.exportpdf']}"><img src="icones/pdf.png" alt="{$messages[@id='page.admin.exportpdf']}"/></a>
<xsl:if test="$value!=''">
<xsl:text> </xsl:text><span dir="ltr">(<xsl:value-of select="$docid"/>)</span>
</xsl:if>
	</xsl:template>

</xsl:stylesheet>
