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

	<xsl:variable name="op" select="$urlparameter[@name='op']/@value"/>
	<xsl:variable name="paramId" select="$urlparameter[@name='id']/@value"/>
	<xsl:variable name="paramLang" select="$urlparameter[@name='myLang']/@value"/>
	<xsl:variable name="list" select="$urlparameter[@name='list']/@value"/>

	<xsl:template match="file">
		<h3><xsl:value-of select="$messages[@id='page.admin_edit_liste.liste']"/>&#160;<xsl:value-of select="$list"/></h3>
		<small>
		[ <a class="nav" href="list_import.xsp?list={$list}"><xsl:value-of select="$messages[@id='common.importCSV']"/></a> ]
		[ <a class="nav" href="list_export.xsp?list={$list}"><xsl:value-of select="$messages[@id='common.exportCSV']"/></a> ]
		[ <a class="nav" href="list_pre_flush.xsp?list={$list}"><xsl:value-of select="$messages[@id='page.admin.viderlaliste']"/></a> ]
		</small>
		<br/>
		<br/>

		<xsl:variable name="myLangs" select="langs/lang"/>
		<xsl:variable name="myDefaultLang" select="$langs[@default]/@id"/>
		<xsl:variable name="defaultFile" select="files/file[@lang=$defaultLang]"/>
		<xsl:variable name="main" select="document($defaultFile)/list/item"/>

		<table border="0" width="100%" bgcolor="black" cellspacing="1" cellpadding="2">
			<tr>
				<th bgcolor="white"><xsl:value-of select="$messages[@id='page.admin_edit_liste.clef']"/></th>
				<xsl:for-each select="$myLangs">
					<th bgcolor="white">
					<xsl:if test="@id = $myDefaultLang">
						<xsl:attribute name="class">defaultlang</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="@id"/>
					<xsl:if test="@label">
						<br/><small><xsl:value-of select="@label"/></small>
					</xsl:if>
					</th>
				</xsl:for-each>
				<th bgcolor="white">&#160;</th>
			</tr>

			<xsl:choose>
				<xsl:when test="lists/list[@id=$list]/@sort='true'">
					<xsl:for-each select="$main">
						<xsl:sort/>
						<xsl:call-template name="manageRow">
							<xsl:with-param name="row" select="."/>
							<xsl:with-param name="myLangs" select="$myLangs"/>
							<xsl:with-param name="myDefaultLang" select="$myDefaultLang"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$main">
						<xsl:call-template name="manageRow">
							<xsl:with-param name="row" select="."/>
							<xsl:with-param name="myLangs" select="$myLangs"/>
							<xsl:with-param name="myDefaultLang" select="$myDefaultLang"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:otherwise>
