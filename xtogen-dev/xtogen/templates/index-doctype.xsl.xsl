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
	xmlns:xtg="http://xtogen.tech.fr"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="saxon xtg">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="dest_dir">.</xsl:param>
<xsl:param name="display_config_file"/>
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
	<xsl:variable name="output" select="concat($dest_dir,'/index-',@id,'.xsl')"/>
	<saxon:output href="{$output}">
	<xsl:variable name="currentid" select="@id"/>
	<xsl:variable name="docinfo" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes/documenttype[@id=$currentid]"/>
	<xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
		<xsl:copy-of select="document('index-doctype.xsl.xsl')//namespace::*[.='http://www.culture.gouv.fr/ns/sdx/sdx']"/>
		<xsl:copy-of select="document('index-doctype.xsl.xsl')//namespace::*[.='http://xtogen.tech.fr']"/>
		<xsl:attribute name="version">1.0</xsl:attribute>
		<xsl:attribute name="exclude-result-prefixes">xsl</xsl:attribute>
		<xsl:element name="xsl:output">
			<xsl:attribute name="method">xml</xsl:attribute>
			<xsl:attribute name="indent">yes</xsl:attribute>
			<xsl:attribute name="encoding">UTF-8</xsl:attribute>
		</xsl:element>
		<xsl:element name="xsl:param">
			<xsl:attribute name="name">rootpath</xsl:attribute>
			<xsl:text>..</xsl:text>
		</xsl:element>

		<xsl:text>
		

	</xsl:text>
		<xsl:comment> Les documents de listes </xsl:comment>
		<xsl:variable name="lists" select="fields/descendant-or-self::field[@type='choice' and @list]"/>
		<xsl:for-each select="$lists[not(@list=following-sibling::field/@list)]">
				<xsl:variable name="list" select="@list"/>
				<xsl:for-each select="/application/languages/lang">
					<xsl:element name="xsl:variable">
						<xsl:attribute name="name"><xsl:value-of select="$list"/>_<xsl:value-of select="@id"/></xsl:attribute>
						<xsl:attribute name="select">document(concat($rootpath,'<xsl:value-of select="concat('/xsl/lang/liste/',@id,'/',@id,'_',$list,'.xml')"/>'))/list</xsl:attribute>
					</xsl:element>
				</xsl:for-each>
				<xsl:if test="@match">
					<xsl:for-each select="/application/languages/lang">
						<xsl:variable name="firstLang" select="@id"/>
						<xsl:element name="xsl:variable">
							<xsl:attribute name="name">match_<xsl:value-of select="$list"/>_<xsl:value-of select="$firstLang"/></xsl:attribute>
							<xsl:attribute name="select">document('<xsl:value-of select="concat('../xsl/lang/liste/',$firstLang,'/match_',$firstLang,'_',$list,'.xml')"/>')/matches</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
		</xsl:for-each>

		<xsl:text>

	</xsl:text>
		<xsl:comment> langue par default </xsl:comment>
		<xsl:element name="xsl:variable">
			<xsl:attribute name="name">defaultlang</xsl:attribute>
			<xsl:attribute name="select">'<xsl:value-of select="/application/languages/lang[@default='true']/@id"/>'</xsl:attribute>
		</xsl:element>
		<xsl:if test="count(fields/descendant-or-self::field[@type='image' or @type='attach']) &gt; 0">
		<xsl:text>

	</xsl:text>
		<xsl:comment> La liste des types mime connus </xsl:comment>
		<xsl:element name="xsl:variable">
			<xsl:attribute name="name">mimes</xsl:attribute>
			<xsl:attribute name="select">document('mime.xml')/files</xsl:attribute>
		</xsl:element>

