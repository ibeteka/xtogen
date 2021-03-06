<?xml version="1.0"?>
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
	xmlns:saxon="http://icl.com/saxon" 
	extension-element-prefixes="saxon" 
	exclude-result-prefixes="sdx">
	
	<xsl:output method="xml" indent="yes"/>
	<xsl:param name="appli_name"/>
	<xsl:param name="appli_comment"/>
	<xsl:param name="xtogen_version"/>

	<xsl:template match="/">
		<xsl:variable name="doctypes" select="//documenttypes/documenttype"/>
		<html>
			<head>
				<title>XToGen Template</title>
				<link rel="stylesheet" type="text/css" href="css/html.css"/>
			</head>
			<body>
				<table id="layout">
					<tr>
						<td colspan="3" class="header">
							<table id="headerlayout">
								<tr>
									<td>
										<img alt="logo" src="icones/logo.png" title="{$appli_name}"/>
									</td>
									<td id="title"><xsl:value-of select="$appli_comment"/></td>
									<td class="langbar" id="xtg-lang-bar">
										<div id="xtg-lang-item"/>
										<div id="xtg-lang-item-selected">
											<span id="xtg-lang-label"/>
										</div>
										<div id="xtg-lang-item-notselected">
											<a id="xtg-lang-link">
												<span id="xtg-lang-label"/>
											</a>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>

					<tr>
						<td id="tdmenu">
							<ul id="menubar">
								<li id="xtg-nav-index">
									<a id="xtg-nav-link" class="barnav" href="#">
										<span id="xtg-nav-label">#Index#</span>
									</a>
								</li>
								<xsl:if test="$doctypes/nav/on">
									<li id="xtg-nav-nav">
										<xsl:choose>
											<!-- Un seul type de document -->
											<xsl:when test="count($doctypes/nav[on])=1">
												<div id="xtg-nav-nav-{$doctypes[nav/on]/@id}" nowrap="nowrap">
													<a id="xtg-nav-link" class="barnav" href="nav.xsp?db={$doctypes[nav/on]/@id}">
														<span id="xtg-message-bouton.navigation"/>
													</a>
												</div>
											</xsl:when>
											<!-- Plusieurs types de documents -->
											<xsl:otherwise>
												<fieldset>
													<legend id="xtg-message-bouton.navigation">#Navigation#</legend>
													<xsl:for-each select="$doctypes[nav/on]">
														<div id="xtg-nav-nav-{@id}">
															<a id="xtg-nav-link" class="barnav" href="#">
																<span id="xtg-nav-label">#<xsl:value-of select="@id"/>#</span>
															</a>
														</div>
													</xsl:for-each>
												</fieldset>
											</xsl:otherwise>
										</xsl:choose>
									</li>
								</xsl:if>
								<xsl:if test="$doctypes/search/on">
									<li id="xtg-nav-search">
										<xsl:choose>
											<!-- Un seul type de document -->
											<xsl:when test="count($doctypes/search[on])=1">
												<div id="xtg-nav-search-{$doctypes[search/on]/@id}" nowrap="nowrap">
													<a id="xtg-nav-link" class="barnav" href="#">
														<span id="xtg-message-bouton.recherche"/>
													</a>
												</div>
											</xsl:when>
											<!-- Plusieurs types de documents -->
											<xsl:otherwise>
												<fieldset>
													<legend id="xtg-message-bouton.recherche">#Recherche#</legend>
													<xsl:for-each select="$doctypes[search/on]">
														<div id="xtg-nav-search-{@id}">
															<a id="xtg-nav-link" class="barnav" href="#">
																<span id="xtg-nav-label">#<xsl:value-of select="@id"/>#</span>
															</a>
														</div>
													</xsl:for-each>
												</fieldset>
											</xsl:otherwise>
											</xsl:choose>
										</li>
									</xsl:if>
									<xsl:if test="//application/static/page">
										<xsl:for-each select="//application/static/page">
											<li id="xtg-nav-static-{.}">
												<a id="xtg-nav-link" class="barnav" href="#">
													<span id="xtg-nav-label">#<xsl:value-of select="."/>#</span>
												</a>
											</li>
										</xsl:for-each>
									</xsl:if>

									<li id="xtg-nav-login">
										<a id="xtg-nav-link" class="barnav" href="#">
											<span id="xtg-nav-label">#Login#</span>
										</a>
									</li>
									<li id="xtg-nav-admin">
										<a id="xtg-nav-link" class="barnav" href="#">
											<span id="xtg-nav-label">#Administration#</span>
										</a>
									</li>
									<li>
										<small id="xtg-message-bouton.recherche">
											#Recherche#
										</small>
										<form action="results.xsp" method="get">
											<input id="xtg-search-input" type="text" name="q" size="15"/>
											<select id="xtg-lang-combo" name="qlang"/>
											<input type="image" value="submit" src="icones/ok.png"/>
										</form>
									</li>
								</ul>
							</td>
							<td colspan="2" valign="top" id="tdcontent">
								<div id="xtg-content">
									<table width="100%" bgcolor="grey">
										<tr>
											<td align="center">
												<br/>
												<br/>
												<br/>
												<br/>
												<br/>
												<br/>
												<br/>
												<br/>
												<br/>
												<span style="color=#000000;">CONTENT</span>
												<br/>
												<br/>
												<br/>
												<br/>
												<br/>
												<br/>
												<br/>
												<br/>
												<br/>
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="3" class="footer">
								<div id="xtg-user-info">
									<span id="xtg-user-id">#user#</span>, <span id="xtg-user-comment">#comment#</span>
								</div>
								<a class="url" href="http://xtogen.tech.fr" title="XToGen {$xtogen_version}">
									<img alt="XToGen" src="icones/v_xtogen.png" width="79" height="24"/>
								</a>
							</td>
						</tr>
					</table>
				</body>
			</html>
		</xsl:template>

	</xsl:stylesheet>
