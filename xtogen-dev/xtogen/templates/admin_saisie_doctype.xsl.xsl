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
	exclude-result-prefixes="saxon">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="dest_dir">.</xsl:param>
<xsl:param name="display_config_file"/>
<xsl:param name="file_url_prefix"/>

<xsl:variable name="forminfo" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes"/>


<!-- Squelette général du fichier -->
<xsl:template match="documenttype">
	<xsl:variable name="output" select="concat($dest_dir,'/admin_saisie_',@id,'.xsl')"/>
	<saxon:output href="{$output}">
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
	<xsl:variable name="currentid" select="@id"/>
	<xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
		<xsl:copy-of select="document('admin_saisie_doctype.xsl.xsl')//namespace::*[.='http://www.culture.gouv.fr/ns/sdx/sdx']"/>
		<xsl:attribute name="version">1.0</xsl:attribute>
		<xsl:attribute name="exclude-result-prefixes">xsl</xsl:attribute>

		<xsl:variable name="docinfo" select="$forminfo/documenttype[@id=$currentid]/edit"/>

		<xsl:text>

		</xsl:text>
		<xsl:comment> Type de document <xsl:value-of select="@id"/> </xsl:comment>

		<xsl:element name="xsl:template">
			<xsl:attribute name="match">document/<xsl:value-of select="@id"/></xsl:attribute>
		<xsl:element name="xsl:choose">
			<xsl:element name="xsl:when">
				<xsl:attribute name="test">@id and (not($mode) or $mode!='copy')</xsl:attribute>
				<xsl:element name="input">
					<xsl:attribute name="name">documentId</xsl:attribute>
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="value">{@id}</xsl:attribute>
				</xsl:element>
			</xsl:element>
			<xsl:element name="xsl:when">
				<xsl:attribute name="test">$urlparameter[@name='id'] and (not($mode) or $mode!='copy')</xsl:attribute>
				<xsl:element name="input">
					<xsl:attribute name="name">documentId</xsl:attribute>
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="value">{$urlparameter[@name='id']/@value}</xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:element name="xsl:if">
			<xsl:attribute name="test">@id and (not($mode) or $mode!='copy')</xsl:attribute>
			<xsl:element name="input">
				<xsl:attribute name="name">documentId</xsl:attribute>
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="value">{@id}</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="xsl:variable">
			<xsl:attribute name="name">documentLang</xsl:attribute>
			<xsl:element name="xsl:choose">
				<xsl:element name="xsl:when">
					<xsl:attribute name="test">@xml:lang</xsl:attribute>
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">@xml:lang</xsl:attribute>
					</xsl:element>
				</xsl:element>
				<xsl:element name="xsl:otherwise">
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">$lang</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
        <table cellpadding="10" cellspacing="0" width="100%" class="paddings">
            <tr>
                <td class="highlight">
                    <table cellpadding="3" class="highlight" cellspacing="0" width="100%">

						<!-- Versioning -->
						<xsl:if test="@versioning='true'">
							<xsl:element name="xsl:call-template">
								<xsl:attribute name="name">manageVersioning</xsl:attribute>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">root</xsl:attribute>
									<xsl:attribute name="select">.</xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:if>

						<!-- Langue -->
						<xsl:element name="input">
							<xsl:attribute name="type">hidden</xsl:attribute>
							<xsl:attribute name="name">documentLang</xsl:attribute>
							<xsl:attribute name="value">{$documentLang}</xsl:attribute>
						</xsl:element>
						<tr><td><xsl:element name="xsl:value-of"><xsl:attribute name="select">$messages[@id='page.saisie.languedudocument']</xsl:attribute></xsl:element>:</td><td>
						<b><xsl:element name="xsl:value-of"><xsl:attribute name="select">$documentLang</xsl:attribute></xsl:element></b>
						</td></tr>	

						<!-- Champ par défaut -->
						<xsl:for-each select="fields/descendant-or-self::field[@default]">
							<xsl:call-template name="managefield">
								<xsl:with-param name="absolute">yes</xsl:with-param>
								<xsl:with-param name="value" select="."/>
								<xsl:with-param name="docinfo" select="$docinfo"/>
							</xsl:call-template>
						</xsl:for-each>

						<!-- Champs 'normaux' -->
						<xsl:apply-templates select="fields/field[not(@default)]|fields/fieldgroup">
							<xsl:with-param name="docinfo" select="$docinfo"/>
						</xsl:apply-templates>
                    </table>
                </td>
            </tr>
        </table>
		</xsl:element>

	</xsl:element>
	</saxon:output>
</xsl:template>

<!--
	Génère la déclaration d'une variable $gpref-[nom]
	utilisée pour préfixer les noms des éléments du
	formulaire de saisie
