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

    <xsl:template match="sdx:exception">
<h2><xsl:value-of select="$messages[@id='page.upload.erreur']"/></h2>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="sdx:message">
    <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="sdx:parameters">
        <xsl:apply-templates/>
    </xsl:template>

	<xsl:template match="sdx:uploadDocuments">
        <xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="sdx:summary">
		<br/>
		<xsl:choose>
			<xsl:when test="@additions='0'">
				<span class="error"><xsl:value-of select="$messages[@id='page.upload.ledossierdesdocumentsaindexerestvide']"/></span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$messages[@id='page.upload.statistiquesdindexation']"/>
				<ul>
					<li> <xsl:value-of select="$messages[@id='page.upload.nombrededocumentsajoutes']"/> <b><xsl:value-of select="@additions"/></b></li>
					<li> <xsl:value-of select="$messages[@id='page.upload.nombrededocumentsenerreur']"/> <b><xsl:value-of select="@failures"/></b></li>
					<xsl:if test="count(../sdx:uploadDocument/sdx:exception) &gt; 0">
						<ul>
						<xsl:for-each select="../sdx:uploadDocument">
							<li><span class="error"><xsl:value-of select="$messages[@id='page.upload.erreurlorsdelindexationdudocument']"/><xsl:text> </xsl:text><b><xsl:value-of select="@id"/></b></span></li>
						</xsl:for-each>
						</ul>
					</xsl:if>
					<li> <xsl:value-of select="$messages[@id='page.upload.dureedelindexation']"/> <b><xsl:value-of select="@duration"/></b></li>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <xsl:template match="upload">
    <h2><xsl:value-of select="$messages[@id='page.upload.import']"/></h2>
    <xsl:if test="not(//sdx:exception or //sdx:message) and //sdx:summary[@additions!='0']">
    <xsl:value-of select="$messages[@id='page.upload.importok']"/>
    </xsl:if>
    </xsl:template>
</xsl:stylesheet>