<xsl:text>

	</xsl:text>
		<xsl:comment> Un template pour extraire l'extension d'un fichier </xsl:comment>
		<xsl:element name="xsl:template">
			<xsl:attribute name="name">findextension</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">file</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:choose">
				<xsl:element name="xsl:when">
					<xsl:attribute name="test">contains($file,'.')</xsl:attribute>
					<xsl:element name="xsl:call-template">
						<xsl:attribute name="name">findextension</xsl:attribute>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">file</xsl:attribute>
							<xsl:attribute name="select">substring-after($file,'.')</xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="xsl:otherwise">
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">$file</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>

		</xsl:if>

<xsl:text>

	</xsl:text>
		<xsl:comment> Document <xsl:value-of select="@id"/> </xsl:comment>

		<xsl:element name="xsl:template">
			<xsl:attribute name="match">/<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:element name="sdx:document">
			<xsl:element name="xsl:choose">
				<xsl:element name="xsl:when">
					<xsl:attribute name="test">@id</xsl:attribute>
					<xsl:element name="xsl:attribute">
						<xsl:attribute name="name">id</xsl:attribute>
						<xsl:element name="xsl:value-of">
							<xsl:attribute name="select">@id</xsl:attribute>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="xsl:otherwise">
					<xsl:element name="xsl:attribute">
						<xsl:attribute name="name">generateId</xsl:attribute>true</xsl:element>
				</xsl:element>
			</xsl:element>
				<xsl:text>

		</xsl:text>
				<xsl:comment> Langue du document </xsl:comment>
				<xsl:element name="xsl:variable">
					<xsl:attribute name="name">doclang</xsl:attribute>
					<xsl:element name="xsl:choose">
						<xsl:element name="xsl:when">
							<xsl:attribute name="test">@xml:lang</xsl:attribute>
							<xsl:element name="xsl:choose">
								<xsl:for-each select="//languages/lang">
									<xsl:element name="xsl:when">
										<xsl:attribute name="test">@xml:lang = '<xsl:value-of select="@id"/>'</xsl:attribute>
										<xsl:element name="xsl:value-of">
											<xsl:attribute name="select">@xml:lang</xsl:attribute>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
								<xsl:element name="xsl:otherwise">
									<xsl:element name="xsl:value-of">
										<xsl:attribute name="select">$defaultlang</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
						<xsl:element name="xsl:otherwise">
							<xsl:element name="xsl:value-of">
								<xsl:attribute name="select">$defaultlang</xsl:attribute>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="xsl:if">
					<xsl:attribute name="test">
						<xsl:text/>@xml:lang<xsl:text/>
						<xsl:for-each select="//languages/lang">
							<xsl:text/> and @xml:lang != '<xsl:value-of select="@id"/>'<xsl:text/>
						</xsl:for-each>
					</xsl:attribute>
					<xsl:element name="xsl:message">Document <xsl:element name="xsl:value-of">
						<xsl:attribute name="select">@id</xsl:attribute>
						</xsl:element> : langue "<xsl:element name="xsl:value-of">
							<xsl:attribute name="select">@xml:lang</xsl:attribute>
							</xsl:element>" non reconnue, j'utilise "<xsl:element name="xsl:value-of">
								<xsl:attribute name="select">$defaultlang</xsl:attribute>
								</xsl:element>"</xsl:element>
				</xsl:element>
