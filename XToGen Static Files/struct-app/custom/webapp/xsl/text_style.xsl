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
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	exclude-result-prefixes="xsl fo sdx">

	<!-- formattage du texte libre en mode html -->
	<!-- template permettant de formater directement des fragments d'html -->
	<xsl:template match="abbr|acronym|b|blockquote|br|cite|em|i|li|ol|ul|pre|q|strong|sub|sup" mode="html">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="html"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="sdx:hilite" mode="html"><span class="hilite"><xsl:value-of select="."/></span></xsl:template>

	<!-- formattage du texte libre en mode pdf -->
	<xsl:template match="b|strong" mode="pdf">
		<fo:inline font-weight="bold">
			<xsl:apply-templates mode="pdf"/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="i|em" mode="pdf">
		<fo:inline font-style="italic">
			<xsl:apply-templates mode="pdf"/>
		</fo:inline>
	</xsl:template>
	<xsl:template match="blockquote" mode="pdf">
	  <fo:block start-indent="1.5cm" end-indent="1.5cm">
		<xsl:apply-templates mode="pdf"/>
	  </fo:block>
	</xsl:template>
	<xsl:template match="br" mode="pdf">
	  <fo:block> </fo:block>
	</xsl:template>
	<xsl:template match="cite" mode="pdf">
	  <xsl:choose>
		<xsl:when test="parent::i">
		  <fo:inline font-style="normal">
			<xsl:apply-templates mode="pdf"/>
		  </fo:inline>
		</xsl:when>
		<xsl:otherwise>
		  <fo:inline font-style="italic">
			<xsl:apply-templates mode="pdf"/>
		  </fo:inline>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:template>
		
	<xsl:template match="ol" mode="pdf">
	  <fo:list-block provisional-distance-between-starts="0.5cm"
		provisional-label-separation="0.5cm">
		<xsl:attribute name="space-after">
		  <xsl:choose>
			<xsl:when test="ancestor::ul or ancestor::ol">
			  <xsl:text>0pt</xsl:text>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:text>12pt</xsl:text>
			  </xsl:otherwise>
		  </xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="start-indent">
		  <xsl:variable name="ancestors">
			<xsl:choose>
			  <xsl:when test="count(ancestor::ol) or count(ancestor::ul)">
				<xsl:value-of select="1 + 
									  (count(ancestor::ol) + 
									   count(ancestor::ul)) * 
									  1.25"/>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:text>1</xsl:text>
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:variable>
		  <xsl:value-of select="concat($ancestors, 'cm')"/>
		</xsl:attribute>
		<xsl:apply-templates mode="pdf"/>
	  </fo:list-block>
	</xsl:template>

	<xsl:template match="ol/li" mode="pdf">
	  <fo:list-item>
		<fo:list-item-label end-indent="label-end()">
		  <fo:block>
			<xsl:variable name="value-attr">
			  <xsl:choose>
				<xsl:when test="../@start">
				  <xsl:number value="position() + ../@start - 1"/>
				</xsl:when>
				<xsl:otherwise>
				  <xsl:number value="position()"/>
				</xsl:otherwise>
			  </xsl:choose>
			</xsl:variable>
			<xsl:choose>
			  <xsl:when test="../@type='i'">
				<xsl:number value="$value-attr" format="i. "/>
			  </xsl:when>
			  <xsl:when test="../@type='I'">
				<xsl:number value="$value-attr" format="I. "/>
			  </xsl:when>
			  <xsl:when test="../@type='a'">
				<xsl:number value="$value-attr" format="a. "/>
			  </xsl:when>
			  <xsl:when test="../@type='A'">
				<xsl:number value="$value-attr" format="A. "/>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:number value="$value-attr" format="1. "/>
			  </xsl:otherwise>
			</xsl:choose>
		  </fo:block>
		</fo:list-item-label>
		<fo:list-item-body start-indent="body-start()">
		  <fo:block>
			<xsl:apply-templates mode="pdf"/>
		  </fo:block>
		</fo:list-item-body>
	  </fo:list-item>
	</xsl:template>
		
	<xsl:template match="p" mode="pdf">
	  <fo:block font-size="12pt" line-height="15pt" space-after="12pt">
		<xsl:apply-templates mode="pdf"/>
	  </fo:block>
	</xsl:template>

	<xsl:template match="pre" mode="pdf">
	  <fo:block font-family="monospace" white-space-collapse="false" wrap-option="no-wrap">
		<xsl:apply-templates mode="pdf"/>
	  </fo:block>
	</xsl:template>
	
	<xsl:template match="sub" mode="pdf">
	  <fo:inline vertical-align="sub" font-size="75%">
		<xsl:apply-templates mode="pdf"/>
	  </fo:inline>
	</xsl:template>

	<xsl:template match="sup" mode="pdf">
	  <fo:inline vertical-align="super" font-size="75%">
		<xsl:apply-templates mode="pdf"/>
	  </fo:inline>
	</xsl:template>
	
	<xsl:template match="ul" mode="pdf">
	  <fo:list-block provisional-distance-between-starts="0.5cm"
		provisional-label-separation="0.5cm">
		<xsl:attribute name="space-after">
		  <xsl:choose>
			<xsl:when test="ancestor::ul or ancestor::ol">
			  <xsl:text>0pt</xsl:text>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:text>12pt</xsl:text>
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="start-indent">
		  <xsl:variable name="ancestors">
			<xsl:choose>
			  <xsl:when test="count(ancestor::ol) or count(ancestor::ul)">
				<xsl:value-of select="1 + 
									  (count(ancestor::ol) + 
									   count(ancestor::ul)) * 
									  1.25"/>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:text>1</xsl:text>
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:variable>
		  <xsl:value-of select="concat($ancestors, 'cm')"/>
		</xsl:attribute>
		<xsl:apply-templates mode="pdf"/>
	  </fo:list-block>
	</xsl:template>

	<xsl:template match="ul/li" mode="pdf">
	  <fo:list-item>
		<fo:list-item-label end-indent="label-end()">
		  <fo:block>&#x2022;</fo:block>
		</fo:list-item-label>
		<fo:list-item-body start-indent="body-start()">
		  <fo:block>
			<xsl:apply-templates mode="pdf"/>
		  </fo:block>
		</fo:list-item-body>
	  </fo:list-item>
	</xsl:template>
	
</xsl:stylesheet>
