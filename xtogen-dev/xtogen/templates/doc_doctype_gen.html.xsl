<?xml version="1.0"?>
<!--
	XtoGen - GÃ©nÃ©rateur d'applications SDX2 - http://xtogen.tech.fr
    Copyright (C) 2003 MinistÃ¨re de la culture et de la communication, PASS Technologie

    MinistÃ¨re de la culture et de la communication,
    Mission de la recherche et de la technologie
    3 rue de Valois, 75042 Paris Cedex 01 (France)
    mrt@culture.fr, michel.bottin@culture.fr

    PASS Technologie, 23, rue Pierre et Marie Curie, 94200 Ivry Sur Seine
	Nader Boutros, nader.boutros@pass-tech.fr
    Pierre Dittgen, pierre.dittgen@pass-tech.fr

    Ce programme est un logiciel libre: vous pouvez le redistribuer
    et/ou le modifier selon les termes de la "GNU General Public
    License", tels que publiÃ©s par la "Free Software Foundation"; soit
    la version 2 de cette licence ou (Ã  votre choix) toute version
    ultÃ©rieure.

    Ce programme est distribuÃ© dans l'espoir qu'il sera utile, mais
    SANS AUCUNE GARANTIE, ni explicite ni implicite; sans mÃªme les
    garanties de commercialisation ou d'adaptation dans un but spÃ©cifique.

    Se rÃ©fÃ©rer Ã  la "GNU General Public License" pour plus de dÃ©tails.

    Vous devriez avoir reÃ§u une copie de la "GNU General Public License"
    en mÃªme temps que ce programme; sinon, Ã©crivez Ã  la "Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA".
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://icl.com/saxon"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="saxon">
	<xsl:output method="xml" indent="yes"/>
	
	<xsl:param name="dest_dir">.</xsl:param>
	<xsl:param name="display_config_file"/>
	<xsl:param name="file_url_prefix"/>
	
	<xsl:variable name="forminfo" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes"/>
	
	<xsl:template match="documenttype">
		<xsl:variable name="currentid" select="@id"/>
		<xsl:variable name="output" select="concat($dest_dir,'/doc_',$currentid,'_gen.html')"/>
		<saxon:output href="{$output}">
			<html>
				<head>
					<title>Document <xsl:value-of select="@id"/></title>
					<link rel="stylesheet" type="text/css" href="css/html.css"/>
				</head>
				<body>
					<table cellpadding="10" cellspacing="0" width="100%" class="paddings">
						<tr>
							<td class="highlight">
								<table cellpadding="0" cellspacing="3" width="100%" class="highlight">
									<tr>
										<td>
											<img src="icones/cols.gif" width="100" height="1" alt="pour la mise en page seulement"/>
										</td>
										<td>
											<img src="icones/cols.gif" width="458" height="1" alt="pour la mise en page seulement"/>
										</td>
									</tr>
									<tr>
										<td id="xtg-document-nav" colspan="2" align="right"><b>&lt; &gt;</b></td>
									</tr>
									<!-- Champ par défaut -->
									<xsl:apply-templates select="fields/descendant-or-self::field[@default]"/>

									<!-- Champs autres -->
									<xsl:apply-templates select="fields/field[not(@default)]|fields/fieldgroup"/>

									<!-- Reverse -->
									<xsl:for-each select="../documenttype[@id!=$currentid]/fields/descendant-or-self::field[@type='relation' and @to=$currentid]">
										<xsl:call-template name="manage-reverse">
											<xsl:with-param name="doc" select="ancestor::*[name()='documenttype']/@id"/>
											<xsl:with-param name="field" select="@name"/>
										</xsl:call-template>
									</xsl:for-each>
								</table>
							</td>
						</tr>
					</table>
				</body>
			</html>
		</saxon:output>
	</xsl:template>

	<!-- Manage reverse -->
	<xsl:template name="manage-reverse">
		<xsl:param name="doc"/>
		<xsl:param name="field"/>
		
		<tr id="xtg-reversefield-{$doc}/{$field}">
			<td id="xtg-field-name" class="attribut" valign="top">#reverse#<xsl:value-of select="$doc"/>#<xsl:value-of select="$field"/>#</td>
			<td id="xtg-field-value" width="100%" class="valeur">#value#</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="field">
		<!-- Normal field -->
		<tr id="xtg-field-id-{@name}">
			<td id="xtg-field-name" class="attribut" valign="top">#<xsl:value-of select="@name"/>#</td>
			<td id="xtg-field-value" width="100%">
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="@default">titre</xsl:when>
						<xsl:otherwise>valeur</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				#value#
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="fieldgroup">
		<!-- Fieldgroup -->
		<tr id="xtg-fieldgroup-id-{@name}">
			<td colspan="2">
				<fieldset>
					<legend id="xtg-fieldgroup-name" class="attribut">#<xsl:value-of select="@name"/>#</legend>
					<table id="xtg-fieldgroup-value" border="0" width="100%">
						<xsl:apply-templates select="field[not(@default)]|fieldgroup"/>
					</table>
				</fieldset>
			</td>
		</tr>
	</xsl:template>
				
</xsl:stylesheet>