<xsl:text>

		</xsl:text>
				
				<xsl:comment> Champs par défaut </xsl:comment>
				<xsl:for-each select="//languages/lang">
					<xsl:variable name="lg" select="translate(@id,'-','_')"/>
					<sdx:field code="xtgpleintexte_{$lg}">
						<xsl:element name="xsl:apply-templates">
							<xsl:attribute name="mode">fulltext</xsl:attribute>
							<xsl:element name="xsl:with-param">
								<xsl:attribute name="name">doclang</xsl:attribute>
								<xsl:attribute name="select">$doclang</xsl:attribute>
							</xsl:element>
							<xsl:element name="xsl:with-param">
								<xsl:attribute name="name">fulltextlang</xsl:attribute>
								<xsl:attribute name="select">'<xsl:value-of select="@id"/>'</xsl:attribute>
							</xsl:element>
						</xsl:element>
					</sdx:field>
				</xsl:for-each>
				<sdx:field code="xtgdoclang">
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">$doclang</xsl:attribute>
					</xsl:element>
				</sdx:field>
				<xsl:text>

		</xsl:text>
				<xsl:comment> Traitement des champs </xsl:comment>

				<xsl:apply-templates select="fields/field|fields/fieldgroup" mode="apply"/>
        	</xsl:element>
        </xsl:element>
		<xsl:text>
	</xsl:text>

		<xsl:apply-templates select="fields/field|fields/fieldgroup" mode="match">
			<xsl:with-param name="docinfo" select="$docinfo"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="fields/field|fields/fieldgroup" mode="plein-texte"/>
		<xsl:text>

	</xsl:text>
		<xsl:comment> On n'indexe pas les informations de versioning </xsl:comment>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match">xtg:version</xsl:attribute>
			<xsl:attribute name="mode">fulltext</xsl:attribute>
		</xsl:element>
		<xsl:text>

	</xsl:text>
		<xsl:comment> Template pour l'indexation plein-texte </xsl:comment>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match">*</xsl:attribute>
			<xsl:attribute name="mode">fulltext</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">doclang</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">fulltextlang</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:apply-templates">
				<xsl:attribute name="select">@*|*|text()</xsl:attribute>
				<xsl:attribute name="mode">fulltext</xsl:attribute>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">doclang</xsl:attribute>
					<xsl:attribute name="select">$doclang</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">fulltextlang</xsl:attribute>
					<xsl:attribute name="select">$fulltextlang</xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:element>

		<xsl:text>

	</xsl:text>
		<xsl:comment> Indexation plein-texte des attributs </xsl:comment>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match">@*</xsl:attribute>
			<xsl:attribute name="mode">fulltext</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">doclang</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">fulltextlang</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:if">
				<xsl:attribute name="test">$doclang=$fulltextlang</xsl:attribute>

				<xsl:element name="xsl:value-of">
					<xsl:attribute name="select">normalize-space(.)</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:if">
					<xsl:attribute name="test">normalize-space(.) != ''</xsl:attribute>
					<xsl:element name="xsl:text"><xsl:text> </xsl:text></xsl:element>
				</xsl:element>
			</xsl:element>
	    </xsl:element>

		<xsl:text>

	</xsl:text>
		<xsl:comment> Indexation plein-texte des noeuds texte </xsl:comment>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match">text()</xsl:attribute>
			<xsl:attribute name="mode">fulltext</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">doclang</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">fulltextlang</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:if">
				<xsl:attribute name="test">$doclang=$fulltextlang</xsl:attribute>

				<xsl:element name="xsl:value-of">
					<xsl:attribute name="select">normalize-space(.)</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:if">
					<xsl:attribute name="test">normalize-space(.) != ''</xsl:attribute>
					<xsl:element name="xsl:text"><xsl:text> </xsl:text></xsl:element>
				</xsl:element>
			</xsl:element>
	    </xsl:element>
	</xsl:element>
	</saxon:output>
</xsl:template>

<xsl:template match="fieldgroup" mode="apply">
	<xsl:element name="xsl:apply-templates">
		<xsl:attribute name="select">
			<xsl:call-template name="computeFullPath">
				<xsl:with-param name="field" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:element>
	<xsl:apply-templates select="fieldgroup|field" mode="apply"/>
</xsl:template>

<xsl:template match="field" mode="apply">
	<xsl:element name="xsl:apply-templates">
		<xsl:attribute name="select">
			<xsl:call-template name="computeFullPath">
				<xsl:with-param name="field" select="."/>
			</xsl:call-template>
		</xsl:attribute>
		<xsl:if test="@type='choice' and @list">
			<xsl:element name="xsl:with-param">
				<xsl:attribute name="name">doclang</xsl:attribute>
				<xsl:attribute name="select">$doclang</xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:element>
