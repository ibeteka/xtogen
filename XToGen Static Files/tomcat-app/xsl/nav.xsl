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

	<xsl:template match="documentbase">
		<xsl:variable name="dbId" select="@id"/>
		<xsl:choose>
			<xsl:when test="$urlparameter[@name='db']/@value = $dbId">
				<h2><xsl:value-of select="$messages[@id='bouton.navigation']"/></h2>

				<h3><xsl:value-of select="$labels/doctype[@name=$dbId]/label"/>
				<xsl:if test="location">
					&#160;<small>
					(<xsl:for-each select="location">
						<xsl:if test="position() != 1">, </xsl:if>
						<xsl:value-of select="@app"/>
					</xsl:for-each>)</small></xsl:if></h3>
				<ul>
					<xsl:apply-templates select="field"/>
				</ul>
			</xsl:when>
			<!-- Pas de paramètre db -->
			<xsl:when test="count($urlparameter[@name='db']) = 0">
				<xsl:if test="../documentbase[1]/@id = $dbId">
					<h2><xsl:value-of select="$messages[@id='bouton.navigation']"/></h2>
				</xsl:if>
				<a class="nav" href="nav.xsp?db={$dbId}"><xsl:value-of select="$messages[@id='page.nav.navigationdanslesdocumentsdelabase']"/>&#160;<xsl:value-of select="@id"/></a>&#160;
				<xsl:if test="@app"><small>(application <xsl:value-of select="@app"/>)</small></xsl:if><br/>

			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="field">
		<xsl:variable name="dbId" select="../@id"/>
		<xsl:variable name="field" select="@name"/>

		<xsl:variable name="sf">
			<xsl:choose>
				<xsl:when test="$currentdoctypesort"><xsl:value-of select="$currentdoctypedefaultsortfield"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$titlefields/dbase[@id=$dbId]"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="xspname">
			<xsl:choose>
				<xsl:when test="$field=$titlefields/dbase[@id=$dbId]">query_<xsl:value-of select="$dbId"/>.xsp?f=sdxall&amp;v=1&amp;sortfield=<xsl:value-of select="$sf"/>&amp;order=ascendant</xsl:when>
				<xsl:when test="@type='image' or @type='attach'">gallery_<xsl:value-of select="$dbId"/>.xsp?hpp=21&amp;</xsl:when>
				<xsl:otherwise>list_<xsl:value-of select="$dbId"/>.xsp?</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fieldinfo">
			<xsl:choose>
				<xsl:when test="$field=$titlefields/dbase[@id=$dbId]"/>
				<xsl:when test="@type='choice' and @list">field=<xsl:value-of select="concat($choicefieldprefix,@name,'&amp;list=',@list)"/></xsl:when>
				<xsl:otherwise>field=<xsl:value-of select="@name"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="displaymode">
			<xsl:if test="@mode">&amp;mode=<xsl:value-of select="@mode"/></xsl:if>
		</xsl:variable>

		<li><a class="nav" href="{$xspname}{$fieldinfo}{$displaymode}">
			<xsl:value-of select="$labels/doctype[@name=$dbId]/nav[@field=$field]/link"/>
		</a></li>
	</xsl:template>

</xsl:stylesheet>
