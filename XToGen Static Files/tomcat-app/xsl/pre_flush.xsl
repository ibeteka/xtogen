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

	<xsl:template match="question">
		<xsl:variable name="base" select="$urlparameter[@name='db']/@value"/>
		<div align="center">
		<xsl:value-of select="$messages[@id='page.pre_flush.voulezvousvraimentviderlabase']"/>&#160;<xsl:value-of select="$base"/> ?<br/>
		<xsl:value-of select="sdx:results/@nb"/><xsl:text> </xsl:text><xsl:value-of select="$messages[@id='common.document_s']"/><br/>
		<a class="nav" href="flush.xsp?qid={sdx:results/@qid}"><xsl:value-of select="$messages[@id='common.oui']"/></a>&#160;
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='common.non']"/></a>
		</div>
		<xsl:if test="count($relations/relation[text()=$base])">
			<br/>
			<br/>
			<div bgcolor="#edc0a1">
			<xsl:for-each select="$relations/relation[text()=$base]">
				<xsl:variable name="url" select="concat($rootUrl,'terms_',@doc,'?field=',@field)"/>
				<xsl:variable name="docs" select="document($url)/sdx:document/sdx:terms"/>
				<xsl:if test="$docs/@nb != 0">
					<b><xsl:value-of select="$messages[@id='page.pre_flush.attention']"/></b><br/>
					<xsl:value-of select="$docs/@nb"/><xsl:value-of select="$messages[@id='page.pre_flush.documentsdelabase']"/><xsl:value-of select="@doc"/><xsl:value-of select="$messages[@id='page.pre_flush.referencentdesdocumentsdecettebase']"/><br/>
					<span dir="ltr">(<xsl:value-of select="$messages[@id='page.pre_flush.champ']"/><xsl:value-of select="@field"/>)</span><br/>
				</xsl:if>
			</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
