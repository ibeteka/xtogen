<?xml version="1.0" encoding="UTF-8"?>
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
	exclude-result-prefixes="xsl sdx fo">

	<!-- Relation -->
	<xsl:template name="display-relation">
		<xsl:param name="value"/>
		<xsl:param name="field"/>
		<xsl:param name="base"/> <!-- Base du document contenant la relation -->
		<xsl:param name="application"/>
		<xsl:param name="db"/> <!-- Base du document pointé par la relation -->

		<xsl:variable name="titlefield" select="$titlefields/dbase[@id=$db]"/>
		<xsl:variable name="url" select="concat($rootUrl,'query_',$db,'?hpp=-1&amp;f=sdxdocid&amp;v=',$value)"/>
		<xsl:choose>
			<!-- Si pas de document -->
			<xsl:when test="document($url)/sdx:document/sdx:results/@nb = 0">
			<span class="erreur"><xsl:value-of select="$messages[@id='page.document.documentabsentdebut']"/><xsl:value-of select="$value"/><xsl:value-of select="$messages[@id='page.document.documentabsentfin']"/></span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="relation" select="document($url)/sdx:document/sdx:results/sdx:result[1]"/>
				<xsl:variable name="docurl" select="concat('document.xsp?db=',$db,'&amp;id=',$value,'&amp;app=',$application)"/>
				<xsl:variable name="label" select="$relation/sdx:field[@name=$titlefield]"/>
                <xsl:variable name="app" select="$relation/sdx:field[@name='sdxappid']"/>
				<a class="rel" href="document.xsp?db={$db}&amp;id={$value}&amp;app={$app}"><xsl:value-of select="$label"/></a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Relation inverse -->
	<xsl:template name="display-reverse">
		<xsl:param name="db"/>
		<xsl:param name="field"/>
		<xsl:param name="docId"/>
		<xsl:param name="application"/>
		<xsl:param name="label"/>
		<xsl:param name="labels"/>

		<xsl:variable name="titlefield" select="$titlefields/dbase[@id=$db]"/>
		<xsl:variable name="url" select="concat($rootUrl,'query_',$db,'?hpp=-1&amp;f=',$field,'&amp;v=',$docId)"/>
		<xsl:variable name="related" select="document($url)/sdx:document/sdx:results"/>
		<xsl:variable name="nb" select="number($related/@nb)"/>
		<xsl:choose>
		<xsl:when test="$nb = 1">
			<xsl:variable name="result" select="$related/sdx:result[1]"/>
			<td class="attribut"><xsl:value-of select="$label"/></td>
			<td class="valeur"><a class="rel" href="document.xsp?db={$db}&amp;id={$result/sdx:field[@name='sdxdocid']}&amp;app={$application}"><xsl:value-of select="$result/sdx:field[@name=$titlefield]"/></a></td>
		</xsl:when>
		<xsl:when test="$nb &gt; 1 and $nb &lt;= 10">
			<td valign="top" class="attribut"><xsl:value-of select="$labels"/></td>
			<td class="valeur"><ul>
			<xsl:for-each select="$related/sdx:result">
			<li>
				<a class="rel" href="document.xsp?db={$db}&amp;id={sdx:field[@name='sdxdocid']}&amp;app={$application}"><xsl:value-of select="sdx:field[@name=$titlefield]"/></a>
			</li>
			</xsl:for-each>
			</ul></td>
		</xsl:when>
		<xsl:when test="$nb &gt; 10">
			<xsl:variable name="navurl" select="concat($rootUrl,'query_',$db,'.xsp?f=',$field,'&amp;v=',$docId)"/>
			<xsl:variable name="result" select="$related/sdx:result[1]"/>
			<td class="attribut"><xsl:value-of select="$label"/></td>
			<td class="valeur"><a class="nav" href="{$navurl}"><xsl:value-of select="number($related/@nb)"/>&#160;<xsl:value-of select="$messages[@id='common.documents']"/></a></td>
		</xsl:when>
		</xsl:choose>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<xsl:template name="display-reverse2">
		<xsl:param name="db"/>
		<xsl:param name="field"/>
		<xsl:param name="docId"/>
		<xsl:param name="application"/>
		<xsl:param name="related"/>

		<xsl:variable name="titlefield" select="$titlefields/dbase[@id=$db]"/>
		<xsl:variable name="nb" select="number($related/@nb)"/>
		<xsl:choose>
		<xsl:when test="$nb = 1">
			<xsl:variable name="result" select="$related/sdx:result[1]"/>
			<a class="rel" href="document.xsp?db={$db}&amp;id={$result/sdx:field[@name='sdxdocid']}&amp;app={$application}"><xsl:value-of select="$result/sdx:field[@name=$titlefield]"/></a>
		</xsl:when>
		<xsl:when test="$nb &gt; 1 and $nb &lt;= 10">
			<ul>
				<xsl:for-each select="$related/sdx:result">
					<li>
						<a class="rel" href="document.xsp?db={$db}&amp;id={sdx:field[@name='sdxdocid']}&amp;app={$application}"><xsl:value-of select="sdx:field[@name=$titlefield]"/></a>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:when>
		<xsl:when test="$nb &gt; 10">
			<xsl:variable name="navurl" select="concat($rootUrl,'query_',$db,'.xsp?f=',$field,'&amp;v=',$docId)"/>
			<xsl:variable name="result" select="$related/sdx:result[1]"/>
			<a class="nav" href="{$navurl}"><xsl:value-of select="number($related/@nb)"/>&#160;<xsl:value-of select="$messages[@id='common.documents']"/></a>
		</xsl:when>
		</xsl:choose>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- Pour le pdf -->
	<xsl:template name="display-relation-pdf">
		<xsl:param name="relation"/>
		<xsl:param name="docurl"/>
		<xsl:param name="base"/>
		<xsl:param name="field"/>
		<xsl:param name="titlefield"/>

		<xsl:variable name="label" select="$relation/sdx:field[@name=$titlefield]/@value"/>
		<fo:basic-link external-destination="{$docurl}" text-decoration="none" color="blue">
			<xsl:value-of select="$label"/>
		</fo:basic-link>	
	</xsl:template>

	<xsl:template name="display-reverse-pdf">
		<xsl:param name="db"/>
		<xsl:param name="application"/>
		<xsl:param name="related"/>
		<xsl:param name="label"/>
		<xsl:param name="labels"/>
		<xsl:param name="titlefield"/>
		<xsl:param name="linkuri"/>

		<!-- 1 résultat -->
		<xsl:if test="number($related/@nb) = 1">
			<xsl:variable name="result" select="$related/sdx:result[1]"/>
			<fo:block space-before.optimum="15pt">
				<xsl:value-of select="$label"/>&#160;
				<fo:basic-link external-destination="{$linkuri}?db={$db}&amp;id={$result/sdx:field[@name='sdxdocid']}&amp;app={$application}"
		   text-decoration="none"
		   color="blue"><xsl:value-of select="$result/sdx:field[@name=$titlefield]"/></fo:basic-link>	
			</fo:block>
		</xsl:if>

		<!-- Plusieurs résultats -->
		<xsl:if test="number($related/@nb) &gt; 1">
			<xsl:call-template name="label2">
				<xsl:with-param name="value" select="$labels"/>
			</xsl:call-template>
			<fo:list-block provisional-distance-between-starts="18pt"
				   provisional-label-separation="3pt">	
				<xsl:for-each select="$related/sdx:result">
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>&#x2022;</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()">
						<fo:block>
						<fo:basic-link external-destination="{$linkuri}?db={$db}&amp;id={sdx:field[@name='sdxdocid']}&amp;app={$application}"
						   text-decoration="none"
						   color="blue">
							<xsl:value-of select="sdx:field[@name=$titlefield]"/>
						</fo:basic-link>	
						</fo:block>
						</fo:list-item-body>
					</fo:list-item>       
				</xsl:for-each>
			</fo:list-block>
		</xsl:if>
	</xsl:template>

	<xsl:template name="display-reverse-pdf2">
		<xsl:param name="db"/>
		<xsl:param name="application"/>
		<xsl:param name="related"/>
		<xsl:param name="titlefield"/>
		<xsl:param name="linkuri"/>

		<!-- 1 résultat -->
		<xsl:if test="number($related/@nb) = 1">
			<xsl:variable name="result" select="$related/sdx:result[1]"/>
			<fo:basic-link external-destination="{$linkuri}?db={$db}&amp;id={$result/sdx:field[@name='sdxdocid']}&amp;app={$application}"
		   		text-decoration="none" color="blue">
				<xsl:value-of select="$result/sdx:field[@name=$titlefield]"/>
			</fo:basic-link>	
		</xsl:if>

		<!-- Plusieurs résultats -->
		<xsl:if test="number($related/@nb) &gt; 1">
			<fo:list-block provisional-distance-between-starts="18pt"
				   provisional-label-separation="3pt">	
				<xsl:for-each select="$related/sdx:result">
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>&#x2022;</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()">
						<fo:block>
							<fo:basic-link external-destination="{$linkuri}?db={$db}&amp;id={sdx:field[@name='sdxdocid']/@value}&amp;app={$application}"
							   text-decoration="none" color="blue">
								<xsl:value-of select="sdx:field[@name=$titlefield]"/>
							</fo:basic-link>	
						</fo:block>
						</fo:list-item-body>
					</fo:list-item>       
				</xsl:for-each>
			</fo:list-block>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
