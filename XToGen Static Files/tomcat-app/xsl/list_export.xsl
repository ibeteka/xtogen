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

    <xsl:include href="common.xsl"/>

	<xsl:variable name="list" select="$urlparameter[@name='list']/@value"/>

	<xsl:template match="csvexport">
		<h2><xsl:value-of select="$messages[@id='page.admin.export']"/></h2>
		<h3><xsl:value-of select="$messages[@id='page.admin.listeexterne']"/>&#160;<xsl:value-of select="$list"/></h3>

		<fieldset>
			<legend><xsl:value-of select="$messages[@id='common.exportauformatcsv']"/></legend>
			<form action="list_export.csv">
				<input type="hidden" name="list" value="{$list}"/>
				<xsl:value-of select="$messages[@id='page.csv.formatcsv']"/><br/>
				<input type="radio" name="csv.format" value="excel" checked="checked"/> <xsl:value-of select="$messages[@id='page.csv.donneescsvmsexcel']"/><br/>
				<input type="radio" name="csv.format" value="standard"/> <xsl:value-of select="$messages[@id='page.csv.donneescsv']"/>
				<table border="0">
					<tr>
						<td width="20">&#160;</td>
						<td>
							<xsl:value-of select="$messages[@id='page.csv.champsseparespar']"/>
							<select name="csv.sep">
								<option value="virgule" selected="selected">,</option>
								<option value="pointvirgule">;</option>
								<option value="tabulation">TAB</option>
							</select>
							<br/>
							<xsl:value-of select="$messages[@id='page.csv.champsentourespar']"/>
							<select name="csv.quote">
								<option value="guillemet" selected="selected">"</option>
								<option value="apostrophe">'</option>
							</select>
						</td>
					</tr>
				</table>
				<input type="submit" value="{$messages[@id='page.csv.exporter...']}"/>
			</form>
		</fieldset>
		<br/>
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='page.saisie.retouralapagedadministration']"/></a>
	</xsl:template>
</xsl:stylesheet>
