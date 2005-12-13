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
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:urle="java.net.URLEncoder"
	exclude-result-prefixes="sdx xsl">

    <xsl:import href="vars.xsl"/>
    <xsl:import href="pdf_export_all_docs.xsl"/>
    <xsl:import href="text_style.xsl"/>
	<xsl:import href="relation_display.xsl"/>
	<xsl:import href="template_pdf.xsl"/>

	<xsl:variable name="dbId" select="$urlparameter[@name='db']/@value"/>
	<xsl:variable name="docType" select="$labels/doctype[@name=$dbId]"/>
	<xsl:variable name="docId" select="$urlparameter[@name='id']/@value"/>
	<xsl:variable name="appId" select="/sdx:document/@app"/>

	<xsl:template match="/sdx:document">
		<xsl:apply-templates select="pdf"/>
	</xsl:template>

	<!-- Indirection -->
	<xsl:template match="pdf">
		<xsl:choose>
			<xsl:when test="$conf_disp/templates/template[@in='document-pdf']">
				<xsl:apply-templates select="." mode="template"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="normal"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="pdf" mode="template">
		<xsl:variable name="doctype" select="data/@doctype"/>
		<xsl:variable name="type" select="conf/type"/>
		<xsl:variable name="title" select="conf/title"/>
		<xsl:variable name="subtitle" select="conf/subtitle"/>

		<xsl:variable name="docs" select="data/descendant-or-self::*[name()=$doctype]"/>
		<xsl:variable name="langtemplateurl" select="concat('../templates/pdf_',$doctype,'_',$lang,'.fo')"/>
		<xsl:variable name="generaltemplateurl" select="concat('../templates/pdf_',$doctype,'.fo')"/>
		<xsl:choose>
			<xsl:when test="document($langtemplateurl)">
				<xsl:apply-templates select="document($langtemplateurl)/fo:root" mode="fop">
					<xsl:with-param name="docs" select="$docs"/>
					<xsl:with-param name="conf" select="conf"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="document($generaltemplateurl)">
				<xsl:apply-templates select="document($generaltemplateurl)/fo:root" mode="fop">
					<xsl:with-param name="docs" select="$docs"/>
					<xsl:with-param name="conf" select="conf"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
			<fo:root>
			  <fo:layout-master-set>
				<fo:simple-page-master master-name="first" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="2cm" margin-left="2.5cm" margin-right="2.5cm">
				  <fo:region-body margin-top="1cm"/>
				  <fo:region-before extent="1cm"/>
				  <fo:region-after extent="1.5cm"/>
				</fo:simple-page-master>
			  </fo:layout-master-set>
  				<fo:page-sequence master-reference="first">
					<fo:flow flow-name="xsl-region-body">
  						<fo:block font-family="Helvetica" font-size="14pt">
			Erreur : template de langue <xsl:value-of select="$langtemplateurl"/> 
				et template générique <xsl:value-of select="generaltemplateurl"/> introuvables !!!
						</fo:block>
					</fo:flow>
				</fo:page-sequence>
			</fo:root>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="pdf" mode="normal">
		<fo:root>
			<fo:layout-master-set>
				<xsl:if test="conf/type='multiple'">
					<fo:simple-page-master master-name="first" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="1cm" margin-left="0.3cm" margin-right="1cm">
						<fo:region-body margin="5cm" padding="6pt"/>
						<fo:region-before extent="2cm"/>
						<fo:region-after extent="1cm"/>
					</fo:simple-page-master>
				</xsl:if>
				<fo:simple-page-master master-name="simple" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="1cm" margin-left="0.3cm" margin-right="1cm">
					<fo:region-body margin-top="2cm" margin-bottom="1cm" margin-left="2cm"/>
					<fo:region-before extent="1.5cm"/>
					<fo:region-after extent="1cm"/>
					<fo:region-start extent="1.8cm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="sequence">
					<xsl:if test="conf/type='multiple'">
						<fo:single-page-master-reference master-reference="first"/>
					</xsl:if>
					<fo:repeatable-page-master-reference master-reference="simple"/>
				</fo:page-sequence-master>
			</fo:layout-master-set>

			<fo:page-sequence master-reference="sequence">

				<!-- Footer -->
				<fo:static-content flow-name="xsl-region-after">
					<fo:block text-align="end" font-size="10pt">
						<fo:page-number/> / <fo:page-number-citation ref-id="terminator"/>
					</fo:block>
				</fo:static-content>

				<!-- Contenu -->
				<fo:flow flow-name="xsl-region-body">

					<!-- Pour les brochures -->
					<xsl:if test="conf/type = 'multiple'">
						<!-- 1ère page -->
						<fo:block font-size="18pt" font-family="sans-serif"
							color="white" background-color="gray">
							<fo:block space-before="1.5cm" space-after="0cm" text-align="center">
								<xsl:value-of select="conf/title"/>
							</fo:block>
							<xsl:if test="conf/subtitle != ''">
								<fo:block font-size="16pt" space-before="0cm" space-after="0cm" text-align="center">
									<xsl:value-of select="conf/subtitle"/>
								</fo:block>
							</xsl:if>
							<fo:block font-size="12pt" space-before="1.5cm" space-after="0cm" text-align="center">
								<xsl:value-of select="data/sdx:results/@nb"/>&#160;<xsl:value-of select="$messages[@id='common.documents']"/>
							</fo:block>
							<fo:block break-after="page" font-size="12pt" font-style="italic" space-before="0cm" space-after="2cm" text-align="center">
								<xsl:value-of select="conf/date"/>
							</fo:block>

						</fo:block>

						<!-- Page de sommaire -->
						<xsl:call-template name="label2">
							<xsl:with-param name="value">Sommaire</xsl:with-param>
						</xsl:call-template>
							<xsl:for-each select="data/sdx:results/sdx:result">
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

					<xsl:apply-templates select="data">
						<xsl:with-param name="type" select="conf/type"/>
					</xsl:apply-templates>

					<fo:block>
						<fo:leader leader-length="15cm" leader-pattern="rule" rule-thickness="0.5pt" color="black"/>
					</fo:block>
					<fo:block font-size="8pt">
						<xsl:value-of select="concat($messages[@id='page.pdf.documentgenerepar'],'XToGen ',$xtogenVersion)"/>
					</fo:block>
					<fo:block id="terminator"/>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<!-- Template pour le titre -->
	<xsl:template name="title">
		<xsl:param name="value"/>

		<fo:block font-size="18pt" font-family="sans-serif" line-height="24pt"
			space-after.optimum="15pt" background-color="gray" color="white"
			text-align="center" padding-top="3pt">
            <xsl:value-of select="$value"/>
		</fo:block>
	</xsl:template>

	<!-- Templates pour les labels -->
	<xsl:template name="label">
		<xsl:param name="field"/>
		<xsl:param name="type"/>
		<xsl:param name="value"/>

		<xsl:if test="$type='text' or $type='choice' or count($value) &gt; 1">
			<xsl:call-template name="label2">
				<xsl:with-param name="value" select="$docType/field[@name=$field]"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Sous-template pour les labels -->
	<xsl:template name="label2">
		<xsl:param name="value"/>

		<fo:block 	background-color="gray"
			space-after.optimum="10pt"
			space-before.optimum="15pt"
			color="white">&#160;
			<xsl:value-of select="$value"/>
		</fo:block>
	</xsl:template>

	
	<!-- Templates pour les différents types d'attributs -->
	<!-- Chaîne de caractères -->
	<xsl:template name="string">
		<xsl:param name="field"/>
		<xsl:param name="value"/>

		<xsl:choose>
			<xsl:when test="count($value) &gt; 1">
				<fo:list-block provisional-distance-between-starts="18pt"
					   provisional-label-separation="3pt">	
					<xsl:for-each select="$value">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>&#x2022;</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block><xsl:value-of select="."/></fo:block>
							</fo:list-item-body>
						</fo:list-item>       
					</xsl:for-each>
				</fo:list-block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block space-before.optimum="15pt">
					<xsl:value-of select="$docType/field[@name=$field]"/>&#160;
					<xsl:value-of select="$value"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="string2">
		<xsl:param name="field"/>
		<xsl:param name="value"/>

		<xsl:value-of select="$value"/>
	</xsl:template>

	<!-- E-mail -->
	<xsl:template name="email">
		<xsl:param name="field"/>
		<xsl:param name="value"/>

		<xsl:choose>
			<xsl:when test="count($value) &gt; 1">
				<fo:list-block provisional-distance-between-starts="18pt"
					   provisional-label-separation="3pt">	
					<xsl:for-each select="$value">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>&#x2022;</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
							<fo:block>
							<fo:basic-link external-destination="mailto:{$value}"
								   text-decoration="none"
								   color="blue"><xsl:value-of select="."/>	
							</fo:basic-link>	
							</fo:block>
							</fo:list-item-body>
						</fo:list-item>       
					</xsl:for-each>
				</fo:list-block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block space-before.optimum="15pt">
					<xsl:value-of select="$docType/field[@name=$field]"/>&#160;
					<fo:basic-link external-destination="mailto:{$value}"
						   text-decoration="none"
						   color="blue"><xsl:value-of select="$value"/>	
					</fo:basic-link>	
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="email2">
		<xsl:param name="field"/>
		<xsl:param name="value"/>

		<fo:basic-link external-destination="mailto:{$value}"
			   text-decoration="none" color="blue"><xsl:value-of select="$value"/>	
		</fo:basic-link>	
	</xsl:template>

	<!-- url -->
	<xsl:template name="url">
		<xsl:param name="field"/>
		<xsl:param name="value"/>

		<xsl:choose>
			<xsl:when test="count($value) &gt; 1">
				<fo:list-block provisional-distance-between-starts="18pt"
					   provisional-label-separation="3pt">	
					<xsl:for-each select="$value">
						<xsl:if test=".!=''">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>&#x2022;</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
							<fo:block>
								<xsl:if test="@label">
									<xsl:value-of select="@label"/> :
								</xsl:if>
								<fo:basic-link external-destination="{.}"
								   text-decoration="none"
								   color="blue"><xsl:value-of select="."/>	
								</fo:basic-link>	
							</fo:block>
							</fo:list-item-body>
						</fo:list-item>       
						</xsl:if>
					</xsl:for-each>
				</fo:list-block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block space-before.optimum="15pt">
					<xsl:value-of select="$docType/field[@name=$field]"/>&#160;
					<xsl:if test="$value/@label">
						<xsl:value-of select="$value/@label"/> :
					</xsl:if>
					<xsl:if test="$value!=''">
					<fo:basic-link external-destination="{$value}"
						   text-decoration="none"
						   color="blue"><xsl:value-of select="$value"/>	
					</fo:basic-link>	
					</xsl:if>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="url2">
		<xsl:param name="field"/>
		<xsl:param name="value"/>

		<xsl:if test="$value/@label">
			<xsl:value-of select="$value/@label"/> :
		</xsl:if>
		<xsl:if test="$value!=''">
			<fo:basic-link external-destination="{$value}"
				   text-decoration="none"
				   color="blue"><xsl:value-of select="$value"/>	
			</fo:basic-link>	
		</xsl:if>
	</xsl:template>

	<!-- Liste de choix -->
	<xsl:template name="choice">
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<fo:list-block provisional-distance-between-starts="18pt"
               provisional-label-separation="3pt">	
		<xsl:for-each select="$value">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>&#x2022;</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block><xsl:value-of select="."/></fo:block>
				</fo:list-item-body>
			</fo:list-item>       
		</xsl:for-each>
		</fo:list-block>
	</xsl:template>

	<xsl:template name="choice2">
		<xsl:param name="field"/>
		<xsl:param name="value"/>

		<xsl:value-of select="$value"/>
	</xsl:template>

	<!-- Relation -->
	<xsl:template name="relation">
		<xsl:param name="value"/>
		<xsl:param name="field"/>
		<xsl:param name="base"/>
		<xsl:param name="application"/>

		<xsl:variable name="titlefield" select="$titlefields/dbase[@id=$base]"/>
		<xsl:variable name="linkuri" select="'pdf_export.xsp'"/>

		<xsl:choose>
			<xsl:when test="count($value) &gt; 1">
				<fo:list-block provisional-distance-between-starts="18pt"
					   provisional-label-separation="3pt">	
					<xsl:for-each select="$value">
						<xsl:variable name="url" select="concat($rootUrl,'query_',$base,'?hpp=-1&amp;f=sdxdocid&amp;v=',.)"/>
						<xsl:variable name="relation" select="document($url)/sdx:document/sdx:results/sdx:result[1]"/>
						<xsl:variable name="label" select="$relation/sdx:field[@name=$titlefield]"/>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>&#x2022;</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
							<fo:block>
							<xsl:call-template name="display-relation-pdf">
								<xsl:with-param name="relation" select="$relation"/>
								<xsl:with-param name="docurl" select="concat($linkuri,'?db=',$base,'&amp;id=',.,'&amp;app=',$application)"/>
								<xsl:with-param name="base" select="$dbId"/>
								<xsl:with-param name="field" select="$field"/>
								<xsl:with-param name="titlefield" select="$titlefield"/>
							</xsl:call-template>
							</fo:block>
							</fo:list-item-body>
						</fo:list-item>       
					</xsl:for-each>
				</fo:list-block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="url" select="concat($rootUrl,'query_',$base,'?hpp=-1&amp;f=sdxdocid&amp;v=',$value)"/>
				<xsl:variable name="relation" select="document($url)/sdx:document/sdx:results/sdx:result[1]"/>
				<xsl:variable name="label" select="$relation/sdx:field[@name=$titlefield]"/>
				<fo:block space-before.optimum="15pt">
					<xsl:value-of select="$docType/field[@name=$field]"/>&#160;
					<xsl:call-template name="display-relation-pdf">
						<xsl:with-param name="relation" select="$relation"/>
						<xsl:with-param name="docurl" select="concat($linkuri,'?db=',$base,'&amp;id=',$value,'&amp;app=',$application)"/>
						<xsl:with-param name="base" select="$dbId"/>
						<xsl:with-param name="field" select="$field"/>
						<xsl:with-param name="titlefield" select="$titlefield"/>
					</xsl:call-template>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="relation2">
		<xsl:param name="value"/>
		<xsl:param name="field"/>
		<xsl:param name="base"/>
		<xsl:param name="application"/>

		<xsl:variable name="titlefield" select="$titlefields/dbase[@id=$base]"/>
		<xsl:variable name="linkuri" select="'pdf_export.xsp'"/>

		<xsl:variable name="url" select="concat($rootUrl,'query_',$base,'?hpp=-1&amp;f=sdxdocid&amp;v=',$value)"/>
		<xsl:variable name="relation" select="document($url)/sdx:document/sdx:results/sdx:result[1]"/>
		<xsl:variable name="label" select="$relation/sdx:field[@name=$titlefield]"/>
		<xsl:call-template name="display-relation-pdf">
			<xsl:with-param name="relation" select="$relation"/>
			<xsl:with-param name="docurl" select="concat($linkuri,'?db=',$base,'&amp;id=',$value,'&amp;app=',$application)"/>
			<xsl:with-param name="base" select="$dbId"/>
			<xsl:with-param name="field" select="$field"/>
			<xsl:with-param name="titlefield" select="$titlefield"/>
		</xsl:call-template>
	</xsl:template>

	<!-- relation inverse -->
	<xsl:template name="reverse">
		<xsl:param name="db"/>
		<xsl:param name="field"/>
		<xsl:param name="application"/>

		<xsl:variable name="label" select="$docType/vfield[@doc=$db and @field=$field]/one"/>
		<xsl:variable name="labels" select="$docType/vfield[@doc=$db and @field=$field]/more"/>
		<xsl:variable name="titlefield" select="$titlefields/dbase[@id=$db]"/>
		<xsl:variable name="linkuri" select="'pdf_export.xsp'"/>
		<xsl:variable name="url" select="concat($rootUrl,'query_',$db,'?hpp=-1&amp;f=',$field,'&amp;v=',$docId)"/>
		<xsl:variable name="related" select="document($url)/sdx:document/sdx:results"/>
		
		<xsl:call-template name="display-reverse-pdf">
			<xsl:with-param name="db" select="$db"/>
			<xsl:with-param name="application" select="$application"/>
			<xsl:with-param name="related" select="$related"/>
			<xsl:with-param name="label" select="$label"/>
			<xsl:with-param name="labels" select="$labels"/>
			<xsl:with-param name="titlefield" select="$titlefield"/>
			<xsl:with-param name="linkuri" select="$linkuri"/>
		</xsl:call-template>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- Texte libre -->
	<xsl:template name="text">
		<xsl:param name="field"/>
		<xsl:param name="value"/>

		<xsl:for-each select="$value">
			<fo:block>
				<xsl:apply-templates select="." mode="pdf"/>
			</fo:block>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="text2">
		<xsl:param name="field"/>
		<xsl:param name="value"/>

		<xsl:apply-templates select="$value" mode="pdf"/>
	</xsl:template>

	<!-- document attaché -->
	<xsl:template name="attach">
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:param name="base"/>
		<xsl:param name="application"/>
		<xsl:param name="mode"/>

		<!-- L'url du thumbnail -->
		<xsl:variable name="thnurl" select="concat('attached_file?app=',$application,'&amp;base=',$dbId,'&amp;id=',$value/@thn,'&amp;doc=',$docId)"/>

		<!-- L'url du document attaché -->
		<xsl:variable name="imgurl" select="concat('attached_file?app=',$application,'&amp;base=',$dbId,'&amp;id=',$value,'&amp;doc=',$docId)"/>

		<!-- Taille de la vignette -->
		<xsl:variable name="thnsize">
			<xsl:choose>
				<xsl:when test="$conf_disp/documenttypes/documenttype[@id=$dbId]/document/on[@field=$field and @thnsize]">
					<xsl:value-of select="$conf_disp/documenttypes/documenttype[@id=$dbId]/document/on[@field=$field]/@thnsize"/>
				</xsl:when>
				<xsl:otherwise>150x150</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- S'il y a un thumbnail -->
		<xsl:if test="$mode='link'">
			<fo:block>
			<xsl:choose>
				<xsl:when test="$value/@thn">
					<fo:external-graphic src="url({$thnurl})"/>
				</xsl:when>
				<xsl:otherwise>
					<fo:external-graphic src="url({$rootUrl}thumbnail?app={$application}&amp;base={$dbId}&amp;id={$value}&amp;size={$thnsize})"/>
				</xsl:otherwise>
			</xsl:choose>
			</fo:block>
		</xsl:if>

		<!-- Le label -->
   		<fo:block font-size="8pt" 
               	font-family="sans-serif" 
				line-height="15pt"
               	space-after.optimum="3pt">

			<!-- S'il y a un label -->
			<xsl:if test="$value/@label">
				&#160;<xsl:value-of select="$value/@label"/>
			</xsl:if>

			<!-- S'il y a un thumbnail -->
			<xsl:if test="$value/@thn and $mode='link'">
				&#160;(<xsl:choose>
					<xsl:when test="contains($value/@thn,'/')">
						<xsl:value-of select="substring-after($value/@thn,'/')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$value/@thn"/>
					</xsl:otherwise>
				</xsl:choose>)
			</xsl:if>

			<!-- S'il y a un fichier attaché -->
			<xsl:if test="$value != ''">
				<xsl:choose>
					<xsl:when test="$mode='link'">
						<fo:basic-link external-destination="{$imgurl}"
							   text-decoration="none"
							   color="blue">
						<xsl:choose>
							<xsl:when test="contains($value,'/')">
								<xsl:value-of select="substring-after($value,'/')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$value"/>
							</xsl:otherwise>
						</xsl:choose>	
						</fo:basic-link>	
					</xsl:when>
					<xsl:when test="$mode='inline'">
						<fo:block>
							<fo:external-graphic src="url({$imgurl})"/>
						</fo:block>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</fo:block>
	</xsl:template>

	<xsl:template name="attach2">
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:param name="base"/>
		<xsl:param name="application"/>
		<xsl:param name="mode"/>

		<!-- L'url du thumbnail -->
		<xsl:variable name="thnurl" select="concat('attached_file?app=',$application,'&amp;base=',$dbId,'&amp;id=',$value/@thn,'&amp;doc=',$docId)"/>

		<!-- L'url du document attaché -->
		<xsl:variable name="imgurl" select="concat('attached_file?app=',$application,'&amp;base=',$dbId,'&amp;id=',$value,'&amp;doc=',$docId)"/>

		<!-- Taille de la vignette -->
		<xsl:variable name="thnsize">
			<xsl:choose>
				<xsl:when test="$conf_disp/documenttypes/documenttype[@id=$dbId]/document/on[@field=$field and @thnsize]">
					<xsl:value-of select="$conf_disp/documenttypes/documenttype[@id=$dbId]/document/on[@field=$field]/@thnsize"/>
				</xsl:when>
				<xsl:otherwise>150x150</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- S'il y a un thumbnail -->
		<xsl:choose>
			<xsl:when test="$mode='link'">
				<xsl:choose>
					<xsl:when test="$value/@thn">
						<fo:external-graphic src="url({$thnurl})"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:external-graphic src="url({$rootUrl}thumbnail?app={$application}&amp;base={$dbId}&amp;id={urle:encode(string(string($value)),'UTF-8')}&amp;size={$thnsize})"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$mode='inline'">
				<fo:external-graphic src="url({$imgurl})"/>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$value!=''">
				<fo:block>
				<fo:basic-link external-destination="{$imgurl}"
				   text-decoration="none" color="blue">
					<xsl:choose>
						<xsl:when test="contains($value,'/')">
							<xsl:value-of select="substring-after($value,'/')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value"/>
						</xsl:otherwise>
					</xsl:choose>	
				</fo:basic-link>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>&#160;</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
