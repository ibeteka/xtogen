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

    <xsl:template match="resultats">
    <h2><xsl:value-of select="$messages[@id='page.linearsearch.resultats']"/></h2>
	<xsl:apply-templates select="sdx:results"/>
	<xsl:if test="count(sdx:results)=0 or sdx:results/@nb=0">
		<p>
			<b><xsl:value-of select="$messages[@id='page.results.aucunresultat']"/></b>
		</p>
	</xsl:if>
	</xsl:template>

	<xsl:template match="sdx:results">
		<div align="left">
			<xsl:call-template name="exportbar"/>
		</div>
        <xsl:if test="@nb &gt; 0">
			<xsl:if test="@currentPage='1' and @pages='1'">
			<p>
				<b><xsl:value-of select="@nb"/>&#160;<xsl:value-of select="$messages[@id='page.results.resultatscorrespondentavotrerecherche']"/></b>
			</p>
			</xsl:if>
			<div align="right"><xsl:call-template name="sortbar"/></div>	
        	<xsl:apply-templates select="." mode="hpp"/>
			<xsl:call-template name="display-results"/>
			<br/>
			<xsl:if test="@pages != '1'">
				<hr noshade="noshade" size="1"/>
        		<xsl:apply-templates select="." mode="hpp"/>
			</xsl:if>
         </xsl:if>
    </xsl:template>

    <xsl:template match="sdx:result">
		<xsl:variable name="no" select="@no"/>
		<xsl:variable name="dbid" select="sdx:field[@name='sdxdbid']"/>
		<xsl:if test="../sdx:result[1]/@no=$no">
		<tr><td colspan="2"><h3><xsl:value-of select="$labels/doctype[@name=$dbid]/label"/></h3></td></tr>
		</xsl:if>
		<xsl:call-template name="display-result">
			<xsl:with-param name="item" select="."/>
		</xsl:call-template>
    </xsl:template>

    <xsl:template match="sdx:query"/>

</xsl:stylesheet>
