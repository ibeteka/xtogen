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

	<xsl:template match="export">
		<xsl:variable name="base" select="base"/>
		<h2><xsl:value-of select="$messages[@id='page.admin.exportderesultats']"/></h2>
        <br/>

		<xsl:choose>
			<xsl:when test="type='csv'">
				<fieldset>
					<legend><xsl:value-of select="$messages[@id='common.exportauformatcsv']"/></legend>
					<form action="base_{$base}_export.csv">
						<input type="hidden" name="db" value="{$base}"/>
						<input type="hidden" name="qid" value="{qid}"/>
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
						<xsl:value-of select="$messages[@id='page.csv.separateurdechampsmultivalues']"/>
						<input type="text" size="1" length="1" name="csv.mvsep" value="$"/><br/>
						<input type="submit" value="{$messages[@id='page.csv.exporter...']}"/>
					</form>
				</fieldset>
			</xsl:when>
			<xsl:when test="type='pdf'">
				<!-- PHAMODIS -->
				<xsl:if test="not(starts-with($lang,'ar-'))">
				<!-- PHAMODIS -->
				<fieldset>
					<legend><xsl:value-of select="$messages[@id='page.admin.exportdunebrochurepdf']"/></legend>
					<form action="base_{$base}_export.pdf">
						<input type="hidden" name="db" value="{$base}"/>
						<input type="hidden" name="qid" value="{qid}"/>
						<table border="0">
						<tr>
							<td><xsl:value-of select="$messages[@id='common.titre']"/>:</td>
							<xsl:variable name="titlefield" select="$titlefields/dbase[@id=$base]"/>
							<td><input type="text" name="title" value="{$labels/doctype[@name=$base]/nav[@field=$titlefield]/link}"/></td>
						</tr>
						<tr>
							<td><xsl:value-of select="$messages[@id='common.soustitre']"/>:</td>
							<td><input type="text" name="subtitle"/></td>
						</tr>
						<tr>
							<td><xsl:value-of select="$messages[@id='common.date']"/>:</td>
							<td><input type="text" name="date" value="{today}"/></td>
						</tr>
						</table>
						<br/>
						<input type="submit" value="{$messages[@id='page.csv.exporter...']}"/>
					</form>
				</fieldset>
				</xsl:if>
			</xsl:when>
			<xsl:when test="type='zip'">
				<fieldset>
					<legend><xsl:value-of select="$messages[@id='page.admin.exportzip']"/></legend>
					<form action="base_{$base}_export.zip">
						<input type="hidden" name="db" value="{$base}"/>
						<input type="hidden" name="qid" value="{qid}"/>
						<table border="0">
							<tr>
								<td><xsl:value-of select="$messages[@id='page.admin.aveclespiecesattachees']"/></td>
								<td>
									<input type="radio" name="withattach" value="yes" checked="checked"/> <xsl:value-of select="$messages[@id='common.oui']"/>
									<br/>
									<input type="radio" name="withattach" value="no"/> <xsl:value-of select="$messages[@id='common.non']"/>
								</td>
							</tr>
						</table>
						<input type="submit" value="{$messages[@id='page.csv.exporter...']}"/>
					</form>
				</fieldset>
			</xsl:when>
			<xsl:otherwise>
				<span class="error">Unknown export type: [<xsl:value-of select="type"/>]</span>
			</xsl:otherwise>
		</xsl:choose>
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='page.saisie.retouralapagedadministration']"/></a>
	</xsl:template>
</xsl:stylesheet>
