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

	<!-- Variables globales -->
	<xsl:import href="vars.xsl"/>

	<!-- Gestion des composants -->
	<xsl:import href="components.xsl"/>

	<!-- Gestion des templates -->
	<xsl:import href="template.xsl"/>

	<!-- Suffit des espaces en trop !-->
	<xsl:strip-space elements="*"/>

    <!-- modèle racine de page HTML -->
    <xsl:template match="/sdx:document">
		<!-- En fonction de la configuration -->
		<xsl:choose>
			<xsl:when test="$conf_disp/templates/template[@in='general']">
				<!-- Utilisation du mode template -->
				<xsl:apply-templates select="." mode="template"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Utilisation du mode traditionnel -->
				<xsl:apply-templates select="." mode="normal"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Mode template -->
	<xsl:template match="/sdx:document" mode="template">
		<xsl:variable name="langtemplateurl" select="concat('../templates/skeleton_',$lang,'.html')"/>
		<xsl:variable name="generaltemplateurl" select="'../templates/skeleton.html'"/>
		<xsl:choose>
			<xsl:when test="document($langtemplateurl)">
				<xsl:apply-templates select="document($langtemplateurl)" mode="xhtml"/>
			</xsl:when>
			<xsl:when test="document($generaltemplateurl)">
				<xsl:apply-templates select="document($generaltemplateurl)" mode="xhtml"/>
			</xsl:when>
			<xsl:otherwise>
			<foo>
			Erreur : template de langue <xsl:value-of select="$langtemplateurl"/> 
				et template générique <xsl:value-of select="generaltemplateurl"/> introuvables !!!
			</foo>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Mode traditionnel -->
	<xsl:template match="/sdx:document" mode="normal">
		<xsl:element name="html">
			<xsl:if test="$langDirection = 'rtl'">
				<xsl:attribute name="dir">rtl</xsl:attribute>
			</xsl:if>
            <head>
				<meta name="GENERATOR" content="XToGen version {$xtogenVersion} (http://xtogen.tech.fr)"/>
				<meta name="language" content="{$lang}"/>
                <xsl:apply-templates mode="meta"/>
                <title>
					<xsl:call-template name="display-title"/>
                </title>
                <link rel="stylesheet" type="text/css" href="css/html.css"/>
                <xsl:apply-templates mode="head"/>
            </head>
            <body bgcolor="#FFFFFF" leftmargin="0" topmargin="0">

                <xsl:attribute name="onload">
                    <xsl:apply-templates mode="onload"/>
                </xsl:attribute>
            	<table width="720" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td><img src="icones/cols.gif" width="150" height="1" alt="pour la mise en page seulement"/></td>
						<td><img src="icones/cols.gif" width="450" height="1" alt="pour la mise en page seulement"/></td>
						<td><img src="icones/cols.gif" width="120" height="1" alt="pour la mise en page seulement"/></td>
					</tr>
  					<tr> 
    					<td colspan="3" class="header"><xsl:apply-templates select="$header" mode="component"/></td>
					</tr>
					<tr> 
						<td valign="top">
							<xsl:apply-templates select="$navbar" mode="component"/>
						</td>
						<td colspan="2" valign="top">
							<table cellpadding="5" width="100%">
								<tr><td>
									<xsl:apply-templates/>
								</td></tr>
							</table>
						</td>
					</tr>
						<tr> 
							<td colspan="3" class="footer">
								<xsl:apply-templates select="$footer" mode="component"/>
							</td>
						</tr>		
				</table>
			</body>
        </xsl:element>
    </xsl:template>

