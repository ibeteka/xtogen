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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx">
	<xsl:output method="xml" indent="yes"/>
	
	<!-- Recopie l'element racine -->
	<xsl:template match="/sdx:document">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Recopie l'element sdx:field -->
	<xsl:template match="sdx:field">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- Recopie l'element sdx:attachedDocument seulement s'il n'apparait
		 pas déjà avant dans le document -->
	<xsl:template match="sdx:attachedDocument">
		<xsl:variable name="id" select="@id"/>
		<xsl:if test="count(preceding-sibling::sdx:attachedDocument[@id=$id]) = 0">
			<xsl:copy-of select="."/>
		</xsl:if>
	</xsl:template>

	<!-- Recopie des attributs -->
	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
</xsl:stylesheet>
