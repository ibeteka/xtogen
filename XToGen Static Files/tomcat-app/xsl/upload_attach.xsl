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


<xsl:template match="upload">
	<h3><xsl:value-of select="$messages[@id='page.admin.uploaddefichier']"/></h3>
	<br/>
	<xsl:apply-templates/>

	<br/>
	<br/>
	<a class="nav" href="admin_attach.xsp?db={base}&amp;type={type}"><xsl:value-of select="$messages[@id='page.admin.retouralalistedesfichiers']"/></a>
</xsl:template>

<xsl:template match="base"/>
<xsl:template match="type"/>

<xsl:template match="bad">
	<xsl:choose>
		<xsl:when test="@reason='badfileextension'">
			<span class="erreur"><xsl:value-of select="$messages[@id='page.admin.extensiondefichierincorrecte.debut']"/>&#160;<b><xsl:value-of select="file"/></b>&#160;<xsl:value-of select="$messages[@id='page.admin.extensiondefichierincorrecte.fin']"/></span>
		</xsl:when>
		<xsl:when test="@reason='nofilenamegiven'">
			<span class="erreur"><xsl:value-of select="$messages[@id='page.admin.vousnavezpasprecisedefichieraenvoyer']"/></span>
		</xsl:when>
		<xsl:otherwise>
			ERREUR INCONNUE !!!
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="good">
	<xsl:value-of select="$messages[@id='page.admin.lefichieraetecorrectementenvoye.debut']"/>&#160;<b><xsl:value-of select="file"/></b>&#160;<xsl:value-of select="$messages[@id='page.admin.lefichieraetecorrectementenvoye.fin']"/><br/>
</xsl:template>

</xsl:stylesheet>
