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

	<xsl:template match="admin">
		<xsl:variable name="base" select="$urlparameter[@name='db']/@value"/>
		<h2><xsl:value-of select="$messages[@id='page.admin.import']"/></h2>
		<h3><xsl:value-of select="$messages[@id='page.admin.basededocument']"/>&#160;<xsl:value-of select="$base"/></h3>
        <br/>
		<xsl:value-of select="$messages[@id='page.admin.indexerlesdocuments']"/>
        <form name="dir" action="upload.xsp" method="GET">
			<input type="text" name="dir" size="70" value="{normalize-space(uploaddir)}{$base}"/>
                &#160;
			<input type="hidden" name="db" value="{$base}"/>
			<input type="submit" value="{$messages[@id='page.admin.indexer']}"/>
        </form>
		<xsl:value-of select="$messages[@id='page.admin.importerlesdocuments']"/>
		<form name="zip" action="upload.xsp" method="POST" enctype="multipart/form-data">
			<input type="file" name="zip" size="50"/>
        	<input type="hidden" name="db" value="{$base}"/>
            &#160;<input type="submit" value="{$messages[@id='page.admin.importer']}"/>
		</form>
		<xsl:value-of select="$messages[@id='page.admin.importerunseuldocument']"/>
		<form name="file" action="upload.xsp" method="POST" enctype="multipart/form-data">
			<input type="file" name="file" size="50"/>
        	<input type="hidden" name="db" value="{$base}"/>
            &#160;<input type="submit" value="{$messages[@id='page.admin.importer']}"/>
		</form>

		<form name="csv" action="csv_base_pre_import.xsp" method="POST" enctype="multipart/form-data">
			<fieldset>
				<legend><xsl:value-of select="$messages[@id='page.csv.importerunfichiercsv']"/></legend>
				<input type="hidden" name="db" value="{$base}"/>
				<input type="file" name="csv.file" size="30"/><br/>
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
				<input type="submit" value="{$messages[@id='page.csv.suite']}"/>
			</fieldset>
		</form>
		<br/>
		<br/>
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='page.admin.retour']"/></a>
    </xsl:template>

    <!-- rights -->
    <xsl:template match="noteditor">
        <p><xsl:copy-of select="$messages[@id='page.admin.noteditor']"/></p>
    </xsl:template>
    <xsl:template match="sdx:query"/>
</xsl:stylesheet>
