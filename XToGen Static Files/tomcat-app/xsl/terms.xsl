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
    <xsl:param name="letter" select="substring($urlparameter[@name='v']/@value, 1, 1)"/>
    <xsl:template match="*[1]" mode="onload">
        <xsl:if test="$letter">document.forms['letter'].v.focus();</xsl:if>
    </xsl:template>

    <!-- list of terms -->
    <xsl:template match="sdx:terms">
		<xsl:variable name="dbId" select="../@id"/>
        <xsl:choose>
            <xsl:when test="$urlparameter[@name='f'][@value='xtgpleintexte']
        or sdx:term[@field='xtgpleintexte']
        ">
				<xsl:variable name="terms" select="/sdx:document/doctype/sdx:terms"/>
				<xsl:if test="@id = $terms[1]/@id">
                	<form action="{//sdx:document/@url}" name="letter">
						<h2><xsl:value-of select="$messages[@id='page.terms.index']"/> 
						<input type="hidden" name="hpp" value="100"/>
							<input type="hidden" name="f" value="plein-texte"/>
							<select name="v" onchange="this.form.submit()">
								<xsl:apply-templates select="document('')/xsl:stylesheet/sdx:select/option"/>
							</select>
							<input style="font-size:60%; font-weight:900" type="submit" value=">"/>
						</h2>
					</form>
				</xsl:if>
				<h3><xsl:value-of select="$labels/doctype[@name=$dbId]/label"/></h3>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
				<h2><xsl:value-of select="$labels/doctype[@name=$dbId]/label"/></h2>
                <ol>
                    <xsl:apply-templates/>
                </ol>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(sdx:term)">
			<xsl:value-of select="$messages[@id='page.terms.aucunereponse']"/>
		</xsl:if>
        <xsl:apply-templates select="." mode="hpp"/>
		<br/>
		<!--
		<xsl:if test="@id != ../sdx:terms[last()]/@id">
			<hr width="50%" align="left"/>
		</xsl:if>
		-->
    </xsl:template>
	
    <!-- terms indexed from plain text field -->
    <xsl:template match="sdx:term[@field='xtgpleintexte']">
        <xsl:choose>
            <xsl:when test="@docId">
                <a class="nav" href="document.xsp?id={@docId}&amp;db={@base}&amp;app={@app}&amp;qid={../@id}&amp;p={../@currentPage}">
                    <xsl:value-of select="@value"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a class="nav" href="results.xsp?q={@escapedValue}">
                    <xsl:value-of select="@value"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
		(<xsl:value-of select="@docFreq"/>)
        <xsl:text> - </xsl:text>
    </xsl:template>
	
    <!-- generic term matching -->
    <xsl:template match="sdx:term">
        <li>
            <xsl:choose>
                <xsl:when test="@docId">
                    <a class="nav" href="document.xsp?id={@docId}&amp;db={@base}&amp;app={@app}&amp;qid={../@id}&amp;p={../@currentPage}">
                        <xsl:value-of select="@value"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a class="nav" href="results.xsp?v={@escapedValue}&amp;f=titre">
                        <xsl:value-of select="@value"/>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <!-- used to iterate on the list below -->
    <xsl:template match="option">
        <option value="{.}*">
            <xsl:if test=". = $letter">
                <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
        </option>
    </xsl:template>
    <sdx:select>
        <option>a</option>
        <option>b</option>
        <option>c</option>
        <option>d</option>
        <option>e</option>
        <option>f</option>
        <option>g</option>
        <option>h</option>
        <option>i</option>
        <option>j</option>
        <option>k</option>
        <option>l</option>
        <option>m</option>
        <option>n</option>
        <option>o</option>
        <option>p</option>
        <option>q</option>
        <option>r</option>
        <option>s</option>
        <option>t</option>
        <option>u</option>
        <option>v</option>
        <option>w</option>
        <option>x</option>
        <option>y</option>
        <option>z</option>
    </sdx:select>
</xsl:stylesheet>
