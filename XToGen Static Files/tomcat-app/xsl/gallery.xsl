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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx" exclude-result-prefixes="sdx">
    <xsl:import href="common.xsl"/>

	<xsl:template match="documentbase"/>

    <xsl:template match="sdx:terms">
	<xsl:variable name="dbId" select="/sdx:document/documentbase/@id"/>
	<xsl:variable name="field" select="$urlparameter[@name='field']/@value"/>
	<xsl:variable name="thnsize">
		<xsl:choose>
			<xsl:when test="$conf_disp/documenttypes/documenttype[@id=$dbId]/nav/on[@field=$field and @thnsize]">
				<xsl:value-of select="$conf_disp/documenttypes/documenttype[@id=$dbId]/nav/on[@field=$field]/@thnsize"/>
			</xsl:when>
			<xsl:otherwise>125x125</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="mode">
		<xsl:choose>
			<xsl:when test="$urlparameter[@name='mode']"><xsl:value-of select="$urlparameter[@name='mode']/@value"/></xsl:when>
			<xsl:otherwise>link</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
    <h2><xsl:value-of select="$messages[@id='bouton.navigation']"/></h2>
	<xsl:if test="@nb != 0">
        <xsl:apply-templates select="." mode="hpp"/>
	</xsl:if>
    <h3><xsl:value-of select="$labels/doctype[@name=$dbId]/nav[@field=$field]/title"/></h3>
        <xsl:choose>
            <xsl:when test="@nb = 0">
                <p>
                    <b><xsl:value-of select="$messages[@id='page.results.aucuneimage']"/></b>
                </p>
            </xsl:when>
            <xsl:otherwise>
				<div class="galerie">
					<div class="spacer">&#160;</div>
					<xsl:for-each select="sdx:term">
						<div class="vignettegalerie">
							<xsl:call-template name="miniature">
								<xsl:with-param name="dbId" select="$dbId"/>
								<xsl:with-param name="mode" select="$mode"/>
								<xsl:with-param name="thnsize" select="$thnsize"/>
							</xsl:call-template>
						</div>
					</xsl:for-each>
					<div class="spacer">&#160;</div>
				</div>
				<br/>
				<xsl:if test="@pages != '1'">
					<hr noshade="noshade" size="1"/>
				</xsl:if>
        		<xsl:apply-templates select="." mode="hpp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<!-- Affichage de la vignette -->
    <xsl:template name="miniature">
		<xsl:param name="dbId"/>
		<xsl:param name="mode"/>
		<xsl:param name="thnsize"/>

		<xsl:variable name="thn" select="substring-before(@value,'||')"/>
		<xsl:variable name="rest" select="substring-after(@value,'||')"/>
		<xsl:variable name="alt" select="substring-before($rest,'||')"/>
		<xsl:variable name="img" select="substring-after($rest,'||')"/>
		<xsl:variable name="app">
			<xsl:choose>
				<xsl:when test="@app"><xsl:value-of select="@app"/></xsl:when>
				<xsl:when test="count(/sdx:document/documentbase/app) != 0"><xsl:value-of select="/sdx:document/documentbase/app[1]"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="/sdx:document/@app"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Vignette -->
		<xsl:variable name="vignette">
			<xsl:choose>
				<xsl:when test="$mode='inline'"><xsl:value-of select="concat('attached_file?app=',$app,'&amp;base=',$dbId,'&amp;id=',$img)"/></xsl:when>
				<xsl:otherwise>
					<xsl:variable name="field" select="$urlparameter[@name='field']/@value"/>
					<xsl:variable name="dt" select="$conf_disp/documenttypes/documenttype[@id=$dbId]"/>
					<xsl:choose>
						<xsl:when test="$thn!='' and not($dt/nav/on[@field=$field and @thnsize])">
							<xsl:value-of select="concat('attached_file?app=',$app,'&amp;base=',$dbId,'&amp;id=',$thn)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($rootUrl,'thumbnail?app=',$app,'&amp;base=',$dbId,'&amp;id=',$img,'&amp;size=',$thnsize)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Le label de la vignette -->
		<xsl:variable name="imglabel">
			<xsl:choose>
				<xsl:when test="@docId"><xsl:if test="$alt != ''"><xsl:value-of select="$alt"/>&#160;</xsl:if><xsl:if test="$img!=''">(<xsl:value-of select="$img"/>)</xsl:if></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@docs"/>&#160;<xsl:value-of select="$messages[@id='common.document_s']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Gestion du lien -->
		<xsl:element name="a">
			<xsl:choose>
				<xsl:when test="@docId">
					<xsl:attribute name="href"><xsl:value-of select="concat('document.xsp?id=',@docId,'&amp;db=',$dbId,'&amp;app=',$app,'&amp;qid=',../@id,'&amp;p=',../@currentPage)"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="href"><xsl:value-of select="concat('query_',$dbId,'.xsp?type=attach&amp;f=',@field,'&amp;v=',@escapedValue)"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:attribute name="title"><xsl:value-of select="$imglabel"/></xsl:attribute>

			<!-- Et de l'image -->
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$vignette"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:value-of select="$imglabel"/></xsl:attribute>
			</xsl:element>
		</xsl:element>
    </xsl:template>

    <xsl:template match="sdx:query"/>
</xsl:stylesheet>
