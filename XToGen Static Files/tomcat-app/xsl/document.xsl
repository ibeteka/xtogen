<?xml version="1.0" encoding="utf-8"?>
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
<xsl:stylesheet version="1.1"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	exclude-result-prefixes="sdx xsl">
    <xsl:import href="common.xsl"/>
    <xsl:import href="document_all_docs.xsl"/>
    <xsl:import href="text_style.xsl"/>
    <xsl:import href="relation_display.xsl"/>
    <xsl:import href="template_document.xsl"/>

	<xsl:variable name="dbId" select="$urlparameter[@name='db']/@value"/>
	<xsl:variable name="docType" select="$labels/doctype[@name=$dbId]"/>
	<xsl:variable name="docId" select="$urlparameter[@name='id']/@value"/>
	<xsl:variable name="appId" select="/sdx:document/@app"/>


	<!-- Indirection -->
	<xsl:template match="document">
		<xsl:choose>
			<xsl:when test="$conf_disp/templates/template[@in='document-html']">
				<xsl:apply-templates select="." mode="template"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="normal"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Mode normal -->
	<xsl:template match="document" mode="normal">
		<xsl:apply-templates select="child::*"/>
	</xsl:template>

	<!-- Mode template -->
	<xsl:template match="document" mode="template">
	  <xsl:variable name="doctype" select="@type"/>
	  <table border="0" width="100%">
		 <tr>
			<td>
			   <h3>
				  <xsl:value-of select="$labels/doctype[@name=$doctype]/label"/>
			   </h3>
			   <xsl:if test="$urlparameter[@name='app']/@value != /sdx:document/@app">
				 <small>(application <xsl:value-of select="$urlparameter[@name='app']/@value"/>)</small>
			   </xsl:if>
			 <small>(<xsl:value-of select="$urlparameter[@name='id']/@value"/>)</small>
			</td>
			<td class="buttons" align="{$alignDirection}">
			   <xsl:call-template name="bouton_documents">
				  <xsl:with-param name="titlefield" select="$titlefields/dbase[@id=$doctype]"/>
			   </xsl:call-template>
			</td>
		 </tr>
	  </table>
	  <xsl:variable name="doc" select="child::*[name()=$doctype]"/>
	  <xsl:comment> Insertion du document (debut) </xsl:comment>
		<xsl:variable name="langtemplateurl" select="concat('../templates/doc_',@type,'_',$lang,'.html')"/>
		<xsl:variable name="generaltemplateurl" select="concat('../templates/doc_',@type,'.html')"/>
		<xsl:choose>
			<xsl:when test="document($langtemplateurl)">
				<xsl:apply-templates select="document($langtemplateurl)/html/body/child::*" mode="xhtml-doc">
					<xsl:with-param name="doc" select="$doc"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="document($generaltemplateurl)">
				<xsl:apply-templates select="document($generaltemplateurl)/html/body/child::*" mode="xhtml-doc">
					<xsl:with-param name="doc" select="$doc"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
			<span class="erreur">
			Erreur : template de langue <xsl:value-of select="$langtemplateurl"/> 
				et template générique <xsl:value-of select="generaltemplateurl"/> introuvables !!!
			</span>
			</xsl:otherwise>
		</xsl:choose>
	  <xsl:comment> Insertion du document (fin) </xsl:comment>
	</xsl:template>

	<!-- Navigation -->
    <xsl:template match="sdx:navigation" mode="in">
        <tr>
			<td/>
            <td align="{$alignDirection}">
                <xsl:apply-templates select="sdx:previous"/>
                <xsl:apply-templates select="sdx:next"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="sdx:next">
        <a title="{$messages[@id='common.documentsuivant']}" href="{$sdxdocument/@uri}?app={@app}&amp;db={@base}&amp;id={@docId}&amp;qid={../@queryId}&amp;n={@no}">
            <img alt="{$messages[@id='common.documentsuivant']}" src="{$iconNext}"/>
        </a>
    </xsl:template>
    <xsl:template match="sdx:previous">
        <a title="{$messages[@id='common.documentprecedent']}" href="{$sdxdocument/@uri}?app={@app}&amp;db={@base}&amp;id={@docId}&amp;qid={../@queryId}&amp;n={@no}">
            <img alt="{$messages[@id='common.documentprecedent']}" src="{$iconPrev}"/>
        </a>
    </xsl:template>

	<!-- Icones -->
	<xsl:template name="bouton_documents">
		<xsl:param name="titlefield"/>
		<xsl:variable name="id" select="$urlparameter[@name='id']/@value"/>
		<xsl:variable name="base" select="$urlparameter[@name='db']/@value"/>
		<xsl:variable name="app" select="$urlparameter[@name='app']/@value"/>
		<xsl:variable name="title" select="$sdxdocument/sdx:results/sdx:result[1]/sdx:field[@name=$titlefield]/@escapedValue"/>

		<!-- afficher icône vcard -->
		<!--
		<xsl:if test="$dbId = 'vCard'">
			<a class="nav" href="export_vcf.xsp?id={$id}&amp;db={$base}&amp;app={$app}" title="{$messages[@id='page.admin.exportvcf']}">
				<img src="icones/export_vcf.png" alt="{$messages[@id='page.admin.exportvcf']}"/>
			</a>
			<xsl:text> </xsl:text>
		</xsl:if>
		-->

		<!-- afficher icône pdf -->
		<a class="nav" href="pdf_export.xsp?id={$id}&amp;db={$base}&amp;app={$app}" title="{$messages[@id='page.admin.exportpdf']}">
			<img src="icones/pdf.png" alt="{$messages[@id='page.admin.exportpdf']}"/>
		</a>
			&#160;

		<!-- Edition et export sont pour le groupe saisie de la ville -->
		<xsl:if test="(count($currentuser/sdx:group[@id='saisie'])=1 and $currentuser/@app=$sdxdocument/@app) or $admin">
			<a class="nav" href="admin_saisie.xsp?id={$id}&amp;db={$base}&amp;app={$app}" title="{$messages[@id='page.admin.editerledocument']}">
				<img src="icones/edit.png" alt="{$messages[@id='page.admin.editerledocument']}"/>
			</a>
			&#160;
			<a class="nav" href="export.xsp?id={$id}&amp;db={$base}&amp;app={$app}" title="{$messages[@id='page.admin.exporterledocument']}">
				<img src="icones/export.png" alt="{$messages[@id='page.admin.exporterledocument']}"/>
			</a>
			&#160;
		</xsl:if>

		<!-- La suppression est réservée aux administrateurs -->
		<xsl:if test="$admin">
			<a class="nav" href="pre_delete.xsp?id={$id}&amp;db={$base}&amp;app={$app}&amp;title={$title}" title="{$messages[@id='page.admin.supprimerledocument']}">
				<img src="icones/delete.png" alt="{$messages[@id='page.admin.supprimerledocument']}"/>
			</a>
		</xsl:if>
	</xsl:template>

	<!-- Templates pour les labels -->
	<xsl:template name="label">
		<xsl:param name="field"/>
		<td valign="top" class="attribut"><xsl:value-of select="$docType/field[@name=$field]"/></td>
	</xsl:template>
	
	<!-- Templates pour les différents types d'attributs -->
	<!-- Chaîne de caractères -->
	<xsl:template name="string">
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:param name="evalue"/>
		<xsl:param name="nav">no</xsl:param>

		<xsl:choose>
			<xsl:when test="$nav='yes'">
				<a class="nav" href="query_{$dbId}.xsp?f={$field}&amp;v={$evalue}&amp;sortfield={$currentdoctypedefaultsortfield}&amp;order=ascendant"><xsl:apply-templates select="$value" mode="html"/></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$value" mode="html"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- E-mail -->
	<xsl:template name="email">
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<a class="url" href="mailto:{$value}">
			<xsl:if test="normalize-space($value/@label) != ''">
				<xsl:apply-templates select="$value/@label" mode="html"/> :
			</xsl:if>
			<xsl:apply-templates select="$value" mode="html"/>
		</a>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- url -->
	<xsl:template name="url">
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<a class="url" href="{$value}">
			<xsl:if test="normalize-space($value/@label) != ''">
				<xsl:apply-templates select="$value/@label" mode="html"/> :
			</xsl:if>
			<xsl:apply-templates select="$value" mode="html"/>
		</a>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- Liste de choix -->
	<xsl:template name="choice">
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:param name="nav">no</xsl:param>
		<xsl:param name="evalue"/>
		<xsl:param name="list"/>
		<xsl:choose>
			<xsl:when test="$nav='yes' and $evalue!=''">
				<xsl:choose>
					<xsl:when test="not($list) or $list=''">
						<a class="nav" href="query_{$dbId}.xsp?f={$field}&amp;v={$evalue}&amp;sortfield={$currentdoctypedefaultsortfield}&amp;order=ascendant">
							<xsl:apply-templates select="$value" mode="html"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a class="nav" href="query_{$dbId}.xsp?f={$choicefieldprefix}{$field}&amp;v={$evalue}&amp;list={$list}&amp;sortfield={$currentdoctypedefaultsortfield}&amp;order=ascendant"><xsl:apply-templates select="$value" mode="html"/></a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$value" mode="html"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- Relation -->
	<xsl:template name="relation">
		<xsl:param name="value"/>
		<xsl:param name="field"/>
		<xsl:param name="base"/>
		<xsl:param name="application"/>

		<xsl:call-template name="display-relation">
			<xsl:with-param name="value" select="$value"/>
			<xsl:with-param name="field" select="$field"/>
			<xsl:with-param name="base" select="$dbId"/>
			<xsl:with-param name="application" select="$application"/>
			<xsl:with-param name="db" select="$base"/>
		</xsl:call-template>
	</xsl:template>

	<!-- relation inverse -->
	<xsl:template name="reverse">
		<xsl:param name="db"/>
		<xsl:param name="field"/>
		<xsl:param name="application"/>

		<xsl:variable name="label" select="$docType/vfield[@doc=$db and @field=$field]/one"/>
		<xsl:variable name="labels" select="$docType/vfield[@doc=$db and @field=$field]/more"/>

		<xsl:call-template name="display-reverse">
			<xsl:with-param name="db" select="$db"/>
			<xsl:with-param name="field" select="$field"/>
			<xsl:with-param name="docId" select="$docId"/>
			<xsl:with-param name="application" select="$application"/>
			<xsl:with-param name="label" select="$label"/>
			<xsl:with-param name="labels" select="$labels"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Texte libre -->
	<xsl:template name="text">
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:apply-templates select="$value" mode="html"/>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- attach -->
	<xsl:template name="attach">
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:param name="base"/>
		<xsl:param name="application"/>
		<xsl:param name="mode">link</xsl:param>

		<!-- Variables -->
		<xsl:variable name="thnid" select="$value/@thn"/>
		<xsl:variable name="imgid" select="$value"/>

		<!-- Le label du document attaché -->
		<xsl:variable name="imglabel">
			<xsl:choose>
				<xsl:when test="$value/@label">
					<xsl:value-of select="$value/@label"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="contains($value,'/')">
							<xsl:value-of select="substring-after($value,'/')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- L'url du thumbnail -->
		<xsl:variable name="thnurl" select="concat($sdxdocument/@api-url,'/getatt?app=',$application,'&amp;base=',$dbId,'&amp;id=',$thnid,'&amp;doc=',$docId)"/>

		<!-- L'url du document attaché (via la page de visualisation) -->
		<xsl:variable name="imgurlvisu" select="concat('show_attach.xsp?app=',$application,'&amp;db=',$dbId,'&amp;id=',$imgid,'&amp;doc=',$docId,'&amp;label=',$imglabel,'&amp;q=',$urlparameter[@name='q']/@value,'&amp;qid=',$urlparameter[@name='qid']/@value,'&amp;n=',$urlparameter[@name='n']/@value)"/>
		<!-- L'url du document attaché (en direct) -->
		<xsl:variable name="imgurldirect" select="concat($sdxdocument/@api-url,'/getatt?app=',$application,'&amp;db=',$dbId,'&amp;id=',$imgid,'&amp;doc=',$docId)"/>

		<xsl:choose>
			<xsl:when test="$mode='inline'">
				<img src="{$imgurldirect}"/>
			</xsl:when>
			<xsl:when test="$mode='link'">
				<xsl:choose>
					<!-- S'il y a une vignette -->
					<xsl:when test="$value/@thn and not($conf_disp/documenttypes/documenttype[@id=$dbId]/document/on[@field=$field and @thnsize])">
						<xsl:choose>
						<!-- s'il y a un document attaché -->
						<xsl:when test="normalize-space($value) != ''">
							<!-- on fait un lien -->
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$imgurlvisu"/></xsl:attribute>
								<xsl:attribute name="title"><xsl:value-of select="$imglabel"/></xsl:attribute>
								<xsl:element name="img">
									<xsl:attribute name="src"><xsl:value-of select="$thnurl"/></xsl:attribute>
									<xsl:attribute name="alt"><xsl:value-of select="$imglabel"/></xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="img">
								<xsl:attribute name="src"><xsl:value-of select="$thnurl"/></xsl:attribute>
								<xsl:attribute name="alt"><xsl:value-of select="$imglabel"/></xsl:attribute>
							</xsl:element>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!-- Sinon, c'est un lien avec une vignette créée à la volée -->
						<xsl:variable name="thnsize">
							<xsl:choose>
								<xsl:when test="$conf_disp/documenttypes/documenttype[@id=$dbId]/document/on[@field=$field and @thnsize]">
									<xsl:value-of select="$conf_disp/documenttypes/documenttype[@id=$dbId]/document/on[@field=$field]/@thnsize"/>
								</xsl:when>
								<xsl:otherwise>150x150</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:element name="a">
							<xsl:attribute name="href"><xsl:value-of select="$imgurlvisu"/></xsl:attribute>
							<img src="{$rootUrl}thumbnail?app={$application}&amp;base={$base}&amp;id={$imgid}&amp;size={$thnsize}" alt="{$imglabel}" title="{$imglabel}"/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		
		<xsl:text>
</xsl:text>
	</xsl:template>

	<xsl:template match="/sdx:document/sdx:results"/>

</xsl:stylesheet>
