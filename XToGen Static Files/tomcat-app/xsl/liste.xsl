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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	xmlns:urle="java.net.URLEncoder"
	exclude-result-prefixes="sdx">
    <xsl:import href="common.xsl"/>

	<xsl:variable name="listname" select="$urlparameter[@name='list']/@value"/>
	<xsl:variable name="appli" select="$urlparameter[@name='app']"/>
	<xsl:variable name="db" select="//documentbase/@id"/>
	<xsl:variable name="field" select="$urlparameter[@name='field']/@value"/>
	<xsl:variable name="fichierliste" select="concat('lang/liste/',$lang,'/',$lang,'_',$listname,'.xml')"/>
	<xsl:variable name="liste" select="document($fichierliste)/list"/>

	<xsl:variable name="optionalappinfo">
		<xsl:choose>
			<xsl:when test="$appli"><xsl:value-of select="concat('&amp;app=',$appli/@value)"/></xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="optionalchoiceinfo">
		<xsl:if test="contains(@field,$choicefieldprefix)"><xsl:value-of select="concat('&amp;list=',$listname)"/></xsl:if>
	</xsl:variable>

	<!-- Tous les termes -->
    <xsl:template match="sdx:terms">
	<xsl:variable name="originalfield">
		<xsl:choose>
			<xsl:when test="contains($field,$choicefieldprefix)"><xsl:value-of select="substring-after($field,$choicefieldprefix)"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$field"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<h2><xsl:value-of select="$messages[@id='bouton.navigation']"/></h2>
	<xsl:choose>
		<xsl:when test="/sdx:document/sdx:parameters/sdx:parameter[@name='mode']/@value='alpha'">
			<xsl:call-template name="alphabet"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="." mode="hpp"/>
		</xsl:otherwise>
	</xsl:choose>
    <h3><xsl:value-of select="$labels/doctype[@name=$db]/nav[@field=$originalfield]/title"/>
	<xsl:if test="$appli">
		&#160;<small>(application <xsl:value-of select="$appli/@value"/>)</small>
	</xsl:if></h3>
        <xsl:choose>
            <xsl:when test="@nb > 0">
				<table border="0">
               		<xsl:apply-templates/>
				</table>
				<br/>
				<xsl:if test="@pages != '1'">
					<hr noshade="noshade" size="1"/>
				</xsl:if>
        		<xsl:apply-templates select="." mode="hpp"/>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <b><xsl:value-of select="$messages[@id='page.results.aucunresultat']"/></b>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<!-- Pour chaque resultat -->
    <xsl:template match="sdx:term">

		<xsl:variable name="value" select="@value"/>
        <tr><td align="right"><b><xsl:value-of select="@no"/></b>&#160;</td>
			<td>
			<xsl:variable name="label">
				<xsl:choose>
					<xsl:when test="$listname!=''">
						<xsl:variable name="choiceid" select="$value"/>
						<xsl:value-of select="$liste/item[@id=$choiceid]"/>
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
					<xsl:otherwise>
						<xsl:value-of select="$value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="@docId">
					<a class="nav" href="document.xsp?id={@docId}&amp;db={@base}&amp;app={@app}&amp;qid={../@id}&amp;p={../@currentPage}">
						<xsl:value-of select="$label"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="optionalchoiceinfo">
						<xsl:choose>
							<xsl:when test="contains(@field,$choicefieldprefix)"><xsl:value-of select="concat('&amp;list=',$listname)"/></xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</xsl:variable>
					<a class="nav" href="query_{//documentbase/@id}.xsp?f={@field}&amp;v={urle:encode(string(string($value)),'UTF-8')}{$optionalchoiceinfo}&amp;sortfield={$currentdoctypedefaultsortfield}&amp;order=ascendant">
						<xsl:value-of select="$label"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
			&#160;<span dir="ltr">(<xsl:value-of select="@docFreq"/>)</span>
			</td></tr>
    </xsl:template>
    <xsl:template match="sdx:query"/>

	<xsl:template name="alphabet">
		<xsl:variable name="alphafile" select="concat('lang/interface/',$lang,'/',$lang,'_alphabet.xml')"/>
		<xsl:variable name="alpha" select="document($alphafile)/alphabet"/>
		<!--
		<xsl:variable name="target" select="concat($rootUrl,'linear_',$db,'.xsp?field=',$field,$optionalappinfo)"/>
		-->
		<xsl:variable name="target" select="concat(/sdx:document/@uri,'?field=',$field,$optionalappinfo)"/>
		<small>
		<xsl:for-each select="$alpha/letter">
			<xsl:variable name="values">
				<xsl:call-template name="buildUrlParamList">
					<xsl:with-param name="valueString" select="@search"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="url" select="concat($rootUrl,'linear_',$db,'?field=',$field,$values,'&amp;hpp=0')"/>
			<!--
			<b><xsl:value-of select="$url"/></b><br/>
			-->
			<xsl:variable name="result" select="document($url)/sdx:document/sdx:results"/>
			<xsl:choose>
				<xsl:when test="$result/@nb &gt; 0">
					<!--
					<b><a href="{concat($target,$values)}" title="{concat($result/@nb,' ',$messages[@id='common.document_s'])}"><xsl:value-of select="@display"/></a></b>
					-->
					<b><a href="{concat($target,'&amp;value=',@display,'*&amp;mode=alpha')}" title="{concat($result/@nb,' ',$messages[@id='common.document_s'])}"><xsl:value-of select="@display"/></a></b>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@display"/>
				</xsl:otherwise>
			</xsl:choose>
			&#160;
		</xsl:for-each>
		</small>
	</xsl:template>

	<xsl:template name="buildUrlParamList">
		<xsl:param name="valueString"/>

		<xsl:choose>
			<xsl:when test="contains($valueString,',')">
				<xsl:text/>&amp;value=<xsl:value-of select="urle:encode(string(string(substring-before($valueString,','))),'UTF-8')"/>*<xsl:text/>
				<xsl:text/>&amp;op=or<xsl:text/>
				<xsl:call-template name="buildUrlParamList">
					<xsl:with-param name="valueString" select="substring-after($valueString,',')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>&amp;value=<xsl:value-of select="urle:encode(string(string($valueString)),'UTF-8')"/>*</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
