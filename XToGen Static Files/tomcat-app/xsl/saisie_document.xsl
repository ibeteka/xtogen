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

	<xsl:template match="uniques">
		<span class="erreur">
			<xsl:for-each select="unique">
				<xsl:value-of select="$messages[@id='page.saisie.lechampnestpasunique.debut']"/><xsl:text> </xsl:text>
				<b><xsl:value-of select="@field"/></b>
				<xsl:text> </xsl:text><xsl:value-of select="$messages[@id='page.saisie.lechampnestpasunique.fin']"/><br/>

				<xsl:value-of select="$messages[@id='page.saisie.lavaleurestdejautilisee.debut']"/><xsl:text> </xsl:text>
				<b><xsl:value-of select="@value"/></b>
				<xsl:text> </xsl:text><xsl:value-of select="$messages[@id='page.saisie.lavaleurestdejautilisee.fin']"/><br/>
				<ul>
					<xsl:variable name="url" select="concat($rootUrl,'query_',$currentdoctype,'?f=',@field,'&amp;v=',@value,'&amp;=-1')"/>
					<xsl:variable name="idems" select="document($url)/sdx:document/sdx:results/sdx:result"/>
					<xsl:for-each select="$idems">
						<li> <a href="document.xsp?db={sdx:field[@name='sdxdbid']/@value}&amp;id={sdx:field[@name='sdxdocid']/@value}"><xsl:value-of select="sdx:field[@name='xtgtitle']/@value"/></a></li>
					</xsl:for-each>
				</ul>
			</xsl:for-each>
		</span>
		<br/>
		<i>
			<xsl:value-of select="$messages[@id='common.utilisezleboutonbackdevotrenavigateurpourreveniralapagedesaisie']"/>
		</i>
	</xsl:template>

	<xsl:template match="succes">
		<xsl:variable name="docId" select="normalize-space(@docId)"/>
		<xsl:variable name="app" select="/sdx:document/@app"/>
		<xsl:variable name="base" select="$urlparameter[@name='document.base']/@value"/>
		<xsl:value-of select="$messages[@id='page.saisie.documentindexeavecsucces']"/><br/>
		<xsl:value-of select="$messages[@id='page.saisie.dureedindexation']"/>: <xsl:value-of select="../sdx:uploadDocuments/sdx:summary/@duration"/>s.<br/>
		<br/>
		<a class="nav" href="admin_saisie.xsp?app={$app}&amp;db={$base}&amp;id={$docId}"><xsl:value-of select="$messages[@id='page.saisie.retouralasaisiedudocument']"/></a>
		<br/>
		<xsl:variable name="url1" select="concat('admin_saisie.xsp?app=',$app,'&amp;db=',$base,'&amp;id=',$docId)"/>
		<a class="nav" href="admin_saisie.xsp?db={$base}"><xsl:value-of select="$messages[@id='page.saisie.saisirunnouveaudocument']"/></a>
		<br/>
		<xsl:variable name="url2" select="concat('document.xsp?app=',$app,'&amp;db=',$base,'&amp;id=',$docId)"/>
		<a class="nav" href="{$url2}"><xsl:value-of select="$messages[@id='page.saisie.visualiserledocument']"/></a>
		<br/>
		<a class="nav" href="admin_liste.xsp?db={$base}&amp;sortfield={$currentdoctypedefaultsortfield}&amp;order=ascendant"><xsl:value-of select="$messages[@id='page.saisie.retouralalistedesdocuments']"/></a>
		<br/>
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='page.saisie.retouralapagedadministration']"/></a>
	</xsl:template>

	<xsl:template match="echec">
		<xsl:choose>
			<xsl:when test="@field">
				<xsl:value-of select="$messages[@id='page.saisie.lechamp']"/>&#160;<b><xsl:value-of select="@field"/></b>&#160;<xsl:value-of select="$messages[@id='page.saisie.nestpasrenseigne']"/>.<br/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$messages[@id='page.saisie.lindexationnapaspuetreeffectuee']"/>.
				<br/>
				<br/>
				<i>
				<xsl:value-of select="$messages[@id='common.utilisezleboutonbackdevotrenavigateurpourreveniralapagedesaisie']"/>
				</i>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
