<?xml version="1.0" encoding="utf-8"?>
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
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	exclude-result-prefixes="xsl fo sdx">

	<!-- formattage du texte libre en mode html -->
	<xsl:template match="gras" mode="html"><b><xsl:apply-templates mode="html"/></b></xsl:template>
	<xsl:template match="italique" mode="html"><i><xsl:apply-templates mode="html"/></i></xsl:template>
	<xsl:template match="sdx:hilite" mode="html"><span class="hilite"><xsl:value-of select="."/></span></xsl:template>
	<!-- formattage du texte libre en mode pdf -->
	<xsl:template match="gras" mode="pdf">
		<fo:inline font-weight="bold" color="red">
			<xsl:apply-templates mode="pdf"/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="italique" mode="pdf">
		<fo:inline font-style="italic">
			<xsl:apply-templates mode="pdf"/>
		</fo:inline>
	</xsl:template>
</xsl:stylesheet>