<!-- Gestion du titre de la page -->
<xsl:template name="display-title">
	<xsl:choose>
		<xsl:when test="$sdxdocument//title[@id]">
			<xsl:variable name="titleid" select="$sdxdocument//title/@id"/>
			<xsl:choose>
				<xsl:when test="$titleid='title.static'">
					<xsl:variable name="foo">static.pagetitle.<xsl:value-of select="$urlparameter[@name='page']/@value"/></xsl:variable>
					<xsl:value-of select="$displaylabels/label[@id=$foo]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="titleString" select="$messages[@id=$titleid]"/>
					<xsl:variable name="pattern">[XTOGEN]</xsl:variable>
					<xsl:choose>
						<xsl:when test="contains($titleString,$pattern)">
							<xsl:value-of select="substring-before($titleString,$pattern)"/><xsl:value-of select="$labels/application"/><xsl:value-of select="substring-after($titleString,$pattern)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$titleString"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$sdxdocument//title"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

   <!-- Meta -->
   <xsl:template match="*|text()" mode="meta">
   		<xsl:apply-templates mode="meta"/>
   </xsl:template>

   <xsl:template match="title"/>
    <xsl:template match="*|text()" mode="head"/>
    <xsl:template match="*[@show='replace'][@actuate='onload']" mode="head">
        <meta http-equiv="refresh" content="{@time};URL={@href}"/>
    </xsl:template>
    <xsl:template match="*[@show='replace'][@actuate='onload']">
        <p>
		<xsl:copy-of select="$messages[@id='common.redirection.debut']"/>
                <xsl:value-of select="@time"/>
            <xsl:if test="not(@time)"><xsl:copy-of select="$messages[@id='common.redirection.quelques']"/></xsl:if>
        <xsl:copy-of select="$messages[@id='common.redirection.secondes']"/><a class="nav" href="{@href}"><xsl:copy-of select="$messages[@id='common.redirection.ici']"/></a>
        </p>
    </xsl:template>

    <!-- si barre de navigation demandée dans la source, es liens vers d'autres pages -->
    <xsl:template match="bar"/>

    <xsl:template match="accueil">
		<xsl:copy-of select="document(concat($langpath,'_edito.xml'))"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="static">
		<xsl:variable name="page" select="$urlparameter[@name='page']/@value"/>
		<xsl:variable name="staticfile" select="concat($langpath,'_static_', $page,'.xml')"/>
		<xsl:variable name="staticcontent" select="document($staticfile)"/>
		<xsl:if test="count($staticcontent)=0">
			<span class="erreur"><xsl:value-of select="$messages[@id='common.pasdecontenudanslefichierstatique.debut']"/>&#160;<b>xsl/<xsl:value-of select="$staticfile"/></b>&#160;<xsl:value-of select="$messages[@id='common.pasdecontenudanslefichierstatique.fin']"/></span>
		</xsl:if>
		<xsl:copy-of select="$staticcontent"/>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- ======== SDX DEFAULT ========== -->
    <!--
        résultats de recherche, barre d'infos   
-->
    <xsl:template match="sdx:results | sdx:terms" mode="status">
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
                <td>
                    <xsl:apply-templates select="sdx:query"/>
                    <xsl:if test="sdx:term">
                        <b>Liste des 
                            <xsl:value-of select="
        document('../conf/db_info.xml')/sdx:dbInfo/sdx:fieldList/sdx:field[@code=current()/@code]/sdx:name

        "/>s</b>
                    </xsl:if>
                </td>
                <td align="right">
                    <xsl:if test="@nb &gt; 0">
                        <xsl:choose>
                            <xsl:when test="sdx:result">Résultats : </xsl:when>
                            <xsl:otherwise>Résultats&#160;:&#160;</xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="@start"/> à <xsl:value-of select="@end"/>
        / <xsl:value-of select="@nb"/>
         - 
        <b>Page&#160;
        <xsl:value-of select="@currentPage"/>
                        </b>
        / <xsl:value-of select="@nbPages"/>&#160;
        </xsl:if>
                </td>
            </tr>
        </table>
    </xsl:template>
    <xsl:template match="sdx:query">
        <b>Recherche  : "<xsl:value-of select="."/>"</b>
    </xsl:template>
    <!--
   Navigation page per page in results list 
