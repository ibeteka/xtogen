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
<xsl:variable name="dbid" select="$urlparameter[@name='db']/@value"/>

<xsl:template match="/">
	<xsl:apply-templates select="//sdx:results"/>
</xsl:template>

<xsl:template match="sdx:results">
<xsl:text/><html>
<head>
	<title><xsl:value-of select="$messages[@id='page.admin.choixdundocumentlie']"/></title>
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
	font-size: small;
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

ul {
}

li {
	width: 400px;
	float: left;
}
--&gt;
</style>
<script type="text/javascript" language="javascript">

function valider(docid,name)
{
	//alert(name);
	opener.document.forms['saisie']['<xsl:value-of select="$fid"/>'].value = docid;
	opener.document.forms['saisie']['<xsl:value-of select="$fid"/>.label'].value = name;
	self.close();
}

</script>
</head>
<body>
<h1><xsl:value-of select="$messages[@id='page.admin.choixdundocumentlie']"/></h1>

<ul>
	<xsl:apply-templates select="sdx:result"/>
</ul>

<!-- Page navigation -->
<div class="pages">
<span>
<xsl:variable name="currentpage" select="$currentpage"/>
<xsl:variable name="p" select="@currentPage"/>
<xsl:variable name="maxp" select="@nbPages"/>
<xsl:if test="$p != 1">
<a class="nav" href="{$currentpage}?p=1&amp;fid={$fid}&amp;db={$dbid}" title="{$messages[@id='common.debut']}">1</a>&#160;
</xsl:if>
<xsl:if test="$p &gt; 1">
<a class="nav" href="{$currentpage}?p={$p -1}&amp;fid={$fid}&amp;db={$dbid}" title="{$messages[@id='common.pageprecedente']}"><img src="{$iconPrev}" alt="{$messages[@id='common.pageprecedente']}"/></a>&#160;
</xsl:if>
<xsl:value-of select="$p"/>&#160;
<xsl:if test="$p &lt; $maxp">
<a class="nav" href="{$currentpage}?p={$p+1}&amp;fid={$fid}&amp;db={$dbid}" title="{$messages[@id='common.pagesuivante']}"><img src="{$iconNext}" alt="{$messages[@id='common.pagesuivante']}"/></a>&#160;
</xsl:if>
<xsl:if test="$p+1 &lt;= $maxp">
<a class="nav" href="{$currentpage}?p={$maxp}&amp;fid={$fid}&amp;db={$dbid}" title="{$messages[@id='common.fin']}"><xsl:value-of select="$maxp"/></a>
</xsl:if>
</span>
</div>

</body>
</html>	
</xsl:template>

<xsl:template match="sdx:result">
	<xsl:variable name="docid" select="sdx:field[@name='sdxdocid']/@value"/>
	<xsl:variable name="label" select="sdx:field[@name='xtgtitle']/@value"/>
	<li>
		<strong><xsl:value-of select="@no"/></strong>
		<xsl:text> </xsl:text>
		<a href="javascript:valider('{$docid}','{$label}')" onClick="valider('{$docid}','{$label}')">
			<xsl:value-of select="$label"/>
		</a>
	</li>
</xsl:template>
</xsl:stylesheet>
