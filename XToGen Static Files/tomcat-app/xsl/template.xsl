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
	xmlns:xtg="http://xtogen.tech.fr"
	exclude-result-prefixes="xsl sdx xtg">

	<!-- Gestion de la direction -->
	<xsl:template match="html" mode="xhtml">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='dir']"/>
			<xsl:choose>
				<!-- On recopie l'attribut dir s'il existe -->
				<xsl:when test="@dir"><xsl:attribute name="dir"><xsl:value-of select="@dir"/></xsl:attribute></xsl:when>
				<!-- On le positionne si la direction de la langue n'est pas "standard" -->
				<xsl:when test="$langDirection!='ltr'"><xsl:attribute name="dir"><xsl:value-of select="$langDirection"/></xsl:attribute></xsl:when>
			</xsl:choose>
			
			<xsl:apply-templates select="node()" mode="xhtml"/>
		</xsl:copy>
	</xsl:template>

	<!-- Head -->
	<xsl:template match="head" mode="xhtml">
		<xsl:copy>
			<meta name="GENERATOR" content="XToGen version {$xtogenVersion} (http://xtogen.tech.fr)"/>
			<meta name="language" content="{$lang}"/>
			<xsl:apply-templates select="$sdxdocument/child::*" mode="meta"/>
			<title><xsl:call-template name="display-title"/></title>
			<xsl:apply-templates select="node()" mode="xhtml"/>
			<xsl:apply-templates select="$sdxdocument/child::*" mode="head"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="meta[@http-equiv='Content-Type']" mode="xhtml"/>
	<xsl:template match="title" mode="xhtml"/>

	<!-- Barre de langue -->
	<xsl:template match="*[@id='xtg-lang-bar']" mode="xhtml">
		<xsl:choose>
			<xsl:when test="count($langs/lang[@label]) &lt; 2"/>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*[name()!='id']" mode="xhtml"/>
					<xsl:apply-templates select="node()" mode="xhtml"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[@id='xtg-lang-item-selected' or @id='xtg-lang-item-notselected']" mode="xhtml"/>

	<xsl:template match="child::node() | attribute::*" mode="xhtml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xhtml"/>
			<xsl:apply-templates select="node()" mode="xhtml"/>
		</xsl:copy>
	</xsl:template>

	<!-- Formulaire de recherche -->
	<xsl:template match="input[@id='xtg-search-input']" mode="xhtml">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id' and name()!='value']"/>

			<xsl:attribute name="value"><xsl:value-of select="$urlparameter[@name='q']/@value"/></xsl:attribute>
		</xsl:copy>
	</xsl:template>

	<!-- LANGUES -->
	<xsl:template match="select[@id='xtg-lang-combo']" mode="xhtml">
		<xsl:variable name="node" select="."/>
		<xsl:choose>
			<xsl:when test="count($langs/lang[@label]) &gt; 1">
				<select>
					<xsl:copy-of select="@*[name()!='id']"/>
					<xsl:for-each select="$langs/lang[@label]">
						<option value="{@id}">
							<xsl:if test="@id=$lang">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="@label"/>
						</option>
					</xsl:for-each>
				</select>
			</xsl:when>
			<xsl:otherwise>
				<input type="hidden" name="qlang" value="{$lang}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[@id='xtg-lang-item']" mode="xhtml">
		<xsl:variable name="node" select="."/>
		<xsl:for-each select="$langs/lang[@label]">
			<xsl:if test="position()!=1 and $node[@name]">
				<xsl:value-of select="$node/@name"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@id = $lang">
					<xsl:apply-templates select="$node/following::*[@id='xtg-lang-item-selected']" mode="xhtml-lang">
						<xsl:with-param name="langid" select="@id"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$node/following::*[@id='xtg-lang-item-notselected']" mode="xhtml-lang">
						<xsl:with-param name="langid" select="@id"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[@id='xtg-lang-item-selected' or @id='xtg-lang-item-notselected']" mode="xhtml-lang">
		<xsl:param name="langid"/>
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-lang">
				<xsl:with-param name="langid" select="$langid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[@id='xtg-lang-label']" mode="xhtml-lang">
		<xsl:param name="langid"/>
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:value-of select="$langs/lang[@id=$langid]/@label"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[@id='xtg-lang-link']" mode="xhtml-lang">
		<xsl:param name="langid"/>
		<xsl:copy>
			<xsl:attribute name="href"><xsl:value-of select="concat($langprefixuri,$langid)"/></xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="$langs/lang[@id=$langid]/@label"/></xsl:attribute>
			<xsl:copy-of select="@*[name()!='href' and name()!='title' and name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-lang">
				<xsl:with-param name="langid" select="$langid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[@id='xtg-lang-image']" mode="xhtml-lang">
		<xsl:param name="langid"/>
		<xsl:copy>
			<xsl:attribute name="src">icones/flag_<xsl:value-of select="$langid"/>.png</xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="$langs/lang[@id=$langid]/@label"/></xsl:attribute>
			<xsl:copy-of select="@*[name()!='src' and name()!='title' and name()!='id']"/>
			<xsl:apply-templates select="* | comment() | processing-instruction() | text()" mode="xhtml-lang">
				<xsl:with-param name="langid" select="$langid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="child::node() | attribute::*" mode="xhtml-lang">
		<xsl:param name="langid"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xhtml-lang"/>
			<xsl:apply-templates select="node()" mode="xhtml-lang">
				<xsl:with-param name="langid" select="$langid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<!-- Navigation -->
	<xsl:template match="*[@id='xtg-nav-index']" mode="xhtml">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="'index'"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[@id='xtg-nav-nav']" mode="xhtml">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="'nav'"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[starts-with(@id, 'xtg-nav-nav-')]" mode="xhtml">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="substring-after(@id,'xtg-nav-')"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*[starts-with(@id, 'xtg-nav-nav-')]" mode="xhtml-nav">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="substring-after(@id,'xtg-nav-')"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[@id='xtg-nav-search']" mode="xhtml">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="'search'"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[starts-with(@id, 'xtg-nav-search-')]" mode="xhtml">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="substring-after(@id,'xtg-nav-')"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[starts-with(@id, 'xtg-nav-search-')]" mode="xhtml-nav">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="substring-after(@id,'xtg-nav-')"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="*[starts-with(@id, 'xtg-nav-static-')]" mode="xhtml">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="substring-after(@id,'xtg-nav-')"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[@id='xtg-nav-login']" mode="xhtml">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="'login'"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[@id='xtg-nav-admin']" mode="xhtml">
		<xsl:choose>
			<xsl:when test="$admin">
				<xsl:copy>
					<xsl:copy-of select="@*[name()!='id']"/>
					<xsl:apply-templates select="node()" mode="xhtml-nav">
						<xsl:with-param name="navid" select="'admin'"/>
					</xsl:apply-templates>
				</xsl:copy>
			</xsl:when>
			<xsl:when test="$currentuser/sdx:group[@id='saisie'] and $currentuser/@app=$currentapp">
				<xsl:copy>
					<xsl:copy-of select="@*[name()!='id']"/>
					<xsl:apply-templates select="node()" mode="xhtml-nav">
						<xsl:with-param name="navid" select="'edit'"/>
					</xsl:apply-templates>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[@id='xtg-nav-link']" mode="xhtml-nav">
		<xsl:param name="navid"/>

		<xsl:variable name="tooltipid">
		</xsl:variable>
		<xsl:copy>
			<xsl:attribute name="href"><xsl:call-template name="link-nav"><xsl:with-param name="navid" select="$navid"/></xsl:call-template></xsl:attribute>
			<xsl:attribute name="title"><xsl:call-template name="link-tooltip"><xsl:with-param name="navid" select="$navid"/></xsl:call-template></xsl:attribute>	
			<xsl:copy-of select="@*[name()!='href' and name()!='title' and name()!='id']"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="$navid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[@id='xtg-nav-label']" mode="xhtml-nav">
		<xsl:param name="navid"/>

		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:call-template name="link-label">
				<xsl:with-param name="navid" select="$navid"/>
			</xsl:call-template>	
		</xsl:copy>
	</xsl:template>

	<xsl:template match="child::node() | attribute::*" mode="xhtml-nav">
		<xsl:param name="navid"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xhtml-nav"/>
			<xsl:apply-templates select="node()" mode="xhtml-nav">
				<xsl:with-param name="navid" select="$navid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="link-nav">
		<xsl:param name="navid"/>

		<xsl:choose>
			<xsl:when test="$navid='index'">index.xsp</xsl:when>
			<xsl:when test="$navid='nav'">nav.xsp</xsl:when>
			<xsl:when test="$navid='search'">search.xsp</xsl:when>
			<xsl:when test="$navid='login'">login.xsp</xsl:when>
			<xsl:when test="$navid='admin'">admin.xsp</xsl:when>
			<xsl:when test="$navid='edit'">admin.xsp</xsl:when>
			<xsl:when test="starts-with($navid,'nav-')">nav.xsp?db=<xsl:value-of select="substring-after($navid,'nav-')"/></xsl:when>
			<xsl:when test="starts-with($navid,'search-')">search.xsp?db=<xsl:value-of select="substring-after($navid,'search-')"/></xsl:when>
			<xsl:when test="starts-with($navid,'static-')">static.xsp?page=<xsl:value-of select="substring-after($navid,'static-')"/></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="link-label">
		<xsl:param name="navid"/>

		<xsl:choose>
			<xsl:when test="$navid='index'"><xsl:value-of select="$messages[@id='bouton.accueil']"/></xsl:when>
			<xsl:when test="$navid='nav'"><xsl:value-of select="$messages[@id='bouton.navigation']"/></xsl:when>
			<xsl:when test="$navid='search'"><xsl:value-of select="$messages[@id='bouton.recherche']"/></xsl:when>
			<xsl:when test="$navid='login'"><xsl:value-of select="$messages[@id='bouton.identification']"/></xsl:when>
			<xsl:when test="$navid='admin'"><xsl:value-of select="$messages[@id='bouton.administration']"/></xsl:when>
			<xsl:when test="$navid='edit'"><xsl:value-of select="$messages[@id='bouton.saisie']"/></xsl:when>
			<xsl:when test="starts-with($navid,'nav-')"><xsl:value-of select="$labels/doctype[@name=substring-after($navid,'nav-')]/label"/></xsl:when>
			<xsl:when test="starts-with($navid,'search-')"><xsl:value-of select="$labels/doctype[@name=substring-after($navid,'search-')]/label"/></xsl:when>
			<xsl:when test="starts-with($navid,'static-')"><xsl:value-of select="$displaylabels/label[@id=concat('static.bouton.',substring-after($navid,'static-'))]"/></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="link-tooltip">
		<xsl:param name="navid"/>

		<xsl:choose>
			<xsl:when test="$navid='index'"><xsl:value-of select="$messages[@id='tooltip.accueil']"/></xsl:when>
			<xsl:when test="$navid='nav'"><xsl:value-of select="$messages[@id='tooltip.navigation']"/></xsl:when>
			<xsl:when test="$navid='search'"><xsl:value-of select="$messages[@id='tooltip.recherche']"/></xsl:when>
			<xsl:when test="$navid='login'"><xsl:value-of select="$messages[@id='tooltip.identification']"/></xsl:when>
			<xsl:when test="$navid='admin'"><xsl:value-of select="$messages[@id='tooltip.administration']"/></xsl:when>
			<xsl:when test="$navid='edit'"><xsl:value-of select="$messages[@id='tooltip.saisie']"/></xsl:when>
			<xsl:when test="starts-with($navid,'nav-')"><xsl:value-of select="$labels/doctype[@name=substring-after($navid,'nav-')]/label"/></xsl:when>
			<xsl:when test="starts-with($navid,'search-')"><xsl:value-of select="$labels/doctype[@name=substring-after($navid,'search-')]/label"/></xsl:when>
			<xsl:when test="starts-with($navid,'static-')"><xsl:value-of select="$displaylabels/label[@id=concat('static.tooltip.',substring-after($navid,'static-'))]"/></xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- Les informations utilisateurs -->
	<xsl:template match="*[@id='xtg-user-info']" mode="xhtml">
		<xsl:if test="not($currentuser/@anonymous)">
			<xsl:copy>
				<xsl:copy-of select="@*[name()!='id']"/>
				<xsl:apply-templates select="node()" mode="xhtml"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[@id='xtg-user-id']" mode="xhtml">
		<xsl:if test="$currentuser/@firstname!=''">
			<xsl:value-of select="$currentuser/@firstname"/>&#160;</xsl:if>
		<xsl:if test="$currentuser/@lastname!=''">
			<xsl:value-of select="$currentuser/@lastname"/>
		</xsl:if>
		<span dir="ltr">(<xsl:value-of select="$currentuser/@id"/>)</span>
	</xsl:template>

	<xsl:template match="*[@id='xtg-user-comment']" mode="xhtml">
		<xsl:value-of select="$messages[@id='common.vousetesidentifiecomme']"/><xsl:text> </xsl:text>
		<xsl:choose>
			<xsl:when test="$currentuser/@superuser='true'">
				<xsl:value-of select="$messages[@id='common.superutilisateur']"/>
			</xsl:when>
			<xsl:when test="$currentuser/@admin='true'">
				<xsl:value-of select="$messages[@id='common.administrateur']"/></xsl:when>
			<xsl:when test="$currentuser/@app">
				<xsl:value-of select="$messages[@id='common.utilisateur']"/></xsl:when>
		</xsl:choose>.
	</xsl:template>

	<!-- Gestion des messages -->
	<xsl:template match="*[starts-with(@id,'xtg-message-')]" mode="xhtml">
		<xsl:variable name="mid" select="substring-after(@id,'xtg-message-')"/>
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:value-of select="$messages[@id=$mid]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*[starts-with(@id,'xtg-message-')]" mode="xhtml-nav">
		<xsl:variable name="mid" select="substring-after(@id,'xtg-message-')"/>
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:value-of select="$messages[@id=$mid]"/>
		</xsl:copy>
	</xsl:template>

	<!-- Le contenu -->
	<xsl:template match="*[@id='xtg-content']" mode="xhtml">
		<xsl:copy>
			<xsl:copy-of select="@*[name()!='id']"/>
			<xsl:apply-templates select="$sdxdocument/child::*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
