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
	xmlns:urle="java.net.URLEncoder"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="saxon">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="dest_dir">.</xsl:param>
<xsl:param name="display_config_file"/>
<xsl:param name="app_full_path"/>
<xsl:param name="file_url_prefix"/>

<xsl:include href="xtogen-common-functions.xsl"/>

<xsl:template match="/">
<xsl:comment>
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
</xsl:comment>
	<xsl:apply-templates select="//documenttype"/>
</xsl:template>

<xsl:template match="documenttype">
	<xsl:variable name="output" select="concat($dest_dir,'/document_',@id,'.xsl')"/>
	<saxon:output href="{$output}">
	<xsl:variable name="currentid" select="@id"/>
	<xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
		<xsl:copy-of select="document('document_doctype.xsl.xsl')//namespace::*[.='http://www.culture.gouv.fr/ns/sdx/sdx']"/>
		<xsl:copy-of select="document('document_doctype.xsl.xsl')//namespace::*[.='java.net.URLEncoder']"/>
		<xsl:attribute name="version">1.0</xsl:attribute>
		<xsl:attribute name="exclude-result-prefixes">xsl sdx urle</xsl:attribute>

		<xsl:text>
		</xsl:text>
	<xsl:comment> Type de document <xsl:value-of select="@id"/> </xsl:comment>
	<xsl:variable name="confdisp" select="document(concat($file_url_prefix,$display_config_file))/display"/>
	<xsl:variable name="docinfo" select="$confdisp/documenttypes/documenttype[@id=$currentid]"/>
	<xsl:variable name="securityinfo" select="$confdisp/application/security/domain[@id='document']"/>

		<xsl:element name="xsl:template">
			<xsl:attribute name="match">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:element name="xsl:variable">
				<xsl:attribute name="name">docLang</xsl:attribute>
				<xsl:attribute name="select">/sdx:document/sdx:results/sdx:result[1]/sdx:field[@name='xtgdoclang']/@value</xsl:attribute>
			</xsl:element>
			
			<table border="0" width="100%">
			<tr><td>
			<h3><xsl:element name="xsl:value-of"><xsl:attribute name="select">$labels/doctype[@name='<xsl:value-of select="@id"/>']/label</xsl:attribute></xsl:element>
			</h3>
			<xsl:element name="xsl:if">
				<xsl:attribute name="test">$urlparameter[@name='app']/@value != /sdx:document/@app</xsl:attribute>
				&#160;<small>(application <xsl:element name="xsl:value-of"><xsl:attribute name="select">$urlparameter[@name='app']/@value</xsl:attribute></xsl:element>)</small>
			</xsl:element>
			&#160;<small>(<xsl:element name="xsl:value-of"><xsl:attribute name="select">$urlparameter[@name='id']/@value</xsl:attribute></xsl:element>)</small>
			</td>
			<td class="buttons">
				<xsl:attribute name="align">{$alignDirection}</xsl:attribute>
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name">bouton_documents</xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">titlefield</xsl:attribute>
						<xsl:attribute name="select"><xsl:value-of select="fields/descendant-or-self::field[@default]/@name"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</td>
			</tr>
			</table>
        <table cellpadding="10" cellspacing="0" width="100%" class="paddings">
            <tr>
                <td class="highlight">
                    <table cellpadding="0" cellspacing="3" width="100%" class="highlight">
					<tr>
						<td><img src="icones/cols.gif" width="100" height="1" alt="pour la mise en page seulement"/></td>
						<td><img src="icones/cols.gif" width="458" height="1" alt="pour la mise en page seulement"/></td>
					</tr>
						<!-- Variable utile -->
						<xsl:element name="xsl:variable">
							<xsl:attribute name="name">docapp</xsl:attribute>
							<xsl:attribute name="select">$urlparameter[@name='app']</xsl:attribute>
						</xsl:element>
						<xsl:element name="xsl:apply-templates">
							<xsl:attribute name="select">../sdx:navigation</xsl:attribute>
							<xsl:attribute name="mode">in</xsl:attribute>
						</xsl:element>
						<xsl:text>
						</xsl:text>

						<!-- Champs par défaut -->
						<xsl:for-each select="fields/descendant-or-self::field[@default]">
							<xsl:call-template name="managefield">
								<xsl:with-param name="value" select="."/>
								<xsl:with-param name="docinfo" select="$docinfo"/>
								<xsl:with-param name="absolute">yes</xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>

						<!-- Champs "normaux" -->
						<xsl:apply-templates select="fields/field[not(@default)]|fields/fieldgroup" mode="normal">
							<xsl:with-param name="docinfo" select="$docinfo"/>
						</xsl:apply-templates>

						<xsl:if test="count(//documenttype/fields/descendant-or-self::field[@type='relation' and @to=$currentid]) &gt; 0">
							<tr><td colspan="2"><hr/></td></tr>
						</xsl:if>
						<xsl:for-each select="//documenttype/fields/descendant-or-self::field[@type='relation' and @to=$currentid]">
							<tr><xsl:element name="xsl:call-template">
								<xsl:attribute name="name">reverse</xsl:attribute>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">db</xsl:attribute>
									<xsl:value-of select="ancestor::documenttype/@id"/>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">field</xsl:attribute>
									<xsl:value-of select="@name"/>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">application</xsl:attribute>
									<xsl:element name="xsl:choose">
										<xsl:element name="xsl:when">
											<xsl:attribute name="test">$docapp</xsl:attribute>
											<xsl:element name="xsl:value-of">
												<xsl:attribute name="select">$docapp/@value</xsl:attribute>
											</xsl:element>
										</xsl:element>
										<xsl:element name="xsl:otherwise">
											<xsl:element name="xsl:value-of">
												<xsl:attribute name="select">$currentapp</xsl:attribute>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:element></tr>
						</xsl:for-each>
                    </table>
                </td>
            </tr>
        </table>
		</xsl:element>

	<!-- Hilite -->
	<xsl:text>

	</xsl:text>
	<xsl:comment> Gestion des hilite </xsl:comment>
	<xsl:for-each select="fields/descendant-or-self::field">
		<xsl:element name="xsl:template">
			<xsl:attribute name="match"><xsl:choose><xsl:when test="@path"><xsl:value-of select="@path"/></xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:attribute name="mode">hilite</xsl:attribute>
			<xsl:element name="xsl:apply-templates"/>
		</xsl:element>
	</xsl:for-each>

	<!-- Meta -->
	<xsl:text>

	</xsl:text>
	<xsl:element name="xsl:template">
		<xsl:attribute name="match"><xsl:value-of select="@id"/></xsl:attribute>
		<xsl:attribute name="mode">meta</xsl:attribute>

		<xsl:variable name="fields" select="fields"/>
		<xsl:variable name="metas" select="$docinfo/meta/on"/>
		<xsl:for-each select="$metas">
			<xsl:variable name="meta" select="@meta"/>
			<xsl:if test="count(preceding-sibling::on[@meta=$meta]) = 0">
				<xsl:variable name="metavar" select="concat('meta',$meta)"/>
				<xsl:element name="xsl:variable">
					<xsl:attribute name="name"><xsl:value-of select="$metavar"/></xsl:attribute>
					<xsl:attribute name="select">
						<xsl:for-each select="$metas[@meta=$meta]">
							<xsl:variable name="name" select="@field"/>
							<xsl:if test="position()!=1">|</xsl:if>
							<xsl:call-template name="computeFullPath">
								<xsl:with-param name="field" select="$fields/descendant-or-self::field[@name=$name]"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:if">
					<xsl:attribute name="test">$<xsl:value-of select="$metavar"/></xsl:attribute>
					<xsl:element name="meta">
						<xsl:attribute name="name"><xsl:value-of select="$meta"/></xsl:attribute>
						<xsl:element name="xsl:attribute">
							<xsl:attribute name="name">content</xsl:attribute>
							<xsl:element name="xsl:for-each">
								<xsl:attribute name="select">$<xsl:value-of select="$metavar"/></xsl:attribute>
								<xsl:element name="xsl:if">
									<xsl:attribute name="test">position()!=1</xsl:attribute>, </xsl:element>
								<xsl:element name="xsl:value-of">
									<xsl:attribute name="select">.</xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:element>

	<!-- Control -->
	<xsl:element name="xsl:template">
		<xsl:attribute name="match">document[@type='<xsl:value-of select="@id"/>']</xsl:attribute>

		<xsl:choose>
			<xsl:when test="$securityinfo/documenttype[@id=$currentid]/control">
				<xsl:call-template name="manageSecurity">
					<xsl:with-param name="control" select="$securityinfo/documenttype[@id=$currentid]/control"/>
					<xsl:with-param name="doc" select="."/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$securityinfo/domain[@id='html']/documenttype[@id=$currentid]/control">
				<xsl:call-template name="manageSecurity">
					<xsl:with-param name="control" select="$securityinfo/domain[@id='html']/documenttype[@id=$currentid]/control"/>
					<xsl:with-param name="doc" select="."/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="manageDoc">
					<xsl:with-param name="docId" select="@id"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>

	</xsl:element>
	</saxon:output>