-->
    <xsl:template match="sdx:results | sdx:terms" mode="hpp">
		<xsl:variable name="page">
			<xsl:text/><xsl:value-of select="$currentpage"/>?<xsl:for-each select="$urlparameter[@type='get' and @name!='qid' and @name!='p']">
				<xsl:text/><xsl:value-of select="@name"/>=<xsl:value-of select="@value"/>&amp;<xsl:text/>
			</xsl:for-each>qid=<xsl:value-of select="@id"/><xsl:text/>
		</xsl:variable>
        <xsl:if test="number(@nbPages) &gt; 1">
            <table cellpadding="0" cellspacing="0" border="0" width="100%" class="navigation">
                <tr>
                    <td>
						<xsl:value-of select="@nb"/>&#160;<xsl:value-of select="$messages[@id='common.resultats']"/> - <xsl:value-of select="$messages[@id='common.page']"/> : <xsl:value-of select="@currentPage"/>/<xsl:value-of select="@nbPages"/>
                    </td>
				</tr>
				<tr>
                    <!-- calcul des pages à afficher -->
                    <xsl:variable name="modulo" select="number(10)"/>
					<xsl:variable name="min">
						<xsl:choose>
							<xsl:when test="@currentPage &lt;= ($modulo div 2)">1</xsl:when>
							<xsl:otherwise><xsl:value-of select="@currentPage - ($modulo div 2)"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
                    <xsl:variable name="max">
                        <xsl:choose>
                            <xsl:when test="@nbPages &lt; $min+$modulo - 1">
                                <xsl:value-of select="@nbPages"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$min+$modulo - 1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
					<td align="center">
						<xsl:if test="$min != 1">
						<a class="nav" href="{$page}&amp;p=1" title="{$messages[@id='common.debut']}">1</a>&#160;
						</xsl:if>
						<xsl:if test="$min != 1">
						<a class="nav" href="{$page}&amp;p={number($min)-number($modulo)}" title="{concat($modulo,' ',$messages[@id='common.pagesprecedentes'])}"><img src="{$iconPPrev}" border="0" align="middle"/></a>&#160;
						</xsl:if>
                        <xsl:if test="@currentPage &gt; 1">
                            <a class="nav" href="{$page}&amp;p={number(@currentPage)-1}" title="{$messages[@id='common.pageprecedente']}"><img src="{$iconPrev}" border="0" align="middle"/></a>&#160;
                        </xsl:if>
						<!-- comptage des pages -->
						<xsl:call-template name="_hppCount">
							<xsl:with-param name="i" select="$min"/>
							<xsl:with-param name="max" select="$max"/>
							<xsl:with-param name="selected" select="@currentPage"/>
							<xsl:with-param name="page" select="$page"/>
						</xsl:call-template>
                        <xsl:if test="number(@currentPage) &lt; number(@nbPages)">
                            <a class="nav" href="{$page}&amp;p={number(@currentPage)+1}" title="{$messages[@id='common.pagesuivante']}"><img src="{$iconNext}" border="0" align="middle"/></a>&#160;
                        </xsl:if>
						<xsl:if test="$min + $modulo &lt;= @nbPages">
						<a class="nav" href="{$page}&amp;p={number($min)+number($modulo)}" title="{concat($modulo,' ',$messages[@id='common.pagessuivantes'])}"><img src="{$iconNNext}" border="0" align="middle"/></a>&#160;
						</xsl:if>
						<xsl:if test="$min + $modulo &lt;= @nbPages">
						<a class="nav" href="{$page}&amp;p={@nbPages}" title="{$messages[@id='common.fin']}"><xsl:value-of select="@nbPages"/></a>&#160;
						</xsl:if>
					</td>
                </tr>
            </table>
        </xsl:if>
    </xsl:template>
    <!-- modèle privé de comptage des pages "hitsPerPage" -->
    <xsl:template name="_hppCount">
        <xsl:param name="page"/>
        <xsl:param name="i" select="1"/>
        <xsl:param name="max" select="10"/>
        <xsl:param name="selected"/>
        <xsl:if test="$i = $selected">
            <span class="currentPage">
                [&#160;<xsl:value-of select="$i"/>&#160;]
            </span>
        </xsl:if>
        <xsl:if test="$i != $selected">
            <a class="nav" href="{$page}&amp;p={$i}">
                <xsl:value-of select="$i"/>
            </a>
        </xsl:if>
        &#160;
        <xsl:if test="$i &lt; $max">
            <xsl:call-template name="_hppCount">
                <xsl:with-param name="i" select="$i+1"/>
                <xsl:with-param name="max" select="$max"/>
                <xsl:with-param name="selected" select="$selected"/>
                <xsl:with-param name="page" select="$page"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template match="sdx:results">
        <ol>
            <xsl:apply-templates/>
            <xsl:if test="not(sdx:result)">NO RESULT</xsl:if>
        </ol>
    </xsl:template>
    <xsl:template match="sdx:query">
        <p>Query - type=<b>
                <xsl:value-of select="@type"/>&#160;</b> - text=<b>
                <xsl:value-of select="@text"/>&#160;</b>
        </p>
    </xsl:template>
    <xsl:template match="sdx:result">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="sdx:field">
        <div>
            <xsl:value-of select="@name"/>:<xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="sdx:terms">
        <ol>
            <xsl:apply-templates/>
            <xsl:if test="not(sdx:term)"> NO TERM </xsl:if>
        </ol>
    </xsl:template>
    <xsl:template match="sdx:term">
        <li>
            <xsl:value-of select="@field"/>:<xsl:value-of select="@value"/>
        </li>
    </xsl:template>
    <!-- display user -->
    <xsl:template match="sdx:user"/>

    <xsl:template match="sdx:user" mode="userident">
		<xsl:if test="not(@anonymous)">
			<xsl:if test="@firstname!=''"><xsl:value-of select="@firstname"/>&#160;</xsl:if>
		 	<xsl:if test="@lastname!=''"><xsl:value-of select="@lastname"/>&#160;</xsl:if>
			(<xsl:value-of select="@id"/>), 
			<xsl:value-of select="$messages[@id='common.vousetesidentifiecomme']"/>&#160;
			<xsl:choose>
				<xsl:when test="@anonymous"/>
				<xsl:when test="@superuser='true'"><xsl:value-of select="$messages[@id='common.superutilisateur']"/></xsl:when>
				<xsl:when test="@admin='true'"><xsl:value-of select="$messages[@id='common.administrateur']"/>&#160;<xsl:value-of select="@app"/>.</xsl:when>
				<xsl:when test="@app"><xsl:value-of select="$messages[@id='common.utilisateur']"/>&#160;<xsl:value-of select="@app"/>.</xsl:when>
			</xsl:choose>
		</xsl:if>
    </xsl:template>

    <!-- ======== STRUCTURE ========== -->
    <xsl:template match="*|text()" mode="onload"/>
    <xsl:template match="sdx:*"/>
    <xsl:template match="link"/>
    <xsl:template match="*" priority="-1">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="comment()|text()| node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>
    <xsl:template match="text()|processing-instruction()|comment()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>

	<xsl:template match="sdx:exception">
		<div class="error">
		<xsl:value-of select="sdx:message"/>
		<pre>
			<xsl:value-of select="sdx:originalException"/>
		</pre>
		</div>
	</xsl:template>

	<xsl:template match="app"/>

	<xsl:template name="langCombo">
		<xsl:param name="name"/>
		<xsl:param name="aLang"/>
		<!--<b>{{{<xsl:value-of select="$aLang"/>}}}</b>-->
		
		<xsl:variable name="selectedLanguage">
			<xsl:choose>
				<xsl:when test="$aLang and $aLang!=''"><xsl:value-of select="$aLang"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$lang"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!--<b>{{{<xsl:value-of select="$selectedLanguage"/>}}}</b>-->
		<select name="{$name}">
			<xsl:for-each select="$langs/lang">
				<option value="{@id}">
					<xsl:if test="@id=$selectedLanguage">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="@id"/>
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>

	<xsl:template name="sortbar">
		<xsl:if test="$currentdoctypesort">
			<xsl:variable name="currentsortfield" select="$urlparameter[@name='sortfield']/@value"/>
			<xsl:variable name="currentorder" select="$urlparameter[@name='order']/@value"/>
			<xsl:value-of select="$messages[@id='common.trierpar']"/>
			<xsl:text> </xsl:text>
			<xsl:for-each select="$currentdoctypesort/on">
				<xsl:variable name="field" select="@field"/>
				<xsl:if test="position()!=1">
					<xsl:text> - </xsl:text>
				</xsl:if>
				<xsl:variable name="upicon">
					<xsl:choose>
						<xsl:when test="$currentsortfield=@field and $currentorder='ascendant'">icones/selected_up.png</xsl:when>
						<xsl:otherwise>icones/up.png</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<a href="{$sortprefixuri}sortfield={@field}&amp;order=ascendant">
					<img src="{$upicon}" border="0" title="{$messages[@id='common.ordreascendant']}"/>
				</a>
				<xsl:text> </xsl:text>
				<span>
					<xsl:if test="$currentsortfield=@field">
						<xsl:attribute name="style">text-decoration: underline;</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$labels/doctype[@name=$currentdoctype]/sort[@field=$field]"/>
				</span>
				<xsl:text> </xsl:text>
				<xsl:variable name="downicon">
					<xsl:choose>
						<xsl:when test="$currentsortfield=@field and $currentorder='descendant'">icones/selected_down.png</xsl:when>
						<xsl:otherwise>icones/down.png</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<a href="{$sortprefixuri}sortfield={@field}&amp;order=descendant">
					<img src="{$downicon}" border="0" title="{$messages[@id='common.ordredescendant']}"/>
				</a>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
