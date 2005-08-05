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

	<xsl:variable name="base" select="$urlparameter[@name='db']/@value"/>

	<xsl:template match="export">
		<h2><xsl:value-of select="$messages[@id='page.admin.export']"/></h2>
		<h3><xsl:value-of select="$messages[@id='page.admin.basededocument']"/>&#160;<xsl:value-of select="$base"/></h3>
        <br/>

		<fieldset>
			<legend><xsl:value-of select="$messages[@id='common.exportauformatcsv']"/></legend>
			<form action="base_{$base}_export.csv">
				<input type="hidden" name="db" value="{$base}"/>
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
				<input type="text" size="1" name="csv.mvsep" value="$"/><br/>
				<xsl:choose>
					<xsl:when test="$currentdoctypesort">
						<xsl:value-of select="$messages[@id='common.trierpar']"/>
						<select name="sortfield">
							<xsl:for-each select="$currentdoctypesort/on">
								<xsl:variable name="field" select="@field"/>
								<option value="{$field}">
									<xsl:value-of select="$labels/doctype[@name=$currentdoctype]/sort[@field=$field]"/>
									<xsl:if test="@default">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
								</option>
							</xsl:for-each>
						</select>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<input type="hidden" name="sortfield" value="{$titlefields/dbase[@id=$currentdoctype]}"/>
					</xsl:otherwise>
				</xsl:choose>
				<input type="submit" value="{$messages[@id='page.csv.exporter...']}"/>
			</form>
		</fieldset>
		<br/>
		<fieldset>
			<legend><xsl:value-of select="$messages[@id='page.admin.exportdunebrochurepdf']"/></legend>
			<form action="base_{$base}_export.pdf">
				<input type="hidden" name="db" value="{$base}"/>
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
				<xsl:choose>
					<xsl:when test="$currentdoctypesort">
						<tr>
							<td><xsl:value-of select="$messages[@id='common.trierpar']"/></td>
							<td>
								<select name="sortfield">
									<xsl:for-each select="$currentdoctypesort/on">
										<xsl:variable name="field" select="@field"/>
										<option value="{$field}">
											<xsl:value-of select="$labels/doctype[@name=$currentdoctype]/sort[@field=$field]"/>
											<xsl:if test="@default">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>
										</option>
									</xsl:for-each>
								</select>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<input type="hidden" name="sortfield" value="{$titlefields/dbase[@id=$currentdoctype]}"/>
					</xsl:otherwise>
				</xsl:choose>
				</table>
				<br/>
				<input type="submit" value="{$messages[@id='page.csv.exporter...']}"/>
			</form>
		</fieldset>
		<br/>
		<fieldset>
			<legend><xsl:value-of select="$messages[@id='page.admin.exportzip']"/></legend>
			<form action="base_{$base}_export.zip">
				<input type="hidden" name="db" value="{$base}"/>
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
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='page.saisie.retouralapagedadministration']"/></a>
	</xsl:template>
</xsl:stylesheet>
