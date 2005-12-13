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

<xsl:include href="vars.xsl"/>

<xsl:template match="frame">
<html>
	<head>
		<title><xsl:value-of select="$urlparameter[@name='label']/@value"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	</head>

<xsl:variable name="urlparams" select="concat('app=',$urlparameter[@name='app']/@value,'&amp;base=',$urlparameter[@name='db']/@value,'&amp;db=',$urlparameter[@name='db']/@value,'&amp;id=',$urlparameter[@name='id']/@value,'&amp;doc=',$urlparameter[@name='doc']/@value)"/>
<xsl:variable name="queryparams" select="concat('qid=',$urlparameter[@name='qid']/@value,'&amp;q=',$urlparameter[@name='q']/@value,'&amp;n=',$urlparameter[@name='n']/@value)"/>
<xsl:variable name="docurl" select="concat('attached_file?',$urlparams)"/>

<frameset rows="40,*" frameborder="no" border="0" framespacing="0">
	<frame src="header.xsp?{$urlparams}&amp;{$queryparams}" name="header" scrolling="No" noresize="noresize" id="header" />
	<frame src="{$docurl}" name="attach" id="attach" />
</frameset>
<noframes><body>
Your browser doesn't support frames.
<a class="nav" href="{$docurl}">Click here to see the document.</a> 
</body></noframes>
</html>	
</xsl:template>
</xsl:stylesheet>
