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

	<xsl:template match="error">
		<span class="error"><xsl:value-of select="$messages[@id='page.admin_edit_liste.erreur']"/>:
		<xsl:variable name="keye" select="concat('page.admin_edit_liste.erreur.',@key)"/>
		<xsl:variable name="keyd" select="concat($keye,'.debut')"/>
		<xsl:variable name="keyf" select="concat($keye,'.fin')"/>
		<xsl:choose>
			<xsl:when test="@file">
				<xsl:value-of select="$messages[@id=$keyd]"/><xsl:value-of select="@file"/><xsl:value-of select="$messages[@id=$keyf]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$messages[@id=$keye]"/>
			</xsl:otherwise>
		</xsl:choose>
		</span>
		<br/>
	</xsl:template>

	<xsl:template match="success">
		<xsl:variable name="key" select="@key"/>
		<xsl:if test="count(preceding-sibling::success[@key=$key])=0">
		<xsl:variable name="labelkey" select="concat('page.admin_edit_liste.succes.',$key)"/>
		<span class="success"><xsl:value-of select="$messages[@id=$labelkey]"/>
		</span><br/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
