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
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	exclude-result-prefixes="xsl sdx urle xtg">

	<xsl:import href="template_access.xsl"/>

	<!-- Brochure seulement -->
	<xsl:template match="*[@id='xtg-fop-booklet-multiple']" mode="fop">
		<xsl:param name="docs"/>
		<xsl:param name="conf"/>

		<xsl:if test="$conf/type='multiple'">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="fop">
				<xsl:with-param name="docs" select="$docs"/>
				<xsl:with-param name="conf" select="$conf"/>
			</xsl:apply-templates>
		</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@id='xtg-fop-booklet-title']" mode="fop">
		<xsl:param name="docs"/>
		<xsl:param name="conf"/>
		
		<xsl:if test="$conf/type='multiple'">
			<xsl:copy>
				<xsl:copy-of select="@*[name()!='id']"/>
				<xsl:value-of select="$conf/title"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@id='xtg-fop-booklet-subtitle']" mode="fop">
		<xsl:param name="docs"/>
		<xsl:param name="conf"/>
		
		<xsl:if test="$conf/type='multiple'">
			<xsl:copy>
				<xsl:copy-of select="@*[name()!='id']"/>
				<xsl:value-of select="$conf/subtitle"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@id='xtg-fop-booklet-nbdocuments']" mode="fop">
		<xsl:param name="docs"/>
		<xsl:param name="conf"/>
		
		<xsl:if test="$conf/type='multiple'">
			<xsl:copy>
				<xsl:copy-of select="@*[name()!='id']"/>
				<xsl:value-of select="count($docs)"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$messages[@id='common.document_s']"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@id='xtg-fop-booklet-date']" mode="fop">
		<xsl:param name="docs"/>
		<xsl:param name="conf"/>
		
		<xsl:if test="$conf/type='multiple'">
			<xsl:copy>
				<xsl:copy-of select="@*[name()!='id']"/>
				<xsl:value-of select="$conf/date"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@id='xtg-fop-booklet-toc']" mode="fop">
		<xsl:param name="docs"/>
		<xsl:param name="conf"/>

		<xsl:if test="$conf/type='multiple'">
			<xsl:copy>
				<xsl:copy-of select="@*[name()!='id']"/>
				<xsl:value-of select="$messages[@id='page.pdf.sommaire']"/>
			</xsl:copy>
			<xsl:variable name="results" select="$docs[1]/ancestor::sdx:results"/>
			<xsl:for-each select="$results/sdx:result">
				<fo:block text-align-last="justify" margin-right="10pt">
					<fo:basic-link internal-destination="{sdx:field[@name='sdxdocid']/@value}">
						<xsl:variable name="node" select="child::*[name()!='sdx:field']"/>
						<xsl:call-template name="getdefaultfield">
							<xsl:with-param name="doc" select="$node"/>
							<xsl:with-param name="doctype" select="name($node)"/>
						</xsl:call-template>
					</fo:basic-link>
					<fo:leader leader-pattern="dots"/>
					<fo:page-number-citation ref-id="{sdx:field[@name='sdxdocid']/@value}"/>
				</fo:block>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@id='xtg-fop-booklet-page']" mode="fop">
		<xsl:param name="docs"/>
		<xsl:param name="conf"/>
		
		<xsl:variable name="tag" select="."/>
		<xsl:for-each select="$docs">
			<xsl:apply-templates select="$tag" mode="fop-page">
				<xsl:with-param name="doc" select="."/>
				<xsl:with-param name="conf" select="$conf"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[@id='xtg-fop-generated-by']" mode="fop">
		<xsl:param name="docs"/>
		<xsl:param name="conf"/>
		
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:value-of select="concat($messages[@id='page.pdf.documentgenerepar'],'XToGen ',$xtogenVersion)"/>
		</xsl:copy>
	</xsl:template>

	<!-- Page -->
	<xsl:template match="*[@id='xtg-fop-booklet-page']" mode="fop-page">
		<xsl:param name="doc"/>
		<xsl:param name="conf"/>
		
		<xsl:if test="$conf/type='multiple'">
			<fo:block break-before="page" id="{$doc/../sdx:field[@name='sdxdocid']/@value}"/>
		</xsl:if>
		<xsl:apply-templates mode="fop-page">
			<xsl:with-param name="doc" select="$doc"/>
			<xsl:with-param name="conf" select="$conf"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Nom du type de document -->
	<xsl:template match="*[@id='xtg-doctype-label']" mode="fop">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			
			<xsl:value-of select="$docType/label"/>
		</xsl:copy>
	</xsl:template>

	<!-- Ids -->
	<xsl:template match="*[starts-with(@id,'xtg-fieldgroup-id-')]" mode="fop-page">
		<xsl:param name="doc"/>
		<xsl:param name="conf"/>

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

				<xsl:apply-templates mode="fop-node">
					<xsl:with-param name="field" select="$node"/>
					<xsl:with-param name="fieldname" select="$fieldname"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[starts-with(@id,'xtg-field-id-')]" mode="fop-page">
		<xsl:param name="doc"/>
		<xsl:param name="conf"/>

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

							<xsl:apply-templates mode="fop-node">
								<xsl:with-param name="field" select="$node/@*[name()=$attname]"/>
								<xsl:with-param name="fieldname" select="$fieldname"/>
							</xsl:apply-templates>
						</xsl:copy>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$node!=''">
						<xsl:copy>
							<xsl:copy-of select="@*[name()!='id']"/>

							<xsl:apply-templates mode="fop-node">
								<xsl:with-param name="field" select="$node"/>
								<xsl:with-param name="fieldname" select="$fieldname"/>
							</xsl:apply-templates>
						</xsl:copy>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[starts-with(@id,'xtg-reversefield-')]" mode="fop-page">
		<xsl:param name="doc"/>
		<xsl:param name="conf"/>

		<xsl:variable name="fieldname" select="substring-after(@id,'xtg-reversefield-')"/>
		<xsl:variable name="reldoctype" select="substring-before($fieldname,'/')"/>
		<xsl:variable name="relfield" select="substring-after($fieldname,'/')"/>
		<xsl:variable name="relapplication">
			<xsl:choose>
				<xsl:when test="$urlparameter[@name='app']"><xsl:value-of select="$urlparameter[@name='app']/@value"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$currentapp"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="docid">
			<xsl:choose>
				<xsl:when test="$conf/type = 'single'">
					<xsl:value-of select="$urlparameter[@name='id']/@value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$doc/@id"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="url" select="concat($rootUrl,'query_',$reldoctype,'?hpp=-1&amp;f=',$relfield,'&amp;v=',$docid)"/>
		<xsl:variable name="related" select="document($url)/sdx:document/sdx:results"/>
		<xsl:variable name="nb" select="number($related/@nb)"/>

		<xsl:if test="$nb &gt;= 1">
			<xsl:copy>
				<xsl:copy-of select="@*[name()!='id']"/>

				<xsl:apply-templates mode="fop-reverse">
					<xsl:with-param name="doctype" select="$reldoctype"/>
					<xsl:with-param name="field" select="$relfield"/>
					<xsl:with-param name="application" select="$relapplication"/>
					<xsl:with-param name="related" select="$related"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[starts-with(@id,'xtg-field-name')]" mode="fop-node">
		<xsl:param name="field"/>
		<xsl:param name="fieldname"/>

		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>

			<xsl:value-of select="$docType/field[@name=$fieldname]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[starts-with(@id,'xtg-fieldgroup-name')]" mode="fop-node">
		<xsl:param name="field"/>
		<xsl:param name="fieldname"/>

		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>

			<xsl:value-of select="$docType/fieldgroup[@name=$fieldname]"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[starts-with(@id,'xtg-field-name')]" mode="fop-reverse">
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

	<xsl:template match="*[starts-with(@id,'xtg-fieldgroup-value')]" mode="fop-node">
		<xsl:param name="field"/>
		<xsl:param name="fieldname"/>

		<xsl:variable name="currentnode" select="."/>

		<xsl:choose>
			<xsl:when test="count($field)=1">
				<xsl:copy>
					<xsl:copy-of select="@*[name()!='id']"/>

					<xsl:apply-templates select="$currentnode/child::*" mode="fop-page">
						<xsl:with-param name="doc" select="$field"/>
					</xsl:apply-templates>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
					<xsl:copy>
						<xsl:copy-of select="@*[name()!='id']"/>

						<xsl:for-each select="$field">
							<xsl:apply-templates select="$currentnode/child::*" mode="fop-page">
								<xsl:with-param name="doc" select="."/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[starts-with(@id,'xtg-field-value')]" mode="fop-node">
		<xsl:param name="field"/>	
		<xsl:param name="fieldname"/>	

		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id' and name()!='name']"/>

			<xsl:call-template name="display-value">
				<xsl:with-param name="node" select="."/>
				<xsl:with-param name="field" select="$field"/>
				<xsl:with-param name="fieldname" select="$fieldname"/>
				<xsl:with-param name="mode">
					<xsl:choose>
						<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
						<xsl:otherwise>ul</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[starts-with(@id,'xtg-field-value')]" mode="fop-reverse">
		<xsl:param name="doctype"/>
		<xsl:param name="field"/>
		<xsl:param name="application"/>
		<xsl:param name="related"/>

		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>

			<xsl:call-template name="display-reverse-pdf2">
				<xsl:with-param name="db" select="$doctype"/>
				<xsl:with-param name="application" select="$application"/>
				<xsl:with-param name="related" select="$related"/>
				<xsl:with-param name="titlefield" select="$titlefields/dbase[@id=$doctype]"/>
				<xsl:with-param name="related" select="$related"/>
				<xsl:with-param name="linkuri" select="$sdxdocument/@uri"/>
			</xsl:call-template>

		</xsl:copy>
	</xsl:template>

	<!-- Identités -->
	<xsl:template match="child::node() | attribute::*" mode="fop">
		<xsl:param name="docs"/>
		<xsl:param name="conf"/>

		<xsl:copy>
			<xsl:apply-templates select="@*" mode="fop"/>
			<xsl:apply-templates select="node()" mode="fop">
				<xsl:with-param name="docs" select="$docs"/>
				<xsl:with-param name="conf" select="$conf"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="child::node() | attribute::*" mode="fop-page">
		<xsl:param name="doc"/>
		<xsl:param name="conf"/>

		<xsl:copy>
			<xsl:apply-templates select="@*" mode="fop-page"/>
			<xsl:apply-templates select="node()" mode="fop-page">
				<xsl:with-param name="doc" select="$doc"/>
				<xsl:with-param name="conf" select="$conf"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="child::node() | attribute::*" mode="fop-node">
		<xsl:param name="field"/>
		<xsl:param name="fieldname"/>

		<xsl:copy>
			<xsl:apply-templates select="@*" mode="fop-node"/>
			<xsl:apply-templates select="node()" mode="fop-node">
				<xsl:with-param name="field" select="$field"/>
				<xsl:with-param name="fieldname" select="$fieldname"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="child::node() | attribute::*" mode="fop-reverse">
		<xsl:param name="doctype"/>
		<xsl:param name="field"/>
		<xsl:param name="application"/>
		<xsl:param name="related"/>

		<xsl:copy>
			<xsl:apply-templates select="@*" mode="fop-reverse"/>
			<xsl:apply-templates select="node()" mode="fop-reverse">
				<xsl:with-param name="doctype" select="$doctype"/>
				<xsl:with-param name="field" select="$field"/>
				<xsl:with-param name="application" select="$application"/>
				<xsl:with-param name="related" select="$related"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<!-- Template principal d'affichage -->
	<xsl:template name="display-value">
		<xsl:param name="node"/>
		<xsl:param name="field"/>
		<xsl:param name="fieldname"/>
		<xsl:param name="mode"/>

		<xsl:variable name="fieldtype">
			<xsl:call-template name="getfieldtype">
				<xsl:with-param name="field" select="$fieldname"/>
				<xsl:with-param name="doctype" select="$currentdoctype"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="fieldnav">
			<xsl:choose>
				<xsl:when test="$conf_disp/documenttypes/documenttype[@id=$currentdoctype]/nav/on[@field=$fieldname]">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="count($field)=1 and $field!=''">
				<xsl:call-template name="display-typed-value">
					<xsl:with-param name="field" select="$field"/>
					<xsl:with-param name="fieldname" select="$fieldname"/>
					<xsl:with-param name="fieldtype" select="$fieldtype"/>
					<xsl:with-param name="fieldnav" select="$fieldnav"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:when test="count($field)&gt;1">
				<xsl:choose>
					<xsl:when test="$fieldtype='attach'">
						<xsl:for-each select="$field">
							<xsl:call-template name="display-typed-value">
								<xsl:with-param name="field" select="."/>
								<xsl:with-param name="fieldname" select="$fieldname"/>
								<xsl:with-param name="fieldtype" select="$fieldtype"/>
								<xsl:with-param name="fieldnav" select="$fieldnav"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="starts-with($mode,'separator-')">
								<xsl:variable name="sep" select="substring-after($mode,'separator-')"/>
								<xsl:for-each select="$field">
									<xsl:if test="position()!=1">
										<xsl:value-of select="$sep"/>
									</xsl:if>
									<xsl:call-template name="display-typed-value">
										<xsl:with-param name="field" select="."/>
										<xsl:with-param name="fieldname" select="$fieldname"/>
										<xsl:with-param name="fieldtype" select="$fieldtype"/>
										<xsl:with-param name="fieldnav" select="$fieldnav"/>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="$mode='ul'">
								<fo:list-block provisional-distance-between-starts="18pt"
									   provisional-label-separation="3pt">	
									<xsl:for-each select="$field">
										<fo:list-item>
											<fo:list-item-label end-indent="label-end()">
												<fo:block>&#x2022;</fo:block>
											</fo:list-item-label>
											<fo:list-item-body start-indent="body-start()">
												<fo:block>
													<xsl:call-template name="display-typed-value">
														<xsl:with-param name="field" select="."/>
														<xsl:with-param name="fieldname" select="$fieldname"/>
														<xsl:with-param name="fieldtype" select="$fieldtype"/>
														<xsl:with-param name="fieldnav" select="$fieldnav"/>
													</xsl:call-template>
												</fo:block>
											</fo:list-item-body>
										</fo:list-item>
									</xsl:for-each>
								</fo:list-block>
							</xsl:when>
							<xsl:otherwise>
								<fo:block>ERREUR : (mode = <xsl:value-of select="$mode"/>)</fo:block>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="display-typed-value">
		<xsl:param name="field"/>
		<xsl:param name="fieldname"/>
		<xsl:param name="fieldtype"/>
		<xsl:param name="fieldnav"/>

		<xsl:choose>
			<!-- String -->
			<xsl:when test="$fieldtype='string'">
				<xsl:call-template name="string2">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
					<xsl:with-param name="nav" select="$fieldnav"/>
					<xsl:with-param name="evalue" select="urle:encode(string(string($field)),'UTF-8')"/>
				</xsl:call-template>
			</xsl:when>

			<!-- E-mail -->
			<xsl:when test="$fieldtype='email'">
				<xsl:call-template name="email2">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
				</xsl:call-template>
			</xsl:when>

			<!-- Url -->
			<xsl:when test="$fieldtype='url'">
				<xsl:call-template name="url2">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
				</xsl:call-template>
			</xsl:when>

			<!-- Choice -->
			<xsl:when test="$fieldtype='choice'">
				<xsl:variable name="fieldlist" select="xtogenconf/lists/list[@doc=$currentdoctype and @field=$fieldname]"/>

				<xsl:call-template name="choice2">
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

				<xsl:call-template name="relation2">
					<xsl:with-param name="field" select="$fieldname"/>
					<xsl:with-param name="value" select="$field"/>
					<xsl:with-param name="base" select="$relations/relation[@doc=$currentdoctype and @field=$fieldname]"/>
					<xsl:with-param name="application" select="$docapp"/>
				</xsl:call-template>
			</xsl:when>

			<!-- Text -->
			<xsl:when test="$fieldtype='text'">
				<xsl:call-template name="text2">
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

				<xsl:call-template name="attach2">
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

			<!-- Otherwise : error -->
			<xsl:otherwise>
				<fo:block><xsl:value-of select="$fieldname"/> = <xsl:value-of select="$field"/>
					(<xsl:value-of select="$fieldtype"/>)
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
