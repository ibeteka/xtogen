<?xml version="1.0" encoding="utf-8"?>
<!--
	XtoGen - Générateur d'applications SDX2 - http://xtogen.tech.fr
    Copyright (C) 2003 Ministère de la culture et de la communication, PASS Technologie

    Ministère de la culture et de la communication,
    Mission de la recherche et de la technologie
    3 rue de Valois, 75042 Paris Cedex 01 (France)
    mrt@culture.fr, michel.bottin@culture.fr

    PASS Technologie, 23, rue Pierre et Marie Curie, 94200 Ivry Sur Seine
	Nader Boutros, nader.boutros@pass-tech.fr
    Pierre Dittgen, pierre.dittgen@pass-tech.fr

    Ce programme est un logiciel libre: vous pouvez le redistribuer
    et/ou le modifier selon les termes de la "GNU General Public
    License", tels que publiés par la "Free Software Foundation"; soit
    la version 2 de cette licence ou (à votre choix) toute version
    ultérieure.

    Ce programme est distribué dans l'espoir qu'il sera utile, mais
    SANS AUCUNE GARANTIE, ni explicite ni implicite; sans même les
    garanties de commercialisation ou d'adaptation dans un but spécifique.

    Se référer à la "GNU General Public License" pour plus de détails.

    Vous devriez avoir reçu une copie de la "GNU General Public License"
    en même temps que ce programme; sinon, écrivez à la "Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA".
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx" xsl:exclude-result-prefixes="sdx">
	<xsl:include href="common.xsl"/>

	<xsl:template match="begin">
		<h2><xsl:value-of select="$messages[@id='page.csv.importcsvdelabase']"/>&#160;<xsl:value-of select="@base"/></h2>
	</xsl:template>

	<xsl:template match="headers">

		<xsl:variable name="colnb" select="count(header[text()='id'])"/>
		<xsl:variable name="cols" select="header"/>

		<form action="csv_base_import_{base}.xsp" method="POST">
			<input type="hidden" name="csv.file" value="{file}"/>
			<input type="hidden" name="csv.format" value="{csvformat}"/>
			<input type="hidden" name="csv.sep" value="{csvsep}"/>
			<input type="hidden" name="csv.quote" value="{csvquote}"/>
			<input type="hidden" name="db" value="{base}"/>
		<table>
			<tr>
				<td><xsl:value-of select="$messages[@id='page.csv.languedesdocuments']"/></td>
				<td>
					<xsl:call-template name="langCombo">
						<xsl:with-param name="name">csv.lang</xsl:with-param>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td><xsl:value-of select="$messages[@id='page.csv.lesidentifiantssont']"/></td>
				<td><input type="radio" name="ident" value="generated">
						<xsl:if test="$colnb=0">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
						<xsl:value-of select="$messages[@id='page.csv.generesautomatiquement']"/>
						<br/>
					<input type="radio" name="ident" value="col"> 
						<xsl:if test="$colnb!=0">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
						<xsl:value-of select="$messages[@id='page.csv.contenusdanslacolonne']"/>
						<select name="identcol">
							<xsl:for-each select="$cols">
							<xsl:variable name="myCol" select="."/>
							<option value="{$myCol}">
								<xsl:if test="$myCol='id'">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="$myCol"/>
							</option>
							</xsl:for-each>
						</select>
				</td>
			</tr>
			<tr>
				<table bgcolor="black" width="60%" cellspacing="1">
					<tr>
						<td colspan="2" bgcolor="#e0e0e0" align="middle"><xsl:value-of select="$messages[@id='page.csv.correspondances']"/></td>
					</tr>
					<tr>
						<td colspan="2" bgcolor="#e0e0e0" align="middle">
							<xsl:value-of select="$messages[@id='page.csv.champsdudocument']"/>
							&lt;--&gt;
							<xsl:value-of select="$messages[@id='page.csv.colonnecsv']"/>
						</td>
					</tr>
					<tr><td bgcolor="white" colspan="2">
					<table bgcolor="white" width="100%">
					<xsl:variable name="base" select="base"/>
					<xsl:variable name="doc" select="$allfields/document[@id=$base]"/>
					<xsl:apply-templates select="$doc/field|$doc/fieldgroup">
						<xsl:with-param name="cols" select="$cols"/>
						<xsl:with-param name="spacer">&#160;</xsl:with-param>
					</xsl:apply-templates>
					</table>
					</td></tr>
				</table>
			</tr>
			<tr><td colspan="2"><input type="submit" value="Importer"/></td></tr>
		</table>
		</form>
		
	</xsl:template>

	<xsl:template match="field">
		<xsl:param name="cols"/>
		<xsl:param name="spacer"/>

		<xsl:variable name="rowField" select="@name"/>
		<tr>
			<td bgcolor="white" align="left"><xsl:value-of select="$spacer"/><xsl:value-of select="$rowField"/></td>
			<td bgcolor="white" align="middle"> 
				<select name="field.{$rowField}">
					<option value="---">---</option>
					<xsl:for-each select="$cols">
						<xsl:variable name="myCol" select="."/>
						<option value="{$myCol}">
							<xsl:if test="$rowField=$myCol">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="$myCol"/>
						</option>
					</xsl:for-each>
				</select>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="fieldgroup">
		<xsl:param name="cols"/>
		<xsl:param name="spacer"/>

		<tr>
			<td bgcolor="white" colspan="2" align="left">
				<fieldset>
					<legend><xsl:value-of select="@name"/></legend>
					<table>
						<xsl:apply-templates select="field|fieldgroup">
							<xsl:with-param name="cols" select="$cols"/>
							<xsl:with-param name="spacer" select="concat('&#160;&#160;&#160;',$spacer)"/>
						</xsl:apply-templates>
					</table>
				</fieldset>
			</td>
		</tr>
	</xsl:template>

	<!-- Produire un nom de variable ok
		 à partir du code de la langue -->
	<xsl:template name="varName">
		<xsl:param name="lang"/>lang.<xsl:value-of select="concat(substring-before($lang,'-'),substring-after($lang,'-'))"/>
	</xsl:template>

	<!-- Erreur -->
	<xsl:template match="echec">
		<br/>
		<span class="error"><xsl:value-of select="$messages[@id='page.csv.fichieraimportermanquant']"/></span>
		<br/>
		<br/>
		<br/>
		<a class="nav" href="csv_import.xsp?list={../begin/@list}"><xsl:value-of select="$messages[@id='page.csv.retouralapagedimport']"/></a>
		<br/>
	</xsl:template>

	<xsl:template match="end">
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='page.saisie.retouralapagedadministration']"/></a>
	</xsl:template>
</xsl:stylesheet>
