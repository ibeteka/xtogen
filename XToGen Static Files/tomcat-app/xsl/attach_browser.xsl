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
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:urle="java.net.URLEncoder"
	exclude-result-prefixes="sdx urle dir">

<xsl:include href="vars.xsl"/>
<xsl:variable name="fid" select="$urlparameter[@name='fid']/@value"/>

<xsl:template match="/">
	<xsl:apply-templates select="document(concat($rootUrl,'list_attach_',$currentdoctype))/dir:directory"/>
</xsl:template>

<xsl:template match="dir:directory">
<xsl:text/><html>
<head>
	<title><xsl:value-of select="$messages[@id='page.admin.navigateurdepiecesattachees']"/></title>
<style type="text/css">
&lt;--

.foo {
}

* {
	font-family: Verdana, Tahoma;
}

body {
	background-color: #e9e9e9;
	margin-top: 40px;
}

h1 {
	position: absolute;
	top: 10px;
	left: 10px;
	font-size: 100%;
}

div.pix {
	width: 180px;
	height: 200px;
	margin: 5px;
	padding: 5px;
	background-color: #cecece;
	float: left;
	text-align: center;
}

div.pix a img {
	border-width: 0;
	padding: 8px 8px 8px 8px;
	margin: 5px;
	background-color: white;
	border: 1px solid #aeaeae;
}

a.nav img {
	border-width: 0;
}

.legend {
	font-size: 60%;
	font-weight: bolder;
}

div.pages {
	position: absolute;
	top: 10px;
	right: 10px;
}

span#sort {
	margin-right: 30px;
}

--&gt;
</style>
<script type="text/javascript" language="javascript">

function valider(name)
{
	<xsl:variable name="url" select="concat($rootUrl,'vignette?app=',$currentapp,'&amp;base=',$currentdoctype,'&amp;size=150x150&amp;name=')"/>
	//alert(name);
	opener.document.forms['saisie']['<xsl:value-of select="$fid"/>'].value = 'attach/' + name;
	opener.document.forms['saisie']['<xsl:value-of select="$fid"/>_img'].src = '<xsl:value-of select="$url"/>'+name;
	self.close();
}

</script>
</head>
<body>
<h1><xsl:value-of select="$messages[@id='page.admin.navigateurdepiecesattachees']"/></h1>
<xsl:variable name="p">
<xsl:choose>
<xsl:when test="$urlparameter[@name='p']"><xsl:value-of select="number($urlparameter[@name='p']/@value)"/></xsl:when>
<xsl:otherwise><xsl:value-of select="1"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="count" select="count(dir:file)"/>
<xsl:variable name="nbpp" select="12"/>
<xsl:variable name="maxp" select="ceiling($count div $nbpp)"/>
<xsl:variable name="first" select="($p - 1)*$nbpp"/>
<xsl:variable name="last" select="$first + $nbpp"/>
<xsl:variable name="sortfield">
	<xsl:choose>
		<xsl:when test="$urlparameter[@name='sortfield']"><xsl:value-of select="$urlparameter[@name='sortfield']/@value"/></xsl:when>
		<xsl:otherwise>lastModified</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:variable name="order">
	<xsl:choose>
		<xsl:when test="$urlparameter[@name='order']"><xsl:value-of select="$urlparameter[@name='order']/@value"/></xsl:when>
		<xsl:otherwise>descending</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:variable name="sortinfo">
	<xsl:text/>&amp;sortfield=<xsl:value-of select="$sortfield"/>&amp;order=<xsl:value-of select="$order"/>
</xsl:variable>

<xsl:choose>
	<xsl:when test="$sortfield='lastModified'">
		<xsl:for-each select="dir:file">
			<xsl:sort select="@lastModified" order="{$order}"/>
			<xsl:if test="position() &gt; $first and position() &lt;= $last">
				<xsl:apply-templates select="."/>
			</xsl:if>
		</xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
		<xsl:for-each select="dir:file">
			<xsl:sort select="@name" order="{$order}"/>
			<xsl:if test="position() &gt; $first and position() &lt;= $last">
				<xsl:apply-templates select="."/>
			</xsl:if>
		</xsl:for-each>
	</xsl:otherwise>
</xsl:choose>

<!-- Page navigation -->
<div class="pages">
<span id="sort">
<xsl:value-of select="$messages[@id='common.trierpar']"/>
<xsl:text> </xsl:text>
<xsl:variable name="currentpageuri" select="concat($currentpage,'?p=',$p,'&amp;fid=',$fid,'&amp;')"/>
<a href="{$currentpageuri}sortfield={$sortfield}&amp;order=ascending" title="{$messages[@id='common.ordreascendant']}"><img src="icones/up.png" border="0"/></a>
<xsl:text> </xsl:text>
<xsl:choose>
	<xsl:when test="$sortfield='name'">
		<xsl:value-of select="$messages[@id='common.trierparnomdefichier']"/> - <a href="{$currentpageuri}sortfield=lastModified&amp;order={$order}"><xsl:value-of select="$messages[@id='common.trierpardate']"/></a>
	</xsl:when>
	<xsl:otherwise>
		<a href="{$currentpageuri}sortfield=name&amp;order={$order}"><xsl:value-of select="$messages[@id='common.trierparnomdefichier']"/></a> - <xsl:value-of select="$messages[@id='common.trierpardate']"/>
	</xsl:otherwise>
</xsl:choose>
<xsl:text> </xsl:text>
<a href="{$currentpageuri}sortfield={$sortfield}&amp;order=descending" title="{$messages[@id='common.ordredescendant']}"><img src="icones/down.png" border="0"/></a>
</span>
<span>
<xsl:if test="$p != 1">
<a class="nav" href="{$currentpage}?p=1&amp;fid={$fid}" title="{$messages[@id='common.debut']}">1</a>&#160;
</xsl:if>
<xsl:if test="$p &gt; 1">
<a class="nav" href="{$currentpage}?p={$p -1}&amp;fid={$fid}{$sortinfo}" title="{$messages[@id='common.pageprecedente']}"><img src="{$iconPrev}" alt="{$messages[@id='common.pageprecedente']}"/></a>&#160;
</xsl:if>
<xsl:value-of select="$p"/>&#160;
<xsl:if test="$p &lt; $maxp">
<a class="nav" href="{$currentpage}?p={$p+1}&amp;fid={$fid}{$sortinfo}" title="{$messages[@id='common.pagesuivante']}"><img src="{$iconNext}" alt="{$messages[@id='common.pagesuivante']}"/></a>&#160;
</xsl:if>
<xsl:if test="$p+1 &lt;= $maxp">
<a class="nav" href="{$currentpage}?p={$maxp}&amp;fid={$fid}{$sortinfo}" title="{$messages[@id='common.fin']}"><xsl:value-of select="$maxp"/></a>
</xsl:if>
</span>
</div>
</body>
</html>	
</xsl:template>

<xsl:template match="dir:file">
	<xsl:variable name="url" select="concat($rootUrl,'/vignette?app=',$currentapp,'&amp;base=',$currentdoctype,'&amp;size=150x150&amp;name=',urle:encode(string(string(@name)),'UTF-8'))"/>
	<div class="pix">
	<a href="javascript:valider('attach/{@name}')" onClick="valider('{@name}')">
	<img class="diapo" alt="{@name}" src="{$url}" title="{@name}"/>
	</a><br/>
	<span class="legend"><xsl:value-of select="@name"/></span>
	</div>
</xsl:template>
</xsl:stylesheet>