</xsl:template>

<xsl:template name="manageSecurity">
	<xsl:param name="control"/>
	<xsl:param name="doc"/>

	<xsl:variable name="fullPath">
		<xsl:call-template name="computeAbsolutePath">
			<xsl:with-param name="node" select="$doc/fields/descendant-or-self::field[@name=$control/@field]"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:element name="xsl:choose">
		<xsl:element name="xsl:when">
			<xsl:attribute name="test"><xsl:value-of select="$doc/@id"/>/<xsl:value-of select="$fullPath"/> = '<xsl:value-of select="$control/@value"/>'</xsl:attribute>	
			<xsl:element name="xsl:choose">
				<xsl:element name="xsl:when">
				<xsl:attribute name="test"><xsl:apply-templates select="$control/group" mode="condition"><xsl:with-param name="control" select="$control"/></xsl:apply-templates></xsl:attribute>
					<xsl:call-template name="manageDoc">
						<xsl:with-param name="docId" select="$doc/@id"/>
					</xsl:call-template>
				</xsl:element>
				<xsl:element name="xsl:otherwise">
					<span class="erreur"><xsl:element name="xsl:value-of">
						<xsl:attribute name="select">$messages[@id='page.document.accesinterditaudocument']</xsl:attribute>
					</xsl:element></span>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:element name="xsl:otherwise">
			<xsl:call-template name="manageDoc">
				<xsl:with-param name="docId" select="$doc/@id"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="group" mode="condition">
	<xsl:param name="control"/>

	<xsl:for-each select="$control/group">
		<xsl:variable name="app">
			<xsl:choose>
				<xsl:when test="@app"><xsl:value-of select="@app"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$app_full_path"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="position()!=1"> or </xsl:if>$currentuser[sdx:group[@id='<xsl:value-of select="@id"/>'] and @app='<xsl:value-of select="$app"/>']</xsl:for-each>
