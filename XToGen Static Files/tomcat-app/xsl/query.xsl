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

    <xsl:template match="sdx:results">
	<h2><xsl:value-of select="$messages[@id='bouton.navigation']"/></h2>
	<div id="exportbar" style="float: {$alignDirection}; text-align: {$alignDirection};">
		<xsl:call-template name="exportbar"/>
	</div>
	<xsl:apply-templates select="." mode="hpp"/>
	<div id="sortbar" style="float: {$alignDirection};">
		<xsl:call-template name="sortbar"/>
	</div>
    <h3><xsl:choose>
		<xsl:when test="$urlparameter[@name='type'] and $urlparameter[@name='type']/@value = 'attach'"><xsl:call-template name="icone"/></xsl:when>
		<xsl:otherwise><xsl:call-template name="title"/></xsl:otherwise>
	</xsl:choose>
	<xsl:if test="$urlparameter[@name='app'] and $urlparameter[@name='app']/@value != /sdx:document/@app">
		&#160;<small>(application <xsl:value-of select="$urlparameter[@name='app']/@value"/>)</small>
	</xsl:if></h3>
        <xsl:choose>
            <xsl:when test="@nb > 0">
				<br/>
				<br/>
				<xsl:call-template name="display-results"/>
				<br/>
				<xsl:if test="@pages != '1'">
					<div class="hr"/>
				</xsl:if>
        		<xsl:apply-templates select="." mode="hpp"/>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <b><xsl:value-of select="$messages[@id='page.query.aucunresultat']"/></b>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="sdx:result">
		<xsl:call-template name="display-result">
			<xsl:with-param name="item" select="."/>
		</xsl:call-template>
    </xsl:template>

    <xsl:template match="sdx:query"/>

	<xsl:template name="title">
		<xsl:variable name="dbId" select="//documentbase/@id"/>
		<xsl:variable name="field" select="$urlparameter[@name='f']/@value"/>
		<xsl:variable name="originalfield">
			<xsl:choose>
				<xsl:when test="contains($field,$choicefieldprefix)"><xsl:value-of select="substring-after($field,$choicefieldprefix)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$field"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="value" select="$urlparameter[@name='v']/@value"/>
		<xsl:variable name="enhancedvalue">
			<xsl:choose>
				<xsl:when test="contains($field,$choicefieldprefix)">
					<xsl:variable name="listname" select="$urlparameter[@name='list']/@value"/>
					<xsl:variable name="fichierliste">
						<xsl:value-of select="concat('lang/liste/',$lang,'/',$lang,'_',$listname,'.xml')"/>
					</xsl:variable>
					<xsl:variable name="liste" select="document($fichierliste)/list"/>
					<xsl:value-of select="$liste/item[@id=$value]"/>
				</xsl:when>
				<xsl:when test="$sfields/document[@id=$currentdoctype]/descendant-or-self::field[@name=$field]/@type='relation'">
					<xsl:variable name="selectedfield" select="$sfields/document[@id=$currentdoctype]/descendant-or-self::field[@name=$field]"/>
					<xsl:variable name="url" select="concat($rootUrl,'query_',$selectedfield/@to,'?f=sdxdocid&amp;v=',$value)"/>
					<xsl:variable name="reldoc" select="document($url)/sdx:document/sdx:results/sdx:result[1]"/>
					<xsl:choose>
						<xsl:when test="$reldoc"><xsl:value-of select="$reldoc/sdx:field[@name='xtgtitle']/@value"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="concat($messages[@id='page.document.documentabsentdebut'],$value,$messages[@id='page.document.documentabsentfin'])"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="subtitle">
			<xsl:choose>
				<xsl:when test="$originalfield='sdxall'">
					<xsl:variable name="defaultfield" select="$titlefields/dbase[@id=$dbId]"/>
					<xsl:value-of select="$labels/doctype[@name=$dbId]/nav[@field=$defaultfield]/title"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$labels/doctype[@name=$dbId]/nav[@field=$originalfield]/subtitle"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<!-- Rien remplacer -->
			<xsl:when test="contains($subtitle,'#') = false">
				<xsl:value-of select="$subtitle"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="debut" select="substring-before($subtitle,'#')"/>
				<xsl:variable name="fin" select="substring-after($subtitle,'#')"/>
				<xsl:value-of select="$debut"/>
				<xsl:value-of select="$enhancedvalue"/>
				<xsl:value-of select="$fin"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="icone">
		<xsl:variable name="app">
			<xsl:choose>
				<xsl:when test="$urlparameter[@name='app']"><xsl:value-of select="$urlparameter[@name='app']/@value"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="/sdx:document/@app"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="dbId" select="/sdx:document/documentbase/@id"/>
		<xsl:variable name="thn" select="substring-before($urlparameter[@name='v']/@value,'||')"/>
		<xsl:variable name="rest" select="substring-after($urlparameter[@name='v']/@value,'||')"/>
		<xsl:variable name="alt" select="substring-before($rest,'||')"/>

		<xsl:element name="img">
			<xsl:attribute name="src"><xsl:value-of select="concat('attached_file?app=',$app,'&amp;base=',$dbId,'&amp;id=',$thn)"/></xsl:attribute>
			<xsl:attribute name="border">0</xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="documentbase"/>

</xsl:stylesheet>