-->
<xsl:template name="customprefix">
	<xsl:param name="empty"/>
	<xsl:param name="name"/>
	<xsl:element name="xsl:variable">
		<xsl:attribute name="name">gpref-<xsl:value-of select="$name"/></xsl:attribute>
		<xsl:attribute name="select">
			<xsl:choose>
				<xsl:when test="$empty">'empty_'</xsl:when>
				<xsl:otherwise>concat(generate-id(.),'_')</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:element>
</xsl:template>

<!--
	Génère la déclaration d'une variable $divid-[nom]
	utilisée pour nommer les "div" des fieldgroup
-->
<xsl:template name="makedivid">
	<xsl:param name="empty"/>
	<xsl:param name="node"/>
	<xsl:param name="nodename"/>
	<xsl:param name="name"/>
	<xsl:element name="xsl:variable">
		<xsl:attribute name="name">divid-<xsl:value-of select="$name"/></xsl:attribute>
		<xsl:call-template name="makevalueof">
			<xsl:with-param name="node" select="$node/parent::*"/>
		</xsl:call-template>
		<xsl:choose>
			<xsl:when test="$empty">
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">'<xsl:value-of select="$name"/>_empty'</xsl:attribute>
					</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="xsl:choose">
					<xsl:element name="xsl:when">
						<xsl:attribute name="test"><xsl:value-of select="$nodename"/>[1]</xsl:attribute>
						<xsl:element name="xsl:value-of">
							<xsl:attribute name="select">concat('<xsl:value-of select="$name"/>_',generate-id(<xsl:value-of select="$nodename"/>[1]))</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:element name="xsl:otherwise"><xsl:value-of select="$name"/>_empty</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
</xsl:template>

<xsl:template name="makevalueof">
	<xsl:param name="node"/>

	<xsl:if test="name($node/parent::*) = 'fieldgroup'">
		<xsl:call-template name="makevalueof">
			<xsl:with-param name="node" select="$node/parent::*"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="name($node) = 'fieldgroup'">
		<xsl:element name="xsl:value-of">
			<xsl:attribute name="select">$gpref-<xsl:value-of select="$node/@name"/></xsl:attribute>
		</xsl:element>
	</xsl:if>
</xsl:template>

<!--
	Génère la déclaration d'une variable $divid-[nom]-new
	utilisée pour nommer les "div" des fieldgroup vierges
-->
<xsl:template name="makenewdivid">
	<xsl:param name="node"/>
	<xsl:param name="nodename"/>
	<xsl:param name="name"/>

	<xsl:element name="xsl:variable">
		<xsl:attribute name="name">divid-<xsl:value-of select="$name"/>-new</xsl:attribute>
		<xsl:call-template name="makevalueof">
			<xsl:with-param name="node" select="$node/parent::*"/>
		</xsl:call-template>
		<xsl:element name="xsl:value-of">
			<xsl:attribute name="select">concat('<xsl:value-of select="$name"/>_',generate-id(<xsl:value-of select="$nodename"/>[1]),'_new')</xsl:attribute>
		</xsl:element>
	</xsl:element>
</xsl:template>

<!--
	Un bouton pour ouvrir ou fermer un div
