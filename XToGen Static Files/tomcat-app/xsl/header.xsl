<?xml version="1.0"?>
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
	<xsl:include href="vars.xsl"/>

	<xsl:template match="back">
		<html dir="{$langDirection}">
			<head>
				<link rel="stylesheet" type="text/css" href="css/html.css"/>
			</head>
			<body style="background-color: #d8d8d8;">
				<table>
				<tr><td>
				<a class="nav" href="index.xsp" target="_top"><xsl:value-of select="$messages[@id='bouton.accueil']"/></a>
				<xsl:text> - </xsl:text>
				<xsl:variable name="params" select="$urlparameter"/>
				<xsl:variable name="backurl" select="concat('document.xsp?app=',$params[@name='app']/@value,'&amp;db=',$params[@name='db']/@value,'&amp;id=',$params[@name='doc']/@value,'&amp;q=',$params[@name='q']/@value,'&amp;qid=',$params[@name='qid']/@value,'&amp;n=',$params[@name='n']/@value)"/>
				<a class="nav" href="{$backurl}" target="_top"><xsl:value-of select="$messages[@id='page.document.retouraudocument']"/></a>
				</td></tr>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