</xsl:choose>

			<form>
			<input type="hidden" name="list" value="{$list}"/>
			<input type="hidden" name="op" value="add"/>
			<tr>
			<td bgcolor="white" align="center"><input type="text" name="id" size="4"/></td>
			<xsl:for-each select="$myLangs">
				<td bgcolor="white" align="center">
				<xsl:if test="@id = $myDefaultLang">
					<xsl:attribute name="class">defaultlang</xsl:attribute>
				</xsl:if>
				<input type="text" name="value_{@id}"/>
				</td>
			</xsl:for-each>
			<td bgcolor="white"><input type="image" src="icones/add.png" value="submit" title="{$messages[@id='page.admin_edit_liste.ajouter']}"/></td>
			</tr>
			</form>
		</table>
		<br/>
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='page.saisie.retouralapagedadministration']"/></a>
	</xsl:template>

	<xsl:template name="manageRow">
		<xsl:param name="row"/>
		<xsl:param name="myLangs"/>
		<xsl:param name="myDefaultLang"/>

		<xsl:variable name="id" select="$row/@id"/>
		<tr>
			<xsl:if test="$op='predel' and $paramId=$id">
				<xsl:attribute name="class">predel</xsl:attribute>
			</xsl:if>
			<td align="center">
				<xsl:choose>
				<xsl:when test="$op='add' and $paramId=$id">
					<xsl:attribute name="bgcolor">white</xsl:attribute>
					<xsl:attribute name="class">new</xsl:attribute>
				</xsl:when>
				<xsl:when test="$op='predel' and $paramId=$id">
					<xsl:attribute name="class">predel</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="bgcolor">white</xsl:attribute>
				</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="$id"/>
			</td>
			<xsl:for-each select="$myLangs">
				<td>
				<xsl:choose>
					<xsl:when test="$op='predel' and $paramId=$id">
						<xsl:attribute name="class">predel</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="bgcolor">white</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="@id = $myDefaultLang">
						<xsl:attribute name="class">defaultlang</xsl:attribute>
						<xsl:call-template name="table-item">
							<xsl:with-param name="myLang" select="@id"/>
							<xsl:with-param name="id" select="$id"/>
							<xsl:with-param name="value" select="$main[@id=$id]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="myLang" select="@id"/>
						<xsl:variable name="items" select="document(//files/file[@lang=$myLang])/list/item"/>
						<xsl:variable name="ritems" select="$items[@id=$id]"/>
						<xsl:choose>
							<xsl:when test="count($ritems)=0">
								<xsl:call-template name="table-item">
									<xsl:with-param name="myLang" select="@id"/>
									<xsl:with-param name="id" select="$id"/>
									<xsl:with-param name="value" select="''"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="count($ritems)=1">
								<xsl:call-template name="table-item">
									<xsl:with-param name="myLang" select="@id"/>
									<xsl:with-param name="id" select="$id"/>
									<xsl:with-param name="value" select="$ritems"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="value">
									<xsl:for-each select="$ritems">
										<xsl:if test="position() != 1">|</xsl:if>
										<xsl:value-of select="."/>
									</xsl:for-each>
								</xsl:variable>
								<xsl:call-template name="table-item">
									<xsl:with-param name="myLang" select="@id"/>
									<xsl:with-param name="id" select="$id"/>
									<xsl:with-param name="value" select="$value"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				</td>
			</xsl:for-each>
		<td>
			<xsl:choose>
				<xsl:when test="$op='predel' and $paramId=$id">
					<xsl:attribute name="class">predel</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="bgcolor">white</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<form action="admin_edit_liste.xsp">
			<input type="hidden" name="list" value="{$list}"/>
			<input type="hidden" name="op" value="predel"/>
			<input type="hidden" name="id" value="{$id}"/>
			<input type="image" src="icones/delete.png" value="submit" title="{$messages[@id='page.admin_edit_liste.supprimer']}"/>
			</form>
		</td>
		</tr>
	</xsl:template>

	<xsl:template name="table-item">
		<xsl:param name="myLang"/>
		<xsl:param name="id"/>
		<xsl:param name="value"/>

		<xsl:choose>
			<xsl:when test="$op='edit' and $paramId=$id and $paramLang=$myLang">
				<xsl:attribute name="class">tomodify</xsl:attribute>
				<a name="mod"/>
				<form action="admin_edit_liste.xsp#mod">
					<input type="hidden" name="myLang" value="{$myLang}"/>
					<input type="hidden" name="id" value="{$id}"/>
					<input type="hidden" name="list" value="{$list}"/>
					<input type="hidden" name="op" value="mod"/>
					<input type="text" name="value" value="{$value}"/>
					<input type="image" src="icones/edit.png" value="submit" title="{$messages[@id='page.admin_edit_liste.modifier']}"/>
				</form>
			</xsl:when>
			<xsl:when test="$op='mod' and $paramId=$id and $paramLang=$myLang">
				<xsl:attribute name="class">modified</xsl:attribute>
				<xsl:value-of select="$value"/>
				<a name="mod"/>
			</xsl:when>
			<xsl:when test="$op='add' and $paramId=$id">
				<xsl:attribute name="class">new</xsl:attribute>
				<xsl:value-of select="$value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="not($op) or $op!='edit' or $paramId!=$id or $paramLang!=$myLang">
			<xsl:text> </xsl:text>
			<a class="nav" href="admin_edit_liste.xsp?list={$list}&amp;op=edit&amp;id={$id}&amp;myLang={@id}#mod"><img src="icones/edit.png" border="0" title="{$messages[@id='page.admin_edit_liste.modifier']}"/></a>
		</xsl:if>
	</xsl:template>

	<xsl:template match="error">
		<span class="error"><xsl:value-of select="$messages[@id='page.admin_edit_liste.erreur']"/>:
		<xsl:variable name="keye" select="concat('page.admin_edit_liste.erreur.',@key)"/>
		<xsl:variable name="keyd" select="concat($keye,'.debut')"/>
		<xsl:variable name="keyf" select="concat($keye,'.fin')"/>
		<xsl:choose>
			<xsl:when test="@file">
				<xsl:value-of select="$messages[@id=$keyd]"/><xsl:value-of select="@file"/><xsl:value-of select="$messages[@id=$keyf]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$messages[@id=$keye]"/>
			</xsl:otherwise>
		</xsl:choose>
		</span>
		<br/>
	</xsl:template>

	<xsl:template match="success">
		<xsl:variable name="key" select="@key"/>
		<xsl:if test="count(preceding-sibling::success[@key=$key])=0">
		<xsl:variable name="labelkey" select="concat('page.admin_edit_liste.succes.',$key)"/>
		<span class="success"><xsl:value-of select="$messages[@id=$labelkey]"/>
		</span><br/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="question">
		<xsl:variable name="id" select="$urlparameter[@name='id']/@value"/>
		<div align="center" class="predel"><xsl:value-of select="$messages[@id='page.admin_edit_liste.voulezvousvraimentsupprimerlaligne']"/><br/>
			<a class="nav" href="admin_edit_liste.xsp?list={$list}&amp;op=del&amp;id={$id}"><xsl:value-of select="$messages[@id='common.oui']"/></a>	
			&#160;
			<a class="nav" href="admin_edit_liste.xsp?list={$list}"><xsl:value-of select="$messages[@id='common.non']"/></a>	
		</div>
	</xsl:template>

</xsl:stylesheet>
