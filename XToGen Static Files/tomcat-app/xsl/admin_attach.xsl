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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx" xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="sdx dir">
    <xsl:import href="common.xsl"/>

	<xsl:template match="admin">
		<xsl:variable name="base" select="$urlparameter[@name='db']/@value"/>

		<h3><xsl:value-of select="$messages[@id='page.admin.basededocument']"/>&#160;<xsl:value-of select="$base"/></h3>

		<br/>
		<table width="70%" border="0">
			<tr>
			<td valign="top" bgcolor="#efefef">
				<xsl:call-template name="upload">
					<xsl:with-param name="base" select="$base"/>
					<xsl:with-param name="type">attach</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="list">
					<xsl:with-param name="base" select="$base"/>
					<xsl:with-param name="type">attach</xsl:with-param>
				</xsl:call-template>
			</td>
			</tr>
		</table>
		<br/>
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='page.saisie.retouralapagedadministration']"/></a>
	</xsl:template>

	<xsl:template name="upload">
		<xsl:param name="base"/>
		<xsl:param name="type"/>

		<h3><xsl:choose>
			<xsl:when test="$type='thumbnail'"><xsl:value-of select="$messages[@id='page.admin.vignettes']"/>
			</xsl:when>
			<xsl:when test="$type='attach'"><xsl:value-of select="$messages[@id='page.admin.piecesattachees']"/>
			</xsl:when>
			<xsl:otherwise>Uh ???</xsl:otherwise>
		</xsl:choose></h3>
		<h3></h3>
		<table width="100%" border="0" bgcolor="#e0e0e0">
			<tr><td class="saisie"><xsl:value-of select="$messages[@id='page.admin.ajouterunnouveaufichier']"/></td></tr>
			<tr><td class="saisie">
			<form enctype="multipart/form-data" action="upload_attach.xsp" method="post">
			<input type="hidden" name="type" value="{$type}"/>
			<input type="hidden" name="db" value="{$base}"/>
			<input type="file" name="attach_file"/>
			<input type="submit" value="{$messages[@id='page.admin.envoyer']}"/>
			</form>
			</td></tr>
		</table>
		<br/>
	</xsl:template>

	<xsl:template name="list">
		<xsl:param name="base"/>
		<xsl:param name="type"/>

		<xsl:variable name="files" select="document(concat($rootUrl,'list_',$type,'_',$base))/dir:directory"/>
		<xsl:if test="count($files/dir:file) = 0">
			<span class="erreur">
			<xsl:value-of select="$messages[@id='page.admin.aucunfichier']"/>
			</span>
		</xsl:if>
		<ul>
		<xsl:for-each select="$files/dir:file">
			<xsl:sort select="@name"/>
			<li><xsl:value-of select="@name"/><br/><small>[ <a class="nav" href="pre_delete_attach.xsp?db={$base}&amp;type={$type}&amp;file={@name}"><xsl:value-of select="$messages[@id='page.admin.supprimer']"/></a> ] [ <a class="nav" href="{$rootUrl}documents/{$base}/{$type}/{@name}"><xsl:value-of select="$messages[@id='page.admin.voir']"/></a> ]</small></li>
		</xsl:for-each>
		</ul>
	</xsl:template>

</xsl:stylesheet>