</xsl:template>

<!-- Pour traiter les champs "texte" -->
<xsl:template name="textMatch">
	<xsl:param name="field"/>
	<xsl:param name="path"/>

	<xsl:choose>
		<xsl:when test="$field/@lang='multi'">
			<xsl:element name="xsl:choose">
				<xsl:for-each select="//languages/lang">
					<xsl:element name="xsl:when">
						<xsl:attribute name="test">@xml:lang='<xsl:value-of select="@id"/>'</xsl:attribute>
						<xsl:variable name="lg" select="translate(@id,'-','_')"/>
						<sdx:field code="{$xtg_wordprefix}{$field/@name}_{$lg}">
							<xsl:element name="xsl:value-of">
								<xsl:attribute name="select">normalize-space(<xsl:value-of select="$path"/>)</xsl:attribute>
							</xsl:element>
						</sdx:field>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<sdx:field code="{$xtg_wordprefix}{$field/@name}">
				<xsl:element name="xsl:value-of">
					<xsl:attribute name="select">normalize-space(<xsl:value-of select="$path"/>)</xsl:attribute>
				</xsl:element>
			</sdx:field>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="fieldgroup" mode="match">
	<xsl:param name="docinfo"/>

<xsl:text>

   </xsl:text>
<xsl:comment> Groupe de champs <xsl:value-of select="@name"/> </xsl:comment>
	<xsl:element name="xsl:template">
		<xsl:attribute name="match">
			<xsl:call-template name="computeFullPath">
				<xsl:with-param name="field" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:element>

	<xsl:apply-templates select="field|fieldgroup" mode="match">
		<xsl:with-param name="docinfo" select="$docinfo"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="field" mode="match">
<xsl:param name="docinfo"/>

<xsl:text>

   </xsl:text>
