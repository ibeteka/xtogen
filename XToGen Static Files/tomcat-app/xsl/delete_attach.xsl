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
    <xsl:include href="common.xsl"/>

    <xsl:template match="admin">
		<h2><xsl:value-of select="$messages[@id='page.delete_attach.suppressiondunattachement']"/></h2>
		<div align="center">
		<span class="titre"><xsl:value-of select="$urlparameter[@name='file']/@value"/></span>
		<br/>
		<br/>

		<xsl:apply-templates/>
		</div>
		<br/>
		<br/>
		<a class="nav" href="admin_attach.xsp?db={$urlparameter[@name='db']/@value}"><xsl:value-of select="$messages[@id='page.admin.retour']"/></a>
    </xsl:template>

	<xsl:template match="good">
		<xsl:value-of select="$messages[@id='page.delete_attach.suppressioneffectuee']"/>
	</xsl:template>

	<xsl:template match="bad">
		<span class="erreur">
		<xsl:choose>
			<xsl:when test="@reason='filenotfound'"><xsl:value-of select="$messages[@id='page.delete_attach.fichiernontrouve']"/></xsl:when>
			<xsl:when test="@reason='cantdeletefile'"><xsl:value-of select="$messages[@id='page.delete_attach.impossibledesupprimerlefichier']"/></xsl:when>
			<xsl:otherwise>Uhh ???</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>
	
	
    <xsl:template match="sdx:parameter[@name='id']">
<xsl:value-of select="$messages[@id='page.delete.ledocument']"/><b>
            <xsl:value-of select="@value"/>
        </b><xsl:value-of select="$messages[@id='page.delete.aetesupprimedelabase']"/>
		
</xsl:template>
</xsl:stylesheet>
