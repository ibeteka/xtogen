<?xml version="1.0" encoding="UTF-8"?>
<!--
SDX: Documentary System in XML.
Copyright (C) 2000, 2001, 2002  Ministere de la culture et de la communication (France), AJLSM

Ministere de la culture et de la communication,
Mission de la recherche et de la technologie
3 rue de Valois, 75042 Paris Cedex 01 (France)
mrt@culture.fr, michel.bottin@culture.fr

AJLSM, 17, rue Vital Carles, 33000 Bordeaux (France)
sevigny@ajlsm.com

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the
Free Software Foundation, Inc.
59 Temple Place - Suite 330, Boston, MA  02111-1307, USA
or connect to:
http://www.fsf.org/copyleft/gpl.html
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx" exclude-result-prefixes="sdx">
    <xsl:import href="common.xsl"/>
    <xsl:import href="result_display.xsl"/>

	<xsl:template match="admin">
		<xsl:variable name="base" select="$urlparameter[@name='db']/@value"/>
		<h3><xsl:value-of select="$messages[@id='page.admin.basededocument']"/>&#160;<xsl:value-of select="$base"/></h3>

		<div align="right">
			<xsl:call-template name="sortbar"/>
		</div>

		<xsl:choose>
			<xsl:when test="count(sdx:results/sdx:result) = 0">
				<xsl:value-of select="$messages[@id='page.admin.basevide']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="sdx:results" mode="hpp"/><br/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
		<br/>
		<xsl:apply-templates select="sdx:results" mode="hpp"/><br/>
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='page.admin.retour']"/></a>
	</xsl:template>

	<xsl:template match="sdx:results">
		<xsl:if test="@nb != 0">
		<table class="admintable">
			<tr><td>&#160;</td>
			<td><xsl:value-of select="$messages[@id='page.admin.editer']"/></td>

			<td><xsl:value-of select="$messages[@id='page.admin.exporter']"/></td>
			<td><xsl:value-of select="$messages[@id='page.admin.copier']"/></td>
			<xsl:if test="$admin">
			<td><xsl:value-of select="$messages[@id='page.admin.supprimer']"/></td>
			</xsl:if>
			</tr>
			<xsl:apply-templates/>
		</table>
		</xsl:if>
	</xsl:template>

	<xsl:template match="sdx:result">
		<xsl:variable name="base" select="$urlparameter[@name='db']/@value"/>
		<xsl:variable name="app" select="sdx:field[@name='sdxappid']"/>
		<xsl:variable name="docId" select="sdx:field[@name='sdxdocid']"/>
		<xsl:variable name="titleField" select="$titlefields/dbase[@id = $base]"/>
			<tr>
			<td class="label">
				<xsl:call-template name="display-result-doc">
					<xsl:with-param name="item" select="."/>
					<xsl:with-param name="admin">yes</xsl:with-param>
				</xsl:call-template>
			</td>
			<td><a class="nav" href="admin_saisie.xsp?id={$docId}&amp;db={$base}&amp;app={$app}" title="{$messages[@id='page.admin.editerledocument']}"><img src="icones/edit.png" alt="{$messages[@id='page.admin.editer']}"/></a></td>
			<td><a class="nav" href="export.xsp?id={$docId}&amp;db={$base}&amp;app={$app}" title="{$messages[@id='page.admin.exporterledocument']}"><img src="icones/export.png"  alt="{$messages[@id='page.admin.exporter']}"/></a></td>
			<td><a class="nav" href="admin_saisie.xsp?mode=copy&amp;id={$docId}&amp;db={$base}&amp;app={$app}" title="{$messages[@id='page.admin.copierledocument']}"><img src="icones/copy.png" alt="{$messages[@id='page.admin.copier']}"/></a></td>
			<xsl:if test="$admin">
			<td>
			<xsl:variable name="deleteurl" select="concat('pre_delete.xsp?id=',$docId,'&amp;db=',$base,'&amp;title=',sdx:field[@name=$titleField]/@escapedValue)"/>
			<a class="nav" href="{$deleteurl}" title="{$messages[@id='page.admin.supprimerledocument']}"><img src="icones/delete.png" alt="{$messages[@id='page.admin.supprimer']}"/></a>
			</td>
			</xsl:if>
			</tr>
	</xsl:template>

    <!-- rights -->
    <xsl:template match="noteditor">
        <p><xsl:copy-of select="$messages[@id='page.admin.noteditor']"/></p>
    </xsl:template>
    <xsl:template match="sdx:query"/>
</xsl:stylesheet>