-->
<xsl:template name="divbutton">
	<xsl:param name="action"/>
	<xsl:param name="name"/>
	<xsl:param name="suffix"/>

	<a>
		<xsl:element name="xsl:attribute">
			<xsl:attribute name="name">href</xsl:attribute>javascript:alter('<xsl:element name="xsl:value-of">
				<xsl:attribute name="select">$divid-<xsl:value-of select="$name"/><xsl:value-of select="$suffix"/></xsl:attribute></xsl:element>','<xsl:element name="xsl:value-of">
					<xsl:attribute name="select">$divid-<xsl:value-of select="$name"/><xsl:value-of select="$suffix"/></xsl:attribute></xsl:element>_button')</xsl:element>
		<img width="9" height="9" border="0">
			<xsl:attribute name="src">
				<xsl:choose>
					<xsl:when test="$action='open'">icones/plus.png</xsl:when>
					<xsl:otherwise>icones/moins.png</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:element name="xsl:attribute">
				<xsl:attribute name="name">id</xsl:attribute><xsl:element name="xsl:value-of">
					<xsl:attribute name="select">$divid-<xsl:value-of select="$name"/><xsl:value-of select="$suffix"/></xsl:attribute></xsl:element>_button</xsl:element>
		</img>
	</a>
</xsl:template>

<!--
	Barre d'icones pour ouvrir et fermer un fieldgroup
-->
<xsl:template name="showFieldGroupHeader">
	<xsl:param name="name"/>
	<xsl:param name="divpolicy"/>

	<xsl:call-template name="divbutton">
		<xsl:with-param name="action">
			<xsl:choose>
				<xsl:when test="$divpolicy='display:none'">open</xsl:when>
				<xsl:otherwise>close</xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
		<xsl:with-param name="name" select="$name"/>
	</xsl:call-template>
	&#160;
	<xsl:element name="xsl:value-of"><xsl:attribute name="select">$docType/fieldgroup[@name='<xsl:value-of select="$name"/>']</xsl:attribute></xsl:element>
</xsl:template>

<!--
	Barre d'icones pour ouvrir et fermer un fieldgroup vierge
-->
<xsl:template name="showFieldGroupAdder">
	<xsl:param name="name"/>
	<xsl:param name="divpolicy"/>

	<div class="fieldgroupplus">
	<xsl:element name="xsl:value-of"><xsl:attribute name="select">$messages[@id='page.saisie.ajouterunnouveaubloc']</xsl:attribute></xsl:element>&#160;
	<xsl:call-template name="divbutton">
		<xsl:with-param name="action">
			<xsl:choose>
				<xsl:when test="$divpolicy='display:none'">open</xsl:when>
				<xsl:otherwise>close</xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
		<xsl:with-param name="name" select="$name"/>
		<xsl:with-param name="suffix">-new</xsl:with-param>
	</xsl:call-template>
	</div>
</xsl:template>

<!--
	Barre d'icones pour ouvrir et fermer un div de field
-->
<xsl:template name="showFieldAdder">
	<xsl:param name="name"/>
	<xsl:param name="divpolicy"/>

	<div class="fieldgroupplus">
	<xsl:element name="xsl:value-of"><xsl:attribute name="select">$messages[@id='page.saisie.ajouterunenouvellevaleur']</xsl:attribute></xsl:element>&#160;
	<a>
		<xsl:element name="xsl:attribute">
			<xsl:attribute name="name">href</xsl:attribute>javascript:alter('<xsl:element name="xsl:value-of">
				<xsl:attribute name="select">$divid-<xsl:value-of select="$name"/>-new</xsl:attribute></xsl:element>','<xsl:element name="xsl:value-of">
					<xsl:attribute name="select">$divid-<xsl:value-of select="$name"/>-new</xsl:attribute></xsl:element>_button')</xsl:element>
		<img width="9" height="9" border="0">
			<xsl:attribute name="src">
				<xsl:choose>
					<xsl:when test="$divpolicy='display:none'">icones/plus.png</xsl:when>
					<xsl:otherwise>icones/moins.png</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:element name="xsl:attribute">
				<xsl:attribute name="name">id</xsl:attribute><xsl:element name="xsl:value-of">
					<xsl:attribute name="select">$divid-<xsl:value-of select="$name"/>-new</xsl:attribute></xsl:element>_button</xsl:element>
		</img>
	</a>
	</div>
</xsl:template>

<!--
	Template principal du fieldgroup
-->
<xsl:template match="fieldgroup">
	<xsl:param name="empty"/>
	<xsl:param name="docinfo"/>

	<xsl:variable name="path">
		<xsl:choose>
			<xsl:when test="@path"><xsl:value-of select="@path"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Par défaut les fieldgroups sont cachés -->
	<xsl:variable name="divpolicy">display:none</xsl:variable>

	<!-- The next line is to avoid empty fieldset -->
	<xsl:choose>
	<xsl:when test="count(field[not(@default)])!=0 or count(fieldgroup)!=0">
	<xsl:choose>
		<!-- Repeat is not allowed -->
		<xsl:when test="@repeat='no'">
			<xsl:element name="xsl:choose">
				<xsl:element name="xsl:when">
					<xsl:attribute name="test"><xsl:value-of select="$path"/></xsl:attribute>
					<tr>
						<td colspan="3">
							<xsl:call-template name="makedivid">
								<xsl:with-param name="empty" select="$empty"/>
								<xsl:with-param name="name" select="@name"/>
								<xsl:with-param name="node" select="."/>
								<xsl:with-param name="nodename" select="$path"/>
							</xsl:call-template>
							<div class="fieldgroupheader">
								<xsl:call-template name="showFieldGroupHeader">
									<xsl:with-param name="name" select="@name"/>
									<xsl:with-param name="divpolicy" select="$divpolicy"/>
								</xsl:call-template>

								<div class="fieldgroup" style="{$divpolicy}">
									<xsl:element name="xsl:attribute">
										<xsl:attribute name="name">id</xsl:attribute>
										<xsl:element name="xsl:value-of">
											<xsl:attribute name="select">$divid-<xsl:value-of select="@name"/></xsl:attribute>
										</xsl:element>
									</xsl:element>
									<xsl:element name="xsl:for-each">
										<xsl:attribute name="select"><xsl:value-of select="$path"/>[1]</xsl:attribute>
										<xsl:call-template name="customprefix">
											<xsl:with-param name="empty" select="$empty"/>
											<xsl:with-param name="name" select="@name"/>
										</xsl:call-template>

										<!-- Affiche le fieldgroup -->
										<xsl:call-template name="managefieldgroup">
											<xsl:with-param name="node" select="."/>
											<xsl:with-param name="docinfo" select="$docinfo"/>
											<xsl:with-param name="empty" select="$empty"/>
											<xsl:with-param name="new">no</xsl:with-param>
										</xsl:call-template>
									</xsl:element>
								</div>
							</div>
						</td>
					</tr>
				</xsl:element>
				<xsl:element name="xsl:otherwise">
					<tr>
						<td colspan="3">
							<xsl:call-template name="makedivid">
								<xsl:with-param name="empty" select="$empty"/>
								<xsl:with-param name="name" select="@name"/>
								<xsl:with-param name="node" select="."/>
								<xsl:with-param name="nodename" select="$path"/>
							</xsl:call-template>
							<div class="fieldgroupheader">
								<xsl:call-template name="showFieldGroupHeader">
									<xsl:with-param name="name" select="@name"/>
									<xsl:with-param name="divpolicy" select="$divpolicy"/>
								</xsl:call-template>

								<div class="fieldgroup" style="{$divpolicy}">
									<xsl:element name="xsl:attribute">
										<xsl:attribute name="name">id</xsl:attribute>
										<xsl:element name="xsl:value-of">
											<xsl:attribute name="select">$divid-<xsl:value-of select="@name"/></xsl:attribute>
										</xsl:element>
									</xsl:element>
									<xsl:call-template name="customprefix">
										<xsl:with-param name="empty" select="'yes'"/>
										<xsl:with-param name="name" select="@name"/>
									</xsl:call-template>

									<!-- Affiche le fieldgroup -->
									<xsl:call-template name="managefieldgroup">
										<xsl:with-param name="node" select="."/>
										<xsl:with-param name="docinfo" select="$docinfo"/>
										<xsl:with-param name="empty">yes</xsl:with-param>
										<xsl:with-param name="new">yes</xsl:with-param>
									</xsl:call-template>
								</div>
							</div>
						</td>
					</tr>
				</xsl:element>
			</xsl:element>
		</xsl:when>

		<!-- Repeat is possible -->
		<xsl:otherwise>
			<tr>
				<td colspan="3">
					<xsl:call-template name="makedivid">
						<xsl:with-param name="empty" select="$empty"/>
						<xsl:with-param name="name" select="@name"/>
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="nodename" select="$path"/>
					</xsl:call-template>
					<div class="fieldgroupheader">
						<xsl:call-template name="showFieldGroupHeader">
							<xsl:with-param name="name" select="@name"/>
							<xsl:with-param name="divpolicy" select="$divpolicy"/>
						</xsl:call-template>
						<div class="fieldgroup" style="{$divpolicy}">
							<xsl:element name="xsl:attribute">
								<xsl:attribute name="name">id</xsl:attribute>
								<xsl:element name="xsl:value-of">
									<xsl:attribute name="select">$divid-<xsl:value-of select="@name"/></xsl:attribute>
								</xsl:element>
							</xsl:element>
							<xsl:element name="xsl:for-each">
								<xsl:attribute name="select"><xsl:value-of select="$path"/></xsl:attribute>
								<xsl:call-template name="customprefix">
									<xsl:with-param name="empty" select="$empty"/>
									<xsl:with-param name="name" select="@name"/>
								</xsl:call-template>

								<!-- Affiche le fieldgroup -->
								<xsl:call-template name="managefieldgroup">
									<xsl:with-param name="node" select="."/>
									<xsl:with-param name="docinfo" select="$docinfo"/>
									<xsl:with-param name="empty" select="$empty"/>
									<xsl:with-param name="new">no</xsl:with-param>
								</xsl:call-template>
							</xsl:element>

							<xsl:call-template name="makenewdivid">
								<xsl:with-param name="name" select="@name"/>
								<xsl:with-param name="node" select="."/>
								<xsl:with-param name="nodename" select="$path"/>
							</xsl:call-template>

							<xsl:element name="xsl:if">
								<xsl:attribute name="test">count(<xsl:value-of select="$path"/>)!=0</xsl:attribute>

								<xsl:call-template name="showFieldGroupAdder">
									<xsl:with-param name="name" select="@name"/>
									<xsl:with-param name="divpolicy" select="$divpolicy"/>
								</xsl:call-template>
							</xsl:element>

							<div class="fieldgroup" style="{$divpolicy}">
								<xsl:element name="xsl:attribute">
									<xsl:attribute name="name">id</xsl:attribute>
									<xsl:element name="xsl:value-of">
										<xsl:attribute name="select">$divid-<xsl:value-of select="@name"/>-new</xsl:attribute>
									</xsl:element>
								</xsl:element>
								<xsl:element name="xsl:attribute">
									<xsl:attribute name="name">style</xsl:attribute>
									<xsl:element name="xsl:choose">
										<xsl:element name="xsl:when">
											<xsl:attribute name="test">count(<xsl:value-of select="$path"/>)!=0</xsl:attribute>display:none</xsl:element>
										<xsl:element name="xsl:otherwise">display:block</xsl:element>
									</xsl:element>
								</xsl:element>
								<xsl:call-template name="customprefix">
									<xsl:with-param name="empty" select="'yes'"/>
									<xsl:with-param name="name" select="@name"/>
								</xsl:call-template>

								<!-- Affiche le fieldgroup -->
								<xsl:call-template name="managefieldgroup">
									<xsl:with-param name="node" select="."/>
									<xsl:with-param name="docinfo" select="$docinfo"/>
									<xsl:with-param name="empty">yes</xsl:with-param>
									<xsl:with-param name="new">yes</xsl:with-param>
								</xsl:call-template>
							</div>
						</div>
					</div>
				</td>
			</tr>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:when>
	<!-- for empty fieldgroup tagging  -->
	<xsl:otherwise>
		<xsl:variable name="fgp">
			<xsl:call-template name="computeAbsolutePath">
				<xsl:with-param name="node" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="computePrefix2">
			<xsl:with-param name="value" select="."/>
		</xsl:call-template>
		<xsl:element name="xsl:call-template">
			<xsl:attribute name="name">fieldgroupfooter</xsl:attribute>
			<xsl:element name="xsl:with-param">
				<xsl:attribute name="name">withoutdeletecheck</xsl:attribute>
				<xsl:attribute name="select">'yes'</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:with-param">
				<xsl:attribute name="name">gprefix</xsl:attribute>
				<xsl:attribute name="select">$gprefix</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:with-param">
				<xsl:attribute name="name">name</xsl:attribute><xsl:value-of select="@name"/></xsl:element>
			<xsl:element name="xsl:with-param">
				<xsl:attribute name="name">value</xsl:attribute>
				<xsl:attribute name="select"><xsl:value-of select="$fgp"/></xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Tous les traitements relatifs au fieldgroup -->
<xsl:template name="managefieldgroup">
	<xsl:param name="node"/>
	<xsl:param name="docinfo"/>
	<xsl:param name="new"/>
	<xsl:param name="empty"/>

	<fieldset class="block">
		<table>
			<xsl:apply-templates select="$node/field[not(@default)]|$node/fieldgroup">
				<xsl:with-param name="empty" select="$empty"/>
				<xsl:with-param name="docinfo" select="$docinfo"/>
			</xsl:apply-templates>

			<xsl:if test="$new='yes'">
				<xsl:call-template name="computePrefix">
					<xsl:with-param name="value" select="$node"/>
				</xsl:call-template>
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name">fieldgroupfooter</xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">withoutdeletecheck</xsl:attribute>
						<xsl:attribute name="select">'yes'</xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">gprefix</xsl:attribute>
						<xsl:attribute name="select">$gprefix</xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">name</xsl:attribute><xsl:value-of select="$node/@name"/></xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">value</xsl:attribute>
						<xsl:attribute name="select">.</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</table>
		<xsl:if test="$new='no'">
			<div align="right">
				<xsl:call-template name="computePrefix">
					<xsl:with-param name="value" select="$node"/>
				</xsl:call-template>
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name">fieldgroupfooter</xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">gprefix</xsl:attribute>
						<xsl:attribute name="select">$gprefix</xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">name</xsl:attribute><xsl:value-of select="$node/@name"/></xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">value</xsl:attribute>
						<xsl:attribute name="select">.</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</div>
		</xsl:if>
	</fieldset>
</xsl:template>

<!-- Template sur le field -->
<xsl:template match="field">
	<xsl:param name="docinfo"/>
	<xsl:call-template name="managefield">
		<xsl:with-param name="value" select="."/>
		<xsl:with-param name="docinfo" select="$docinfo"/>
	</xsl:call-template>
</xsl:template>

<!-- 
	Génére la variable $gprefix qui donne le préfixe à utiliser pour
	les noms des éléments du formulaire de saisie
-->
<xsl:template name="computePrefix">
	<xsl:param name="value"/>
	<xsl:element name="xsl:variable">
		<xsl:attribute name="name">gprefix</xsl:attribute><xsl:call-template name="concatPrefix"><xsl:with-param name="value" select="$value"/></xsl:call-template></xsl:element>
</xsl:template>

<xsl:template name="concatPrefix">
	<xsl:param name="value"/>
	<xsl:if test="name($value/parent::*)='fieldgroup'"><xsl:call-template name="concatPrefix"><xsl:with-param name="value" select="$value/parent::*"/></xsl:call-template></xsl:if><xsl:if test="name($value)='fieldgroup'"><xsl:element name="xsl:value-of"><xsl:attribute name="select"><xsl:value-of select="concat('$gpref-',$value/@name)"/></xsl:attribute></xsl:element></xsl:if>
</xsl:template>

<!-- Compute prefix 2 -->
<xsl:template name="customprefixtest">
	<xsl:param name="value"/>

	<xsl:variable name="path">
		<xsl:call-template name="computeAbsolutePath">
			<xsl:with-param name="node" select="$value"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:element name="xsl:variable">
		<xsl:attribute name="name">gpref-<xsl:value-of select="$value/@name"/></xsl:attribute>
		<xsl:element name="xsl:choose">
			<xsl:element name="xsl:when">
				<xsl:attribute name="test"><xsl:value-of select="$path"/></xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">concat(generate-id(<xsl:value-of select="$path"/>),'_')</xsl:attribute></xsl:element></xsl:element>
			<xsl:element name="xsl:otherwise">empty_</xsl:element>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template name="customprefixrec">
	<xsl:param name="value"/>

	<xsl:if test="name($value/parent::*)='fieldgroup'">
		<xsl:call-template name="customprefixrec">
			<xsl:with-param name="value" select="$value/parent::*"/>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="name($value)='fieldgroup'">
		<xsl:call-template name="customprefixtest">
			<xsl:with-param name="value" select="$value"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template name="computePrefix2">
	<xsl:param name="value"/>

	<xsl:call-template name="customprefixrec">
		<xsl:with-param name="value" select="$value"/>
	</xsl:call-template>
	<xsl:call-template name="computePrefix">
		<xsl:with-param name="value" select="$value"/>
	</xsl:call-template>
</xsl:template>

<!-- Compute absolute path -->
<xsl:template name="computeAbsolutePath">
	<xsl:param name="node"/><xsl:if test="name($node/parent::*)='fieldgroup'"><xsl:call-template name="computeAbsolutePath"><xsl:with-param name="node" select="$node/parent::*"/></xsl:call-template>/</xsl:if><xsl:choose><xsl:when test="$node/@path"><xsl:value-of select="$node/@path"/></xsl:when><xsl:otherwise><xsl:value-of select="$node/@name"/></xsl:otherwise></xsl:choose>
</xsl:template>

<!-- Manage field -->
<xsl:template name="managefield">
	<xsl:param name="value"/>
	<xsl:param name="docinfo"/>
	<xsl:param name="absolute">no</xsl:param>

	<xsl:variable name="fieldPath">
		<xsl:choose>
			<xsl:when test="$absolute='yes'"><xsl:call-template name="computeAbsolutePath"><xsl:with-param name="node" select="$value"/></xsl:call-template></xsl:when>
			<xsl:when test="$value/@path"><xsl:value-of select="$value/@path"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$value/@name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="fieldType">
		<xsl:choose>
			<xsl:when test="not(@type)">string</xsl:when>
			<xsl:when test="$value/@type='image'">attach</xsl:when>
			<xsl:otherwise><xsl:value-of select="$value/@type"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<tr>
	<xsl:element name="xsl:call-template">
		<xsl:attribute name="name">label</xsl:attribute>
		<xsl:element name="xsl:with-param">
			<xsl:attribute name="name">field</xsl:attribute>
			<xsl:value-of select="$value/@name"/>
		</xsl:element>
	</xsl:element>

	<xsl:choose>
		<xsl:when test="$absolute='no'">
			<xsl:call-template name="computePrefix">
				<xsl:with-param name="value" select="$value"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="computePrefix2">
				<xsl:with-param name="value" select="$value"/>
			</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	<xsl:choose>

		<!-- Document attaché -->
		<xsl:when test="$fieldType='attach'">

			<xsl:variable name="mode">
				<xsl:choose>
					<xsl:when test="count($docinfo/on[@field=$value/@name and @mode]) = 1"><xsl:value-of select="$docinfo/on[@field=$value/@name and @mode]/@mode"/></xsl:when>
					<xsl:otherwise>link</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<td colspan="2" class="saisie">
				<xsl:element name="xsl:for-each">
					<xsl:attribute name="select"><xsl:value-of select="$fieldPath"/></xsl:attribute>
					<xsl:element name="xsl:call-template">
						<xsl:attribute name="name">attach</xsl:attribute>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">gprefix</xsl:attribute>
							<xsl:attribute name="select">$gprefix</xsl:attribute>
						</xsl:element>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">field</xsl:attribute>
							<xsl:value-of select="$value/@name"/>
						</xsl:element>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">value</xsl:attribute>
							<xsl:attribute name="select">.</xsl:attribute>
						</xsl:element>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">mode</xsl:attribute>
							<xsl:value-of select="$mode"/>
						</xsl:element>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">docid</xsl:attribute>
							<xsl:attribute name="select">$urlparameter[@name='id']/@value</xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name">attach</xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">gprefix</xsl:attribute>
						<xsl:attribute name="select">$gprefix</xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">field</xsl:attribute>
						<xsl:value-of select="$value/@name"/>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">mode</xsl:attribute>
						<xsl:value-of select="$mode"/>
					</xsl:element>
				</xsl:element>
			</td>
		</xsl:when>

		<!-- Choice -->
		<xsl:when test="$fieldType = 'choice'">
			<xsl:element name="xsl:call-template">
				<xsl:attribute name="name">choice</xsl:attribute>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">gprefix</xsl:attribute>
					<xsl:attribute name="select">$gprefix</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">field</xsl:attribute>
					<xsl:value-of select="$value/@name"/>
				</xsl:element>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">value</xsl:attribute>
					<xsl:attribute name="select"><xsl:value-of select="$fieldPath"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">mode</xsl:attribute>
					<xsl:choose>
						<xsl:when test="count($docinfo/on[@field=$value/@name and @mode]) = 1"><xsl:value-of select="$docinfo/on[@field=$value/@name and @mode]/@mode"/></xsl:when>
						<xsl:when test="$value/@repeat='no'">combo</xsl:when>
						<xsl:otherwise>Mcombo</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<!-- Liste externe -->
				<xsl:if test="$value/@list">
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">list</xsl:attribute>
						<xsl:value-of select="$value/@list"/>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">doclang</xsl:attribute>
						<xsl:attribute name="select">$documentLang</xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">sort</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$docinfo/on[@field=$value/@name]/@sort='true'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:when>

		<!-- Relation -->
		<xsl:when test="$fieldType = 'relation'">
			<xsl:element name="xsl:call-template">
				<xsl:attribute name="name">relation</xsl:attribute>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">gprefix</xsl:attribute>
					<xsl:attribute name="select">$gprefix</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">field</xsl:attribute>
					<xsl:value-of select="$value/@name"/>
				</xsl:element>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">value</xsl:attribute>
					<xsl:attribute name="select"><xsl:value-of select="$fieldPath"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">mode</xsl:attribute>
					<xsl:choose>
						<xsl:when test="count($docinfo/on[@field=$value/@name and @mode]) = 1"><xsl:value-of select="$docinfo/on[@field=$value/@name and @mode]/@mode"/></xsl:when>
						<xsl:when test="$value/@repeat='no'">combo</xsl:when>
						<xsl:otherwise>Mcombo</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:when>

		<!-- Autres -->
		<xsl:otherwise>

			<td colspan="2" class="saisie">
			<!-- si pas de tag -->

			<xsl:element name="xsl:choose">
			<xsl:element name="xsl:when">
				<xsl:attribute name="test">count(<xsl:value-of select="$fieldPath"/>) = 0</xsl:attribute>
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name"><xsl:value-of select="$fieldType"/></xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">gprefix</xsl:attribute>
						<xsl:attribute name="select">$gprefix</xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">field</xsl:attribute>
						<xsl:value-of select="$value/@name"/>
					</xsl:element>

					<!-- Gestion des valeurs par défaut -->
					<xsl:if test="$value/@value">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">value</xsl:attribute>
							<xsl:call-template name="defaultValue">
								<xsl:with-param name="value" select="$value"/>
							</xsl:call-template>
						</xsl:element>
					</xsl:if> 

					<!-- Champ en lecture seule -->
					<xsl:if test="$value/@readonly='true'">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">readonly</xsl:attribute>true</xsl:element>
					</xsl:if>

					<!-- Champ multilingue -->
					<xsl:if test="$value/@lang='multi'">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">multilingual</xsl:attribute>yes</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:element>

			<!-- sinon... -->
			<xsl:element name="xsl:otherwise">
			<xsl:element name="xsl:for-each">

				<!-- boucle -->
				<xsl:attribute name="select"><xsl:value-of select="$fieldPath"/></xsl:attribute>
				<xsl:element name="xsl:if">
					<xsl:attribute name="test">position() != 1</xsl:attribute>
					<br/>
				</xsl:element>
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name"><xsl:value-of select="$fieldType"/></xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">gprefix</xsl:attribute>
						<xsl:attribute name="select">$gprefix</xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">field</xsl:attribute>
						<xsl:value-of select="$value/@name"/>
					</xsl:element>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">value</xsl:attribute>
						<xsl:attribute name="select">.</xsl:attribute>
					</xsl:element>
					<xsl:if test="$value/@readonly='true'">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">readonly</xsl:attribute>true</xsl:element>
					</xsl:if>
					<xsl:if test="$value/@lang='multi'">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">multilingual</xsl:attribute>yes</xsl:element>
					</xsl:if>
				</xsl:element>
				</xsl:element>

				<!--
					Nouvelle valeur seulement si :

					* Le path du champ n'est pas un attribut
					* Le champ n'est pas celui par défaut
					* Le champ est répétable (on n'a précisé explicitement qu'il ne l'était pas)
				-->
				<xsl:if test="not($value/@default) and not($value/@repeat='no') and not(contains($value/@path,'@'))">
					<br/>
					<xsl:element name="xsl:variable">
						<xsl:attribute name="name">divid-<xsl:value-of select="$value/@name"/>-new</xsl:attribute>
						<xsl:element name="xsl:value-of">
							<xsl:attribute name="select">$gprefix</xsl:attribute>
						</xsl:element>
						<xsl:value-of select="$value/@name"/>
					</xsl:element>
					<xsl:call-template name="showFieldAdder">
						<xsl:with-param name="name" select="$value/@name"/>
						<xsl:with-param name="divpolicy" select="'display:none'"/>
					</xsl:call-template>
					<div class="fieldgroup" style="display:none">
						<xsl:attribute name="id">{$divid-<xsl:value-of select="$value/@name"/>-new}</xsl:attribute>
						<fieldset class="block">
							<xsl:element name="xsl:call-template">
								<xsl:attribute name="name"><xsl:value-of select="$fieldType"/></xsl:attribute>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">gprefix</xsl:attribute>
									<xsl:attribute name="select">$gprefix</xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:with-param">
									<xsl:attribute name="name">field</xsl:attribute>
									<xsl:value-of select="$value/@name"/>
								</xsl:element>

								<!-- Gestion des valeurs par défaut -->
								<xsl:if test="$value/@value">
									<xsl:element name="xsl:with-param">
										<xsl:attribute name="name">value</xsl:attribute>
										<xsl:call-template name="defaultValue">
											<xsl:with-param name="value" select="$value"/>
										</xsl:call-template>
									</xsl:element>
								</xsl:if> 

								<!-- Champ en lecture seule -->
								<xsl:if test="$value/@readonly='true'">
									<xsl:element name="xsl:with-param">
										<xsl:attribute name="name">readonly</xsl:attribute>true</xsl:element>
								</xsl:if>

								<!-- Champ multilingue -->
								<xsl:if test="$value/@lang='multi'">
									<xsl:element name="xsl:with-param">
										<xsl:attribute name="name">multilingual</xsl:attribute>yes</xsl:element>
								</xsl:if>
							</xsl:element>
						</fieldset>
					</div>
				</xsl:if>
			</xsl:element>
			</xsl:element>
			</td>
		</xsl:otherwise>
	</xsl:choose>
	</tr>
</xsl:template>

<!-- Computes default value -->
<xsl:template name="defaultValue">
	<xsl:param name="value"/>

	<xsl:choose>
		<xsl:when test="$value/@value = '${sdx:user}'">
			<xsl:element name="xsl:choose">
				<!-- On a le nom et le prenom -->
				<xsl:element name="xsl:when">
					<xsl:attribute name="test">$currentuser/@firstname!='' and $currentuser/@lastname!=''</xsl:attribute>
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">concat($currentuser/@firstname,' ',$currentuser/@lastname,' (',$currentuser/@id,')')</xsl:attribute>
					</xsl:element>
				</xsl:element>
				<!-- On n'a que le prenom -->
				<xsl:element name="xsl:when">
					<xsl:attribute name="test">$currentuser/@firstname!=''</xsl:attribute>
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">concat($currentuser/@firstname,' (',$currentuser/@id,')')</xsl:attribute>
					</xsl:element>
				</xsl:element>
				<!-- On n'a que le nom -->
				<xsl:element name="xsl:when">
					<xsl:attribute name="test">$currentuser/@lastname!=''</xsl:attribute>
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">concat($currentuser/@lastname,' (',$currentuser/@id,')')</xsl:attribute>
					</xsl:element>
				</xsl:element>
				<!-- On n'a que le login -->
				<xsl:element name="xsl:otherwise">
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">$currentuser/@id</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise><xsl:value-of select="$value/@value"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

