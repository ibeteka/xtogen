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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	xmlns:urle="java.net.URLEncoder"
	xmlns:xtg="http://xtogen.tech.fr"
	exclude-result-prefixes="xsl sdx urle xtg">

	<xsl:import href="template_access.xsl"/>

	<!-- Navigation -->
	<xsl:template match="*[@id='xtg-document-nav']" mode="xhtml-doc">
		<xsl:param name="doc"/>

		<xsl:if test="$sdxdocument//sdx:navigation">
			<xsl:variable name="sdxnav" select="$sdxdocument//sdx:navigation"/>
			<xsl:copy>
				<xsl:attribute name="align"><xsl:value-of select="$alignDirection"/></xsl:attribute>
				<xsl:copy-of select="@*[name()!='id']"/>
				<xsl:if test="$sdxnav/sdx:previous">
					<xsl:variable name="previous" select="$sdxnav/sdx:previous"/>
					<a title="{$messages[@id='common.documentprecedent']}" href="{$sdxdocument/@uri}?app={$previous/@app}&amp;db={$previous/@base}&amp;id={$previous/@docId}&amp;qid={$previous/../@queryId}&amp;n={$previous/@no}">
						<img alt="{$messages[@id='common.documentprecedent']}" src="{$iconPrev}"/>
					</a>
				</xsl:if>
				<xsl:if test="$sdxnav/sdx:next">
					<xsl:variable name="next" select="$sdxnav/sdx:next"/>
					<a title="{$messages[@id='common.documentsuivant']}" href="{$sdxdocument/@uri}?app={$next/@app}&amp;db={$next/@base}&amp;id={$next/@docId}&amp;qid={$next/../@queryId}&amp;n={$next/@no}">
						<img alt="{$messages[@id='common.documentsuivant']}" src="{$iconNext}"/>
					</a>
				</xsl:if>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- Gestion de l'affichage -->
	<xsl:template match="*[starts-with(@id,'xtg-field-id-')]" mode="xhtml-doc">
		<xsl:param name="doc"/>

		<xsl:variable name="fieldname" select="substring-after(@id,'xtg-field-id-')"/>

		<xsl:variable name="nodename">
			<xsl:call-template name="getnamedfield">
				<xsl:with-param name="doc" select="$doc"/>
				<xsl:with-param name="field" select="$fieldname"/>
				<xsl:with-param name="doctype" select="$dbId"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="basenode">
			<xsl:choose>
				<xsl:when test="contains($nodename,'/')"><xsl:value-of select="substring-before($nodename,'/')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$nodename"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="node" select="$doc/descendant-or-self::*[name()=$basenode]"/>
		<xsl:if test="$node">
			<xsl:choose>
				<xsl:when test="$nodename != $basenode">
					<xsl:variable name="attname" select="substring-after($nodename,'@')"/>
					<xsl:if test="$node/@*[name()=$attname]">
						<xsl:copy>
							<xsl:copy-of select="@*[name()!='id']"/>
							<xsl:apply-templates mode="xhtml-doc">
								<xsl:with-param name="doc" select="$doc"/>
								<xsl:with-param name="fieldname" select="$fieldname"/>
								<xsl:with-param name="field" select="$node/@*[name()=$attname]"/>
							</xsl:apply-templates>
						</xsl:copy>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$node!=''">
						<xsl:copy>
							<xsl:copy-of select="@*[name()!='id']"/>
							<xsl:apply-templates mode="xhtml-doc">
								<xsl:with-param name="doc" select="$doc"/>
								<xsl:with-param name="fieldname" select="$fieldname"/>
								<xsl:with-param name="field" select="$node"/>
							</xsl:apply-templates>
						</xsl:copy>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- Champ inverse -->
	<xsl:template match="*[starts-with(@id,'xtg-reversefield-')]" mode="xhtml-doc">
		<xsl:param name="doc"/>

		<xsl:variable name="fieldname" select="substring-after(@id,'xtg-reversefield-')"/>
		<xsl:variable name="reldoctype" select="substring-before($fieldname,'/')"/>
		<xsl:variable name="relfield" select="substring-after($fieldname,'/')"/>
		<xsl:variable name="relapplication">
			<xsl:choose>
				<xsl:when test="$urlparameter[@name='app']"><xsl:value-of select="$urlparameter[@name='app']/@value"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$currentapp"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="url" select="concat($rootUrl,'query_',$reldoctype,'?hpp=-1&amp;f=',$relfield,'&amp;v=',$urlparameter[@name='id']/@value)"/>
		<xsl:variable name="related" select="document($url)/sdx:document/sdx:results"/>
		<xsl:variable name="nb" select="number($related/@nb)"/>

		<xsl:if test="$nb &gt;= 1">
			<xsl:copy>
				<xsl:copy-of select="@*[name()!='id']"/>

				<xsl:apply-templates mode="xhtml-reverse">
					<xsl:with-param name="doctype" select="$reldoctype"/>
					<xsl:with-param name="field" select="$relfield"/>
					<xsl:with-param name="application" select="$relapplication"/>
					<xsl:with-param name="related" select="$related"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- Fieldgroups -->
	<xsl:template match="*[starts-with(@id,'xtg-fieldgroup-id-')]" mode="xhtml-doc">
		<xsl:param name="doc"/>
		<xsl:param name="fieldname"/>
		<xsl:param name="field"/>

		<xsl:variable name="currentnode" select="."/>

		<xsl:variable name="fieldname" select="substring-after(@id,'xtg-fieldgroup-id-')"/>

		<xsl:variable name="nodename">
			<xsl:call-template name="getnamedfield">
				<xsl:with-param name="doc" select="$doc"/>
				<xsl:with-param name="field" select="$fieldname"/>
				<xsl:with-param name="doctype" select="$dbId"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="node" select="$doc/descendant-or-self::*[name()=$nodename]"/>

		<xsl:if test="$node">
			<xsl:copy>
				<xsl:copy-of select="@*[name()!='id']"/>
				<xsl:apply-templates mode="xhtml-doc">
					<xsl:with-param name="doc" select="$doc"/>
					<xsl:with-param name="fieldname" select="$fieldname"/>
					<xsl:with-param name="field" select="$node"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- Nom du champ -->
	<xsl:template match="*[@id='xtg-field-name']" mode="xhtml-doc">
		<xsl:param name="doc"/>
		<xsl:param name="fieldname"/>
		<xsl:param name="field"/>

		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:value-of select="$docType/field[@name=$fieldname]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[@id='xtg-fieldgroup-name']" mode="xhtml-doc">
		<xsl:param name="doc"/>
		<xsl:param name="fieldname"/>
		<xsl:param name="field"/>

		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:value-of select="$docType/fieldgroup[@name=$fieldname]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[@id='xtg-field-name']" mode="xhtml-reverse">
		<xsl:param name="doctype"/>
		<xsl:param name="field"/>
		<xsl:param name="application"/>
		<xsl:param name="related"/>

		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:choose>
				<xsl:when test="$related/@nb = 1">
					<xsl:value-of select="$docType/vfield[@doc=$doctype and @field=$field]/one"/>
				</xsl:when>
				<xsl:when test="$related/@nb &gt; 1">
					<xsl:value-of select="$docType/vfield[@doc=$doctype and @field=$field]/more"/>
				</xsl:when>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<!-- Valeur du champ -->
	<xsl:template match="*[@id='xtg-fieldgroup-value']" mode="xhtml-doc">
		<xsl:param name="doc"/>
		<xsl:param name="fieldname"/>
		<xsl:param name="field"/>

		<xsl:variable name="currentnode" select="."/>

		<xsl:choose>
			<xsl:when test="count($field)=1">
				<xsl:copy>
					<xsl:copy-of select="@*[name()!='id']"/>

					<xsl:apply-templates select="$currentnode/child::*" mode="xhtml-doc">
						<xsl:with-param name="doc" select="$doc"/>
						<xsl:with-param name="fieldname" select="$fieldname"/>
						<xsl:with-param name="field" select="$field"/>
					</xsl:apply-templates>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
					<xsl:copy>
						<xsl:copy-of select="@*[name()!='id']"/>

						<xsl:for-each select="$field">
							<xsl:apply-templates select="$currentnode/child::*" mode="xhtml-doc">
								<xsl:with-param name="doc" select="."/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[@id='xtg-field-value']" mode="xhtml-reverse">
		<xsl:param name="doctype"/>
		<xsl:param name="field"/>
		<xsl:param name="application"/>
		<xsl:param name="related"/>

		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>

			<xsl:call-template name="display-reverse2">
				<xsl:with-param name="db" select="$doctype"/>
				<xsl:with-param name="field" select="$field"/>
				<xsl:with-param name="docId" select="$urlparameter[@name='id']/@value"/>
				<xsl:with-param name="application" select="$application"/>
				<xsl:with-param name="related" select="$related"/>
			</xsl:call-template>

		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[@id='xtg-field-value']" mode="xhtml-doc">
		<xsl:param name="doc"/>
		<xsl:param name="fieldname"/>
		<xsl:param name="field"/>

		<xsl:variable name="fieldtype">
			<xsl:call-template name="getfieldtype">
				<xsl:with-param name="field" select="$fieldname"/>
				<xsl:with-param name="doctype" select="$currentdoctype"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="fieldnav">
			<xsl:choose>
				<xsl:when test="$conf_disp/documenttypes/documenttype[@id=$currentdoctype]/nav/on[@field=$fieldname] and $titlefields/dbase[@id=$currentdoctype]!=$fieldname">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$field">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>

			<xsl:choose>
				<xsl:when test="count($field)=1 and $field!=''">
					<xsl:call-template name="display-value">
						<xsl:with-param name="fieldtype" select="$fieldtype"/>
						<xsl:with-param name="fieldnav" select="$fieldnav"/>
						<xsl:with-param name="fieldname" select="$fieldname"/>
						<xsl:with-param name="field" select="$field"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$fieldtype='attach'">
							<div id="galerie">
							<xsl:for-each select="$field">
								<div class="float">
									<xsl:call-template name="display-value">
										<xsl:with-param name="fieldtype" select="$fieldtype"/>
										<xsl:with-param name="fieldnav" select="$fieldnav"/>
										<xsl:with-param name="fieldname" select="$fieldname"/>
										<xsl:with-param name="field" select="."/>
									</xsl:call-template>
								</div>
							</xsl:for-each>
							</div>
							<div class="spacer"> </div>
						</xsl:when>
						<xsl:otherwise>
							<!-- TODO: TRAITEMENT DES DIFFERENTS SEPARATEURS -->
							<ul>
								<xsl:for-each select="$field">
									<li>
									<xsl:call-template name="display-value">
										<xsl:with-param name="fieldtype" select="$fieldtype"/>
										<xsl:with-param name="fieldnav" select="$fieldnav"/>
										<xsl:with-param name="fieldname" select="$fieldname"/>
										<xsl:with-param name="field" select="."/>
									</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!-- Affichage de la valeur d'un champ -->
	<xsl:template name="display-value">
		<xsl:param name="fieldtype"/>
		<xsl:param name="fieldnav"/>
		<xsl:param name="fieldname"/>
		<xsl:param name="field"/>

		<xsl:choose>
			<!-- String -->
			<xsl:when test="$fieldtype='string'">
				<xsl:call-template name="string">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
					<xsl:with-param name="nav" select="$fieldnav"/>
					<xsl:with-param name="evalue" select="urle:encode(string(string($field)),'UTF-8')"/>
				</xsl:call-template>
			</xsl:when>

			<!-- E-mail -->
			<xsl:when test="$fieldtype='email'">
				<xsl:call-template name="email">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
				</xsl:call-template>
			</xsl:when>

			<!-- URL -->
			<xsl:when test="$fieldtype='url'">
				<xsl:call-template name="url">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
				</xsl:call-template>
			</xsl:when>

			<!-- Choice -->
			<xsl:when test="$fieldtype='choice'">
				<xsl:variable name="fieldlist" select="xtogenconf/lists/list[@doc=$currentdoctype and @field=$fieldname]"/>

				<xsl:call-template name="choice">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
					<xsl:with-param name="nav" select="$fieldnav"/>
					<xsl:with-param name="evalue" select="urle:encode(string(string($field)),'UTF-8')"/>
					<xsl:with-param name="list" select="$fieldlist"/>
				</xsl:call-template>
			</xsl:when>

			<!-- Relation -->
			<xsl:when test="$fieldtype='relation'">
				<xsl:variable name="docapp">
					<xsl:choose>
						<xsl:when test="$urlparameter[@name='app']"><xsl:value-of select="$urlparameter[@name='app']/@value"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$currentapp"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:call-template name="relation">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
					<xsl:with-param name="base" select="$relations/relation[@doc=$currentdoctype and @field=$fieldname]"/>
					<xsl:with-param name="application" select="$docapp"/>
				</xsl:call-template>
			</xsl:when>

			<!-- Text -->
			<xsl:when test="$fieldtype='text'">
				<xsl:call-template name="text">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
				</xsl:call-template>
			</xsl:when>

			<!-- Attach -->
			<xsl:when test="$fieldtype='attach'">
				<xsl:variable name="docapp">
					<xsl:choose>
						<xsl:when test="$urlparameter[@name='app']"><xsl:value-of select="$urlparameter[@name='app']/@value"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$currentapp"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:call-template name="attach">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
					<xsl:with-param name="base" select="$currentdoctype"/>
					<xsl:with-param name="application" select="$docapp"/>
					<xsl:with-param name="mode">
						<xsl:choose>
							<xsl:when test="$conf_disp/documenttypes/documenttype[@id=$currentdoctype]/document/on[@field=$fieldname]/@mode">
								<xsl:value-of select="$conf_disp/documenttypes/documenttype[@id=$currentdoctype]/document/on[@field=$fieldname]/@mode"/>
							</xsl:when>
							<xsl:otherwise>link</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>

			<!-- Autre : erreur -->
			<xsl:otherwise>
				<b><xsl:value-of select="$fieldname"/></b> = <xsl:value-of select="$field"/>
				(<xsl:value-of select="$fieldtype"/>)
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Identités -->
	<xsl:template match="child::node() | attribute::*" mode="xhtml-doc">
		<xsl:param name="doc"/>
		<xsl:param name="fieldname"/>
		<xsl:param name="field"/>

		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xhtml-doc"/>
			<xsl:apply-templates select="node()" mode="xhtml-doc">
				<xsl:with-param name="doc" select="$doc"/>
				<xsl:with-param name="fieldname" select="$fieldname"/>
				<xsl:with-param name="field" select="$field"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="child::node() | attribute::*" mode="xhtml-reverse">
		<xsl:param name="doctype"/>
		<xsl:param name="field"/>
		<xsl:param name="application"/>
		<xsl:param name="related"/>

		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xhtml-reverse"/>
			<xsl:apply-templates select="node()" mode="xhtml-doc">
				<xsl:with-param name="doctype" select="$doctype"/>
				<xsl:with-param name="field" select="$field"/>
				<xsl:with-param name="application" select="$application"/>
				<xsl:with-param name="related" select="$related"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
