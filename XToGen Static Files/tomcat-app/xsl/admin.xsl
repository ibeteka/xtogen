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
		<h2><xsl:value-of select="$messages[@id='bouton.administration']"/></h2>
		<br/>
		<table class="admintable" width="100%">
		<tr>
				<td class="label"><xsl:value-of select="$messages[@id='page.admin.basededocument']"/></td>
				<xsl:if test="$admin">
					<td><xsl:value-of select="$messages[@id='page.admin.import']"/></td>
					<td><xsl:value-of select="$messages[@id='page.admin.export']"/></td>
				</xsl:if>
				<td><xsl:value-of select="$messages[@id='page.admin.saisie']"/></td>
				<xsl:if test="$admin">
					<td><xsl:value-of select="$messages[@id='page.admin.vider']"/></td>
				</xsl:if>
		</tr>
			<xsl:apply-templates/>
		</table>
	</xsl:template>

	<xsl:template match="document">
		<tr>
			<xsl:choose>
				<!-- Base externe -->
				<xsl:when test="@external">
					<td class="title"><xsl:value-of select="@base"/></td>
					<td colspan="5"><i><xsl:value-of select="$messages[@id='page.admin.baseexterne']"/></i></td>
				</xsl:when>
				<!-- Base interne -->
				<xsl:otherwise>
					<xsl:variable name="db" select="@base"/>
					<xsl:variable name="url" select="concat($rootUrl,'base_content?db=',@base)"/>
					<xsl:variable name="nbDoc" select="document($url)/sdx:document/sdx:results/@nb"/>

					<xsl:variable name="sf">
						<xsl:choose>
							<xsl:when test="$conf_disp/documenttypes/documenttype[@id=$db]/sort"><xsl:value-of select="$conf_disp/documenttypes/documenttype[@id=$db]/sort/on[@default]/@field"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$titlefields/dbase[@id=$db]"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<td class="label">
					<xsl:choose>
						<xsl:when test="$nbDoc &gt; 0">
							<a class="nav" href="admin_liste.xsp?db={$db}&amp;sortfield={$sf}&amp;order=ascendant" title="{$messages[@id='page.admin.listedesdocuments']}"><xsl:value-of select="@base"/></a>
							<xsl:text> </xsl:text>
							<span dir="ltr">(<span dir="{$langDirection}"><xsl:value-of select="$nbDoc"/>&#160;<xsl:value-of select="$messages[@id='common.document_s']"/></span>)</span>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@base"/>
							<xsl:text> </xsl:text>
							<span dir="ltr">(<xsl:value-of select="$messages[@id='page.admin.basevide']"/>)</span>
						</xsl:otherwise>
					</xsl:choose>
					</td>
					<xsl:if test="$admin">
						<td><a class="nav" href="admin_import.xsp?db={$db}" title="{$messages[@id='page.admin.importdedocuments']}"><img src="icones/import_base.png" alt="{$messages[@id='page.admin.importdedocuments']}"/></a></td>
						<td>
							<xsl:choose>
								<xsl:when test="$nbDoc &gt; 0">
									<a class="nav" href="admin_export.xsp?db={$db}&amp;sortfield={$sf}" title="{$messages[@id='page.admin.exportdedocuments']}"><img src="icones/export_base.png" alt="{$messages[@id='page.admin.exportdedocuments']}"/></a>
								</xsl:when>
								<xsl:otherwise>&#160;</xsl:otherwise>
							</xsl:choose>
						</td>
					</xsl:if>
					<xsl:variable name="saisie_link">
						<xsl:choose>
							<xsl:when test="@with-attach">pre_saisie.xsp</xsl:when>
							<xsl:otherwise>admin_saisie.xsp</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<td><a class="nav" href="{$saisie_link}?db={$db}" title="{$messages[@id='page.admin.saisiedunnouveaudocument']}"><img src="icones/new_document.png" alt="{$messages[@id='page.admin.saisiedunnouveaudocument']}"/></a></td>
					<xsl:if test="$admin">
						<xsl:choose>
							<xsl:when test="$nbDoc &gt; 0">
								<td>
								<a class="nav" href="pre_flush.xsp?db={$db}" title="{$messages[@id='page.admin.viderlabase']}"><img src="icones/flush_base.png" alt="{$messages[@id='page.admin.viderlabase']}"/></a>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td>&#160;</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
	</xsl:template>

	<xsl:template match="sdx:result"/>
	<xsl:template match="sdx:results"/>
	
	<xsl:template match="lists">
		<br/>
		<br/>
		<table class="admintable" width="80%">
		<tr><td class="label"><xsl:value-of select="$messages[@id='page.admin.listesexternes']"/></td>
		<td><xsl:value-of select="$messages[@id='common.importCSV']"/></td>
		<td><xsl:value-of select="$messages[@id='common.exportCSV']"/></td>
		<td><xsl:value-of select="$messages[@id='page.admin.vider']"/></td>
		</tr>
		<xsl:for-each select="list">
			<tr>
			<td class="label"><a class="nav" href="admin_edit_liste.xsp?list={@name}" title="{$messages[@id='page.admin.editiondelaliste']}"><xsl:value-of select="@name"/></a>
			<xsl:text> </xsl:text>
				<span dir="ltr">(<span dir="{$langDirection}"><xsl:choose>
					<xsl:when test="normalize-space(nb) = '0'"><xsl:value-of select="$messages[@id='page.admin.listevide']"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="normalize-space(nb)"/>&#160;<xsl:value-of select="$messages[@id='common.element_s']"/></xsl:otherwise>
				</xsl:choose></span>)</span>
			</td>
			<td>
				<a class="nav" href="list_import.xsp?list={@name}" title="{$messages[@id='common.importauformattexteseparateurvirgule']}"><img src="icones/import_csv.png" alt="{$messages[@id='common.importCSV']}"/></a>
			</td>
			<td>
				<a class="nav" href="list_export.xsp?list={@name}" title="{$messages[@id='common.exportauformattexteseparateurvirgule']}"><img src="icones/export_csv.png" alt="{$messages[@id='common.exportCSV']}"/></a>
			</td>
			<td>
				<a class="nav" href="list_pre_flush.xsp?list={@name}" title="{$messages[@id='page.admin.viderlaliste']}"><img src="icones/flush_list.png" alt="{$messages[@id='page.admin.viderlaliste']}"/></a>
			</td>
			</tr>
		</xsl:for-each>
		</table>
	</xsl:template>

    <xsl:template match="noteditor">
        <p><xsl:copy-of select="$messages[@id='page.admin.noteditor']"/></p>
    </xsl:template>
    <xsl:template match="sdx:query"/>
</xsl:stylesheet>