</xsl:template>

<xsl:template name="manageDoc">
	<xsl:param name="docId"/>

	<xsl:element name="xsl:apply-templates">
		<xsl:attribute name="select"><xsl:value-of select="@id"/></xsl:attribute>
	</xsl:element>
</xsl:template>

<!-- NORMAL -->
<xsl:template match="fieldgroup" mode="normal">
	<xsl:param name="docinfo"/>

	<xsl:variable name="path">
		<xsl:choose>
			<xsl:when test="@path"><xsl:value-of select="@path"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:if test="count(field[not(@default)])!=0 or count(fieldgroup)!=0">
		<xsl:element name="xsl:for-each">
			<xsl:attribute name="select"><xsl:value-of select="$path"/></xsl:attribute>
			<tr><td colspan="2">
				<fieldset>
					<xsl:element name="xsl:if">
						<xsl:attribute name="test">$docType/fieldgroup[@name='<xsl:value-of select="@name"/>'] != ''</xsl:attribute>
						<legend class="attribut"><xsl:element name="xsl:value-of"><xsl:attribute name="select">$docType/fieldgroup[@name='<xsl:value-of select="@name"/>']</xsl:attribute></xsl:element></legend>
					</xsl:element>
					<table border="0" width="100%">
						<xsl:apply-templates select="fieldgroup|field" mode="normal">
							<xsl:with-param name="docinfo" select="$docinfo"/>
						</xsl:apply-templates>
					</table>
				</fieldset>
			</td></tr>
		</xsl:element>
	</xsl:if>
</xsl:template>

<xsl:template match="field" mode="normal">
	<xsl:param name="docinfo"/>
	<xsl:call-template name="managefield">
		<xsl:with-param name="value" select="."/>
		<xsl:with-param name="docinfo" select="$docinfo"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="computeAbsolutePath">
	<xsl:param name="node"/><xsl:if test="name($node/parent::*)='fieldgroup'"><xsl:call-template name="computeAbsolutePath"><xsl:with-param name="node" select="$node/parent::*"/></xsl:call-template>/</xsl:if><xsl:choose><xsl:when test="$node/@path"><xsl:value-of select="$node/@path"/></xsl:when><xsl:otherwise><xsl:value-of select="$node/@name"/></xsl:otherwise></xsl:choose>