<xsl:comment> Champ <xsl:value-of select="@name"/> </xsl:comment>
	<xsl:element name="xsl:template">
		<xsl:variable name="fieldpath">
			<xsl:call-template name="computeFullPath">
				<xsl:with-param name="field" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:attribute name="match"><xsl:value-of select="$fieldpath"/></xsl:attribute>

		<!-- Si c'est le champ par défaut -->
		<xsl:if test="@default">
			<sdx:field code="xtgtitle">
				<xsl:element name="xsl:value-of">
					<xsl:attribute name="select">normalize-space(.)</xsl:attribute>
				</xsl:element>
			</sdx:field>
		</xsl:if>

		<xsl:choose>
			<!-- Pour les documents attachés -->	
			<xsl:when test="@type='image' or @type='attach'">

				<!-- Pour conserver les infos pour la navigation -->
				<sdx:field code="{@name}">
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">concat(@thn,'||',@label,'||',.)</xsl:attribute>
					</xsl:element>
				</sdx:field>
				
				<!-- Pour le thumbnail -->
				<xsl:element name="xsl:if">
					<xsl:attribute name="test">@thn</xsl:attribute>

					<!-- attacher le fichier -->
					<xsl:element name="xsl:element">
						<xsl:attribute name="name">sdx:attachedDocument</xsl:attribute>
						<xsl:element name="xsl:attribute">
							<xsl:attribute name="name">id</xsl:attribute>
							<xsl:element name="xsl:value-of">
								<xsl:attribute name="select">@thn</xsl:attribute>
							</xsl:element>
						</xsl:element>
							<xsl:element name="xsl:attribute">
							<xsl:attribute name="name">url</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">@thn</xsl:attribute></xsl:element></xsl:element>
						<xsl:element name="xsl:choose">
	<xsl:text>
				</xsl:text>
							<xsl:comment> Si le mime-type est precise, on le prend tel quel </xsl:comment>
							<xsl:element name="xsl:when">
								<xsl:attribute name="test">@mime-type</xsl:attribute>
								<xsl:element name="xsl:attribute">
									<xsl:attribute name="name">mimetype</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">@mime-type</xsl:attribute></xsl:element></xsl:element></xsl:element>
							
							<xsl:element name="xsl:otherwise">
	<xsl:text>
					</xsl:text>
								<xsl:comment> sinon, on essaie de le determiner a partir de
									 l'extension du fichier </xsl:comment>
								<xsl:element name="xsl:variable">
									<xsl:attribute name="name">findext</xsl:attribute>
									<xsl:element name="xsl:call-template">
										<xsl:attribute name="name">findextension</xsl:attribute>
										<xsl:element name="xsl:with-param">
											<xsl:attribute name="name">file</xsl:attribute>
											<xsl:attribute name="select">@thn</xsl:attribute>
										</xsl:element>
									</xsl:element>
								</xsl:element>
								<xsl:element name="xsl:variable">
									<xsl:attribute name="name">ext</xsl:attribute>
									<xsl:attribute name="select">translate($findext,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')</xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:variable">
									<xsl:attribute name="name">mime</xsl:attribute>
									<xsl:attribute name="select">$mimes/file[@ext=$ext]</xsl:attribute>
								</xsl:element>
								<xsl:element name="xsl:choose">
									<xsl:element name="xsl:when">
										<xsl:attribute name="test">normalize-space($mime) != ''</xsl:attribute>
										<xsl:element name="xsl:attribute">
											<xsl:attribute name="name">mimetype</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">$mime</xsl:attribute></xsl:element></xsl:element>
									</xsl:element>
									<xsl:element name="xsl:otherwise">
										<xsl:element name="xsl:message">Document <xsl:element name="xsl:value-of"><xsl:attribute name="select">/<xsl:value-of select="../../@id"/>/@id</xsl:attribute></xsl:element> : extension non reconnue "<xsl:element name="xsl:value-of"><xsl:attribute name="select">$ext</xsl:attribute></xsl:element>" le fichier n'a pas de mime-type
										On utilise "application/octet-stream" comme mime-type par défaut</xsl:element>
										<xsl:element name="xsl:attribute">
											<xsl:attribute name="name">mimetype</xsl:attribute>application/octet-stream</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>

				<!-- Pour le document attaché proprement dit -->
				<xsl:element name="xsl:if">
					<xsl:attribute name="test">normalize-space(.) != ''</xsl:attribute>
				<xsl:element name="xsl:element">
					<xsl:attribute name="name">sdx:attachedDocument</xsl:attribute>
					<xsl:element name="xsl:attribute">
						<xsl:attribute name="name">id</xsl:attribute>
						<xsl:element name="xsl:value-of">
							<xsl:attribute name="select">.</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:element name="xsl:attribute">
						<xsl:attribute name="name">url</xsl:attribute>
						<xsl:element name="xsl:value-of"><xsl:attribute name="select">.</xsl:attribute></xsl:element>
					</xsl:element>
					<xsl:element name="xsl:choose">
<xsl:text>
			</xsl:text>
						<xsl:comment> Si le mime-type est precise, on le prend tel quel </xsl:comment>
						<xsl:element name="xsl:when">
							<xsl:attribute name="test">@mime-type</xsl:attribute>
							<xsl:element name="xsl:attribute">
								<xsl:attribute name="name">mimetype</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">@mime-type</xsl:attribute></xsl:element></xsl:element></xsl:element>
						
						<xsl:element name="xsl:otherwise">
<xsl:text>
				</xsl:text>
							<xsl:comment> sinon, on essaie de le determiner a partir de
								 l'extension du fichier </xsl:comment>
								<xsl:element name="xsl:variable">
									<xsl:attribute name="name">findext</xsl:attribute>
									<xsl:element name="xsl:call-template">
										<xsl:attribute name="name">findextension</xsl:attribute>
										<xsl:element name="xsl:with-param">
											<xsl:attribute name="name">file</xsl:attribute>
											<xsl:attribute name="select">.</xsl:attribute>
										</xsl:element>
									</xsl:element>
								</xsl:element>
								<xsl:element name="xsl:variable">
									<xsl:attribute name="name">ext</xsl:attribute>
									<xsl:attribute name="select">translate($findext,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')</xsl:attribute>
								</xsl:element>
							<xsl:element name="xsl:variable">
								<xsl:attribute name="name">mime</xsl:attribute>
								<xsl:attribute name="select">$mimes/file[@ext=$ext]</xsl:attribute>
							</xsl:element>
							<xsl:element name="xsl:choose">
								<xsl:element name="xsl:when">
									<xsl:attribute name="test">normalize-space($mime) != ''</xsl:attribute>
									<xsl:element name="xsl:attribute">
										<xsl:attribute name="name">mimetype</xsl:attribute><xsl:element name="xsl:value-of"><xsl:attribute name="select">$mime</xsl:attribute></xsl:element></xsl:element>
								</xsl:element>
								<xsl:element name="xsl:otherwise">
									<xsl:element name="xsl:message">Document <xsl:element name="xsl:value-of"><xsl:attribute name="select">/<xsl:value-of select="../../@id"/>/@id</xsl:attribute></xsl:element> : extension non reconnue "<xsl:element name="xsl:value-of"><xsl:attribute name="select">$ext</xsl:attribute></xsl:element>" le fichier n'a pas de mime-type
									On utilise "application/octet-stream" comme mime-type par défaut</xsl:element>
									<xsl:element name="xsl:attribute">
										<xsl:attribute name="name">mimetype</xsl:attribute>application/octet-stream</xsl:element>
								</xsl:element>
							</xsl:element>

						</xsl:element>
					</xsl:element>
				</xsl:element>
				</xsl:element>
			</xsl:when>

			<!-- Pour les listes de choix -->
			<xsl:when test="@type='choice' and @list">
				<xsl:variable name="list" select="@list"/>
				<xsl:element name="xsl:param">
					<xsl:attribute name="name">doclang</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:variable">
					<xsl:attribute name="name">fichierliste</xsl:attribute>
					<xsl:attribute name="select">concat('../xsl/lang/liste/',$doclang,'/',$doclang,'_<xsl:value-of select="$list"/>.xml')</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:variable">
					<xsl:attribute name="name"><xsl:value-of select="concat('list_',$list)"/></xsl:attribute>
					<xsl:attribute name="select">document($fichierliste)/list</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:variable">
					<xsl:attribute name="name">val</xsl:attribute>
					<xsl:attribute name="select">normalize-space(.)</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:variable">
					<xsl:attribute name="name">item</xsl:attribute>
					<xsl:attribute name="select">$list_<xsl:value-of select="$list"/>/item[text() = $val]</xsl:attribute>
				</xsl:element>
				<xsl:element name="xsl:choose">
				<xsl:element name="xsl:when">
					<xsl:attribute name="test">count($list_<xsl:value-of select="$list"/>/item) = 0</xsl:attribute>
<xsl:element name="xsl:message">Document <xsl:element name="xsl:value-of"><xsl:attribute name="select">/<xsl:value-of select="../../@id"/>/@id</xsl:attribute></xsl:element> : la liste <xsl:value-of select="@list"/> est vide ou introuvable !!!
	Fichier : <xsl:element name="xsl:value-of"><xsl:attribute name="select">$fichierliste</xsl:attribute></xsl:element></xsl:element>
				</xsl:element>
				<xsl:element name="xsl:otherwise">
					<xsl:element name="xsl:variable">
						<xsl:attribute name="name">code</xsl:attribute>
						<xsl:attribute name="select">$item/@id</xsl:attribute>
					</xsl:element>
					<xsl:element name="xsl:choose">
						<xsl:element name="xsl:when">
							<xsl:attribute name="test">count($code) = 0</xsl:attribute>
							<xsl:element name="xsl:message">
	Document <xsl:element name="xsl:value-of"><xsl:attribute name="select">/<xsl:value-of select="../../@id"/>/@id</xsl:attribute></xsl:element> : valeur <xsl:element name="xsl:value-of">
	<xsl:attribute name="select">$val</xsl:attribute>
	</xsl:element> non trouvee dans la liste <xsl:value-of select="$list"/> (langue = <xsl:element name="xsl:value-of">
	<xsl:attribute name="select">$doclang</xsl:attribute>
	</xsl:element>)
							</xsl:element>
						</xsl:element>
						<xsl:element name="xsl:otherwise">
							<sdx:field code="{@name}">
								<xsl:element name="xsl:value-of">
									<xsl:attribute name="select">normalize-space(.)</xsl:attribute>
								</xsl:element>
							</sdx:field>
							<sdx:field code="{$xtg_choiceidprefix}{@name}">
								<xsl:element name="xsl:value-of">
									<xsl:attribute name="select">$code</xsl:attribute>
								</xsl:element>
							</sdx:field>
							<xsl:if test="@match">
								<xsl:variable name="match" select="@match"/>
								<xsl:for-each select="/application/languages/lang">
									<xsl:variable name="firstLang" select="@id"/>
									<xsl:element name="xsl:if">
										<xsl:attribute name="test">$doclang = '<xsl:value-of select="$firstLang"/>'</xsl:attribute>
										<xsl:element name="xsl:for-each">
											<xsl:attribute name="select">$match_<xsl:value-of select="$list"/>_<xsl:value-of select="$firstLang"/>/match[@id=$code]</xsl:attribute>
											<sdx:field code="{$xtg_choiceidprefix}{$match}">
												<xsl:element name="xsl:value-of">
													<xsl:attribute name="select">@mid</xsl:attribute>
												</xsl:element>
											</sdx:field>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
							</xsl:if>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				</xsl:element>
			
			</xsl:when>

			<!-- Pour le reste -->
			<xsl:otherwise>
				<sdx:field code="{@name}">
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select">normalize-space(.)</xsl:attribute>
					</xsl:element>
				</sdx:field>
			</xsl:otherwise>
		</xsl:choose>

		<!-- Pour les champs indexables en texte -->
		<xsl:if test="@type='string' or @type='text' or not(@type)">
			<xsl:call-template name="textMatch">
				<xsl:with-param name="field" select="."/>
				<xsl:with-param name="path">.</xsl:with-param>
			</xsl:call-template>
		</xsl:if>

		<!-- Ou les champs en navigation alphabétique -->
		<!--
		<xsl:variable name="name" select="@name"/>
		<xsl:if test="@type and @type!= 'string' and @type!='text' and $docinfo/nav/on[@field=$name and @mode='alpha']">
			<xsl:call-template name="textMatch">
				<xsl:with-param name="field" select="."/>
				<xsl:with-param name="path">.</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	<xsl:text>
	</xsl:text>
		-->
</xsl:element>
</xsl:template>

<xsl:template match="fieldgroup" mode="plein-texte">
	<xsl:apply-templates select="field|fieldgroup" mode="plein-texte"/>
</xsl:template>

<xsl:template match="field" mode="plein-texte">
	<xsl:choose>
	<!-- Listes externes -->
	<xsl:when test="@type='choice' and @list">
		<xsl:text>

	</xsl:text>
		<xsl:comment> Indexation plein-texte de <xsl:value-of select="@name"/> </xsl:comment>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match"><xsl:value-of select="@name"/></xsl:attribute>
			<xsl:attribute name="mode">fulltext</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">doclang</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">fulltextlang</xsl:attribute>
			</xsl:element>

			<xsl:element name="xsl:variable">
				<xsl:attribute name="name"><xsl:value-of select="concat('list_',@list)"/></xsl:attribute>
				<xsl:attribute name="select">document(concat('../xsl/lang/liste/',$doclang,'/',$doclang,'_<xsl:value-of select="@list"/>.xml'))/list</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:variable">
				<xsl:attribute name="name">val</xsl:attribute>
				<xsl:attribute name="select">normalize-space(.)</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:variable">
				<xsl:attribute name="name">item</xsl:attribute>
				<xsl:attribute name="select">$list_<xsl:value-of select="@list"/>/item[text() = $val]</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:if">
				<xsl:attribute name="test">count($item) = 1</xsl:attribute>
				<xsl:element name="xsl:variable">
					<xsl:attribute name="name">code</xsl:attribute>
					<xsl:attribute name="select">$item/@id</xsl:attribute>
				</xsl:element>
				<xsl:variable name="list" select="@list"/>
				<xsl:choose>
					<xsl:when test="@match">
						<!-- La valeur dans la langue -->
						<xsl:element name="xsl:value-of">
							<xsl:attribute name="select">$item</xsl:attribute>
						</xsl:element>
						<xsl:element name="xsl:text">&#160;</xsl:element>

						<!-- Et le(s) correspondance(s) dans les autres langues -->
						<xsl:for-each select="/application/languages/lang">
							<xsl:variable name="firstLang" select="@id"/>
							<xsl:element name="xsl:if">
								<xsl:attribute name="test">$doclang = '<xsl:value-of select="$firstLang"/>'</xsl:attribute>
								<xsl:element name="xsl:for-each">
									<xsl:attribute name="select">$match_<xsl:value-of select="$list"/>_<xsl:value-of select="$firstLang"/>/match[@id=$code]</xsl:attribute>
									<xsl:element name="xsl:value-of">
										<xsl:attribute name="select">.</xsl:attribute>
									</xsl:element>
									<xsl:element name="xsl:text">&#160;</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
					</xsl:when>
					<!-- Correspondance classique -->
					<xsl:otherwise>
						<xsl:element name="xsl:choose">
							<xsl:for-each select="/application/languages/lang">
								<xsl:element name="xsl:when">
									<xsl:attribute name="test">$fulltextlang='<xsl:value-of select="@id"/>'</xsl:attribute>
									<xsl:element name="xsl:value-of">
										<xsl:attribute name="select">$<xsl:value-of select="$list"/>_<xsl:value-of select="@id"/>/item[@id=$code]</xsl:attribute>
									</xsl:element>
									<xsl:element name="xsl:text"><xsl:text> </xsl:text></xsl:element>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:element>
	</xsl:when>

	<!-- Champ de type attach -->
	<xsl:when test="@type='attach'">
		<xsl:text>

	</xsl:text>
		<xsl:comment> Pas d'indexation plein-texte pour les attachements </xsl:comment>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match"><xsl:value-of select="@name"/></xsl:attribute>
			<xsl:attribute name="mode">fulltext</xsl:attribute>
		</xsl:element>
	</xsl:when>

	<!-- Champ multilingue -->
	<xsl:when test="@lang='multi'">
		<xsl:text>

	</xsl:text>
		<xsl:comment> Indexation plein-texte de <xsl:value-of select="@name"/> </xsl:comment>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match"><xsl:value-of select="@name"/></xsl:attribute>
			<xsl:attribute name="mode">fulltext</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">doclang</xsl:attribute>
			</xsl:element>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">fulltextlang</xsl:attribute>
			</xsl:element>

			<xsl:element name="xsl:choose">
				<xsl:for-each select="//languages/lang">
					<xsl:element name="xsl:when">
						<xsl:attribute name="test">@xml:lang=$fulltextlang</xsl:attribute>
						<xsl:element name="xsl:value-of">
							<xsl:attribute name="select">normalize-space(.)</xsl:attribute>
						</xsl:element>
						<xsl:element name="xsl:if">
							<xsl:attribute name="test">normalize-space(.)!=''</xsl:attribute>
							<xsl:element name="xsl:text"><xsl:text> </xsl:text></xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:when>

	</xsl:choose>
			
</xsl:template>

</xsl:stylesheet>
