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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://icl.com/saxon"
 	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="saxon">
	<xsl:output method="xml" indent="yes"/>
	
	<xsl:param name="dest_dir">.</xsl:param>
	<xsl:param name="display_config_file"/>
	<xsl:param name="file_url_prefix"/>
	
	<xsl:variable name="forminfo" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes"/>
	
	<xsl:template match="documenttype">
		<xsl:variable name="currentid" select="@id"/>
		<xsl:variable name="output" select="concat($dest_dir,'/pdf_',$currentid,'_gen.fo')"/>
		<saxon:output href="{$output}">
		<fo:root>
			<fo:layout-master-set>
				<fo:simple-page-master id="xtg-fop-booklet-multiple" master-name="first" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="1cm" margin-left="0.3cm" margin-right="1cm">
					<fo:region-body margin="5cm" padding="6pt"/>
					<fo:region-before extent="2cm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="simple" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="0cm" margin-left="1cm" margin-right="1cm">
					<fo:region-body margin-top="2cm" margin-bottom="1cm"/>
					<fo:region-before extent="1.5cm"/>
					<fo:region-after extent="1cm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="sequence">
					<fo:single-page-master-reference id="xtg-fop-booklet-multiple" master-reference="first"/>
					<fo:repeatable-page-master-reference master-reference="simple"/>
				</fo:page-sequence-master>
			</fo:layout-master-set>
			<fo:page-sequence master-reference="sequence">
				<fo:static-content flow-name="xsl-region-after">
					<fo:block text-align="end" font-size="10pt">
						<fo:page-number/> / <fo:page-number-citation ref-id="terminator"/>
					</fo:block>
				</fo:static-content>
				<fo:flow flow-name="xsl-region-body">
					<!-- 1ere page -->
					<fo:block id="xtg-fop-booklet-multiple" font-size="18pt" font-family="Times, sans-serif" color="white" background-color="gray">
						<fo:block id="xtg-fop-booklet-title" space-before="1.5cm" space-after="0cm" text-align="center">#Title#</fo:block>
						<fo:block id="xtg-fop-booklet-subtitle" font-size="16pt" space-before="0cm" space-after="0cm" text-align="center">#Subtitle#</fo:block>
						<fo:block id="xtg-fop-booklet-nbdocuments" font-size="12pt" space-before="1.5cm" space-after="0cm" text-align="center">#n documents#</fo:block>
						<fo:block id="xtg-fop-booklet-date" break-after="page" font-size="12pt" font-style="italic" space-before="0cm" space-after="2cm" text-align="center">#date#</fo:block>
					</fo:block>
					<fo:block id="xtg-fop-booklet-toc" background-color="gray" space-after.optimum="10pt" space-before.optimum="15pt" color="white">#Sommaire#</fo:block>

					<fo:block id="xtg-fop-booklet-page">
						<xsl:variable name="df" select="fields/descendant-or-self::field[@default]/@name"/>
						<fo:block id="xtg-field-id-{$df}" font-size="18pt" font-family="Times, sans-serif" line-height="30pt" space-after.optimum="15pt" border="0.1pt solid #ddd" background-color="#eee" text-align="center"><fo:block id="xtg-field-value">#<xsl:value-of select="$df"/>#</fo:block></fo:block>
						<fo:table font-family="Times, sans-serif">
							<fo:table-column column-width="5cm"/>
							<fo:table-column column-width="14cm"/>
							<fo:table-body>
								<!-- Normal fields -->
								<xsl:apply-templates select="fields/field[not(@default)]|fields/fieldgroup"/>

								<!-- Reverse fields -->
								<xsl:for-each select="../documenttype[@id!=$currentid]/fields/descendant-or-self::field[@type='relation' and @to=$currentid]">
									<xsl:call-template name="manage-reverse">
										<xsl:with-param name="doc" select="ancestor::*[name()='documenttype']/@id"/>
										<xsl:with-param name="field" select="@name"/>
									</xsl:call-template>
								</xsl:for-each>
							</fo:table-body>
						</fo:table>
					</fo:block>
					<fo:block>
						<fo:leader leader-length="19cm" leader-pattern="rule" rule-thickness="0.5pt" color="black"/>
					</fo:block>
					<fo:block id="xtg-fop-generated-by" font-size="8pt" font-style="italic">#document generated by XToGen#</fo:block>
					<fo:block id="terminator"/>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
		</saxon:output>
	</xsl:template>

	<xsl:template name="manage-reverse">
		<xsl:param name="doc"/>
		<xsl:param name="field"/>

		<fo:table-row id="xtg-reversefield-{$doc}/{$field}">
			<fo:table-cell padding="4pt">
				<fo:block id="xtg-field-name-{@name}">#reverse#<xsl:value-of select="$doc"/>#<xsl:value-of select="$field"/>#</fo:block>
			</fo:table-cell>
			<fo:table-cell padding="4pt">
				<fo:block id="xtg-field-value-{@name}">#value#</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="field">
		<fo:table-row id="xtg-field-id-{@name}">
			<fo:table-cell padding="4pt">
				<fo:block id="xtg-field-name-{@name}">#<xsl:value-of select="@name"/>#</fo:block>
			</fo:table-cell>
			<fo:table-cell padding="4pt">
				<fo:block id="xtg-field-value-{@name}">#value#</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="fieldgroup">
		<fo:table-row id="xtg-fieldgroup-id-{@name}">
			<fo:table-cell padding="4pt" number-columns-spanned="2">
				<fo:block id="xtg-fieldgroup-name-{@name}" color="white">#<xsl:value-of select="@name"/>#</fo:block>
			</fo:table-cell>
		</fo:table-row>
		<fo:table-row id="xtg-fieldgroup-id-{@name}">
			<fo:table-cell number-columns-spanned="2">
				<fo:table id="xtg-fieldgroup-value-{@name}">
					<fo:table-column column-width="5cm"/>
					<fo:table-column column-width="14cm"/>
					<fo:table-body>
						<xsl:apply-templates select="field[not(@default)]|fieldgroup"/>
					</fo:table-body>
				</fo:table>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
				
</xsl:stylesheet>