</xsl:template>

<!-- Manage field -->
<xsl:template name="managefield">
	<xsl:param name="value"/>
	<xsl:param name="docinfo"/>
	<xsl:param name="absolute">no</xsl:param>

	<!-- CSS class-->
	<xsl:variable name="cssclass">
		<xsl:choose>
			<xsl:when test="$value/@default and $absolute='yes'">titre</xsl:when>
			<xsl:otherwise>valeur</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Path -->
	<xsl:variable name="fieldpath">
		<xsl:choose>
			<xsl:when test="$absolute='yes'"><xsl:call-template name="computeAbsolutePath"><xsl:with-param name="node" select="$value"/></xsl:call-template></xsl:when>
			<xsl:when test="$value/@path"><xsl:value-of select="$value/@path"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$value/@name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Type -->
	<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="$value/@type and $value/@type!='image'"><xsl:value-of select="$value/@type"/></xsl:when>
			<xsl:when test="$value/@type='image'">attach</xsl:when>
			<xsl:otherwise>string</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Boucle sur les différents attributs -->
	<xsl:element name="xsl:choose">
		<!-- Pas d'élément -->
		<xsl:element name="xsl:when">
			<xsl:attribute name="test">count(<xsl:value-of select="$fieldpath"/>) = 0</xsl:attribute>
		</xsl:element>

		<!-- 1 élément -->
		<xsl:element name="xsl:when">
			<xsl:attribute name="test">count(<xsl:value-of select="$fieldpath"/>) = 1</xsl:attribute>
			<xsl:element name="xsl:if">
			<xsl:attribute name="test"><xsl:value-of select="$fieldpath"/> != ''</xsl:attribute>
			<tr>
			<xsl:element name="xsl:variable">
				<xsl:attribute name="name">value</xsl:attribute>
				<xsl:attribute name="select">normalize-space(<xsl:value-of select="$fieldpath"/>)</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:call-template">
				<xsl:attribute name="name">label</xsl:attribute>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">field</xsl:attribute>
					<xsl:value-of select="$value/@name"/>
				</xsl:element>
			</xsl:element>
			<td class="{$cssclass}" width="100%">
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name"><xsl:value-of select="$type"/></xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">field</xsl:attribute>
						<xsl:value-of select="$value/@name"/>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">value</xsl:attribute>
						<xsl:attribute name="select"><xsl:value-of select="$fieldpath"/></xsl:attribute>
					</xsl:element>
					<xsl:variable name="name" select="$value/@name"/>
					<xsl:if test="$docinfo/nav/on[@field=$name] and $type!='image' and $type!='attach' and not(@default)">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">nav</xsl:attribute>yes</xsl:element>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">evalue</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$type='choice' and $value/@list">
									<xsl:attribute name="select">document(concat('lang/liste/',$docLang,'/',$docLang,'_<xsl:value-of select="$value/@list"/>.xml'))/list/item[.=$value]/@id</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="select">urle:encode(string(string(<xsl:value-of select="$fieldpath"/>)),'UTF-8')</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<xsl:if test="$type='choice' and $value/@list">
							<xsl:element name="xsl:with-param">
								<xsl:attribute name="name">list</xsl:attribute><xsl:value-of select="$value/@list"/></xsl:element>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$type = 'relation'">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">base</xsl:attribute>
							<xsl:value-of select="$value/@to"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$type='attach'">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">base</xsl:attribute>
							<xsl:value-of select="$value/ancestor::documenttype/@id"/>
						</xsl:element>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">mode</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$docinfo/document/on[@field=$name]/@mode"><xsl:value-of select="$docinfo/document/on[@field=$name]/@mode"/></xsl:when>
								<xsl:otherwise>link</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$type='relation' or $type='attach'">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">application</xsl:attribute>
							<xsl:element name="xsl:choose">
								<xsl:element name="xsl:when">
									<xsl:attribute name="test">$docapp</xsl:attribute>
									<xsl:element name="xsl:value-of">
										<xsl:attribute name="select">$docapp/@value</xsl:attribute>
									</xsl:element>
								</xsl:element>
								<xsl:element name="xsl:otherwise">
									<xsl:element name="xsl:value-of">
										<xsl:attribute name="select">$currentapp</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</td>
			</tr>
			</xsl:element>
		</xsl:element>

		<!-- n éléments (boucle) -->
		<xsl:element name="xsl:otherwise">
			<tr>
			<xsl:element name="xsl:call-template">
				<xsl:attribute name="name">label</xsl:attribute>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">field</xsl:attribute>
					<xsl:value-of select="$value/@name"/>
				</xsl:element>
			</xsl:element>
			<td class="{$cssclass}" width="100%">
		<xsl:choose>
			<!-- Traitement des attachements -->
			<xsl:when test="$type='attach'">
				<div id="galerie">
					<div class="spacer">&#160;</div>
					<xsl:element name="xsl:for-each">
						<xsl:attribute name="select"><xsl:value-of select="$fieldpath"/></xsl:attribute>
						<div class="float">
							<xsl:element name="xsl:call-template">
								<xsl:attribute name="name">attach</xsl:attribute>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">field</xsl:attribute>
									<xsl:value-of select="$value/@name"/>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">value</xsl:attribute>
									<xsl:attribute name="select">.</xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">base</xsl:attribute>
									<xsl:value-of select="$value/ancestor::documenttype/@id"/>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">application</xsl:attribute>
									<xsl:element name="xsl:choose">
										<xsl:element name="xsl:when">
											<xsl:attribute name="test">$docapp</xsl:attribute>
											<xsl:element name="xsl:value-of">
												<xsl:attribute name="select">$docapp/@value</xsl:attribute>
											</xsl:element>
										</xsl:element>
										<xsl:element name="xsl:otherwise">
											<xsl:element name="xsl:value-of">
												<xsl:attribute name="select">$currentapp</xsl:attribute>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">mode</xsl:attribute>
									<xsl:choose>
										<xsl:when test="$docinfo/document/on[@field=$value/@name]/@mode"><xsl:value-of select="$docinfo/document/on[@field=$value/@name]/@mode"/></xsl:when>
										<xsl:otherwise>link</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:element>
						</div>
					</xsl:element>
					<div class="spacer">&#160;</div>
				</div>
			</xsl:when>
			<!-- Traitement des champs autre que "attach" -->
			<xsl:otherwise>
				<ul>
				<xsl:element name="xsl:for-each">
				<xsl:attribute name="select"><xsl:value-of select="$fieldpath"/></xsl:attribute>
				<xsl:element name="xsl:variable">
					<xsl:attribute name="name">value</xsl:attribute>
					<xsl:attribute name="select">normalize-space(.)</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:if">
					<xsl:attribute name="test">$value != ''</xsl:attribute>
				<li>
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name"><xsl:value-of select="$type"/></xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">field</xsl:attribute>
						<xsl:value-of select="$value/@name"/>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">value</xsl:attribute>
						<xsl:attribute name="select">.</xsl:attribute>
					</xsl:element>
					<xsl:variable name="name" select="$value/@name"/>
					<xsl:if test="$docinfo/nav/on[@field=$name] and not(@default)">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">nav</xsl:attribute>yes</xsl:element>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">evalue</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$type='choice' and $value/@list">
									<xsl:attribute name="select">document(concat('lang/liste/',$docLang,'/',$docLang,'_<xsl:value-of select="$value/@list"/>.xml'))/list/item[.=$value]/@id</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="select">urle:encode(string(string(.)),'UTF-8')</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<xsl:if test="$type='choice' and $value/@list">
							<xsl:element name="xsl:with-param">
								<xsl:attribute name="name">list</xsl:attribute><xsl:value-of select="$value/@list"/></xsl:element>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$type = 'relation'">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">base</xsl:attribute>
							<xsl:value-of select="$value/@to"/>
						</xsl:element>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">application</xsl:attribute>
							<xsl:element name="xsl:choose">
								<xsl:element name="xsl:when">
									<xsl:attribute name="test">$docapp</xsl:attribute>
									<xsl:element name="xsl:value-of">
										<xsl:attribute name="select">$docapp/@value</xsl:attribute>
									</xsl:element>
								</xsl:element>
								<xsl:element name="xsl:otherwise">
									<xsl:element name="xsl:value-of">
										<xsl:attribute name="select">$currentapp</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:element>
				</li>
				</xsl:element>
				</xsl:element>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
		</td></tr>
		</xsl:element>
	</xsl:element>
	<xsl:text>
	</xsl:text>
</xsl:template>


</xsl:stylesheet>

