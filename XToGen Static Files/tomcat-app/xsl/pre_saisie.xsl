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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx" xmlns:dir="http://apache.org/cocoon/directory/2.0" exclude-result-prefixes="sdx dir">
    <xsl:import href="common.xsl"/>

	<xsl:template match="admin">
		<xsl:variable name="base" select="$urlparameter[@name='db']/@value"/>
		<h3><xsl:value-of select="$messages[@id='page.admin.basededocument']"/>&#160;<xsl:value-of select="$base"/></h3>

		<br/>
		<a class="nav" href="admin_saisie.xsp?db={$base}"><xsl:value-of select="$messages[@id='page.saisie.saisirunnouveaudocument']"/></a><br/>
		<a class="nav" href="admin_attach.xsp?db={$base}"><xsl:value-of select="$messages[@id='page.admin.gestiondesattachements']"/></a><br/>
		<a class="nav" href="admin.xsp"><xsl:value-of select="$messages[@id='page.admin.retour']"/></a><br/>

	</xsl:template>

</xsl:stylesheet>
