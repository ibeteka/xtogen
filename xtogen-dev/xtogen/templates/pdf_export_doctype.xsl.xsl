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
	xmlns:saxon="http://icl.com/saxon"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	extension-element-prefixes="saxon"
	exclude-result-prefixes="saxon">
<xsl:output method="xml" indent="yes"/>
<xsl:param name="dest_dir">.</xsl:param>
<xsl:param name="file_url_prefix"/>
<xsl:param name="display_config_file"/>
<xsl:param name="app_full_path"/>

<xsl:include href="xtogen-common-functions.xsl"/>

<xsl:template match="/">
	<xsl:apply-templates select="//documenttype"/>
</xsl:template>

<xsl:template match="documenttype">
	<xsl:variable name="output" select="concat($dest_dir,'/pdf_export_',@id,'.xsl')"/>
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
	<xsl:variable name="formDisplay" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes/documenttype[@id=$currentid]"/>
	<xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
		<xsl:copy-of select="document('pdf_export_doctype.xsl.xsl')//namespace::*[.='http://www.w3.org/1999/XSL/Format']"/>
		<xsl:copy-of select="document('pdf_export_doctype.xsl.xsl')//namespace::*[.='http://www.culture.gouv.fr/ns/sdx/sdx']"/>
		<xsl:attribute name="version">1.0</xsl:attribute>
		<xsl:attribute name="exclude-result-prefixes">xsl</xsl:attribute>

		<xsl:variable name="confdisp" select="document(concat($file_url_prefix,$display_config_file))/display"/>
		<xsl:variable name="securityinfo" select="$confdisp/application/security/domain[@id='document']"/>

		<xsl:text>
		</xsl:text>
	<xsl:comment> Gestion de l'accès au document </xsl:comment>
		<xsl:element name="xsl:template">
			<xsl:attribute name="match">data[@doctype='<xsl:value-of select="$currentid"/>']</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">type</xsl:attribute>
			</xsl:element>

			<xsl:choose>
				<xsl:when test="$securityinfo/documenttype[@id=$currentid]/control">
					<xsl:call-template name="manageSecurity">
						<xsl:with-param name="control" select="$securityinfo/documenttype[@id=$currentid]/control"/>
						<xsl:with-param name="doc" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$securityinfo/domain[@id='pdf']/documenttype[@id=$currentid]/control">
					<xsl:call-template name="manageSecurity">
						<xsl:with-param name="control" select="$securityinfo/domain[@id='pdf']/documenttype[@id=$currentid]/control"/>
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

		<xsl:text>
		</xsl:text>
	<xsl:comment> Type de document <xsl:value-of select="@id"/> </xsl:comment>

		<xsl:element name="xsl:template">
			<xsl:attribute name="match">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:element name="xsl:param">
				<xsl:attribute name="name">type</xsl:attribute>
			</xsl:element>

			<!-- Variable -->
			<xsl:element name="xsl:variable">
				<xsl:attribute name="name">docapp</xsl:attribute>
				<xsl:attribute name="select">$urlparameter[@name='app']</xsl:attribute>
			</xsl:element>

			<!-- Ancre -->
			<xsl:element name="xsl:if">
				<xsl:attribute name="test">$type='multiple'</xsl:attribute>

				<fo:block break-before="page">
					<xsl:attribute name="id">{../sdx:field[@name='sdxdocid']}</xsl:attribute>
				</fo:block>
			</xsl:element>

			<!-- Title -->
			<xsl:element name="xsl:call-template">
				<xsl:attribute name="name">title</xsl:attribute>
				<xsl:element name="xsl:with-param">
					<xsl:attribute name="name">value</xsl:attribute>
					<xsl:variable name="node" select="fields/descendant-or-self::field[@default]"/>
					<xsl:variable name="defaultfp">
						<xsl:call-template name="computeFullPath">
							<xsl:with-param name="field" select="$node"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:element name="xsl:value-of">
						<xsl:attribute name="select"><xsl:value-of select="$defaultfp"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>

			<!-- For each field and fieldgroup -->
			<xsl:apply-templates select="fields/field[not(@default)]|fields/fieldgroup">
				<xsl:with-param name="formDisplay" select="$formDisplay"/>
			</xsl:apply-templates>

			<!-- reverse -->
			<xsl:for-each select="//documenttype/fields/descendant-or-self::field[@type='relation' and @to=$currentid]">
				<xsl:element name="xsl:call-template">
					<xsl:attribute name="name">reverse</xsl:attribute>
					<xsl:element name="xsl:with-param">
						<xsl:attribute name="name">db</xsl:attribute>
						<xsl:value-of select="./ancestor::documenttype/@id"/>
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
				</xsl:element>
			</xsl:for-each>

		</xsl:element>
	</xsl:element>
	</saxon:output>
</xsl:template>

<!-- fieldgroup -->
<xsl:template match="fieldgroup">
	<xsl:param name="formDisplay"/>

	<xsl:variable name="path">
		<xsl:choose>
			<xsl:when test="@path"><xsl:value-of select="@path"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:if test="count(field[not(@default)])!=0 or count(fieldgroup)!=0">
		<xsl:element name="xsl:for-each">
			<xsl:attribute name="select"><xsl:value-of select="$path"/></xsl:attribute>
			
			<fo:block background-color="gray"
					  space-after.optimum="0pt"
					  space-before.optimum="5pt"
					  color="white">
				<xsl:element name="xsl:value-of"><xsl:attribute name="select">$docType/fieldgroup[@name='<xsl:value-of select="@name"/>']</xsl:attribute></xsl:element>
			</fo:block>
			<xsl:apply-templates select="fieldgroup|field[not(@default)]">
				<xsl:with-param name="formDisplay" select="$formDisplay"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:if>
</xsl:template>

<!-- field -->
<xsl:template match="field">
	<xsl:param name="formDisplay"/>

	<xsl:call-template name="managefield">
		<xsl:with-param name="value" select="."/>
		<xsl:with-param name="formDisplay" select="$formDisplay"/>
	</xsl:call-template>
</xsl:template>


<!-- Manage field -->
<xsl:template name="managefield">
<xsl:param name="value"/>
<xsl:param name="formDisplay"/>

	<xsl:variable name="name" select="$value/@name"/>
	<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="$value/@type"><xsl:value-of select="$value/@type"/></xsl:when>
			<xsl:otherwise>string</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="fieldpath">
		<xsl:choose>
			<xsl:when test="$value/@path"><xsl:value-of select="$value/@path"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:element name="xsl:if">
		<xsl:attribute name="test">count(<xsl:value-of select="$fieldpath"/>) &gt; 0</xsl:attribute>
		<xsl:element name="xsl:call-template">
			<xsl:attribute name="name">label</xsl:attribute>
			<xsl:element name="xsl:with-param">
				<xsl:attribute name="name">field</xsl:attribute>
				<xsl:value-of select="$name"/>
			</xsl:element>
			<xsl:element name="xsl:with-param">
				<xsl:attribute name="name">type</xsl:attribute>
				<xsl:value-of select="$type"/>
			</xsl:element>
			<xsl:element name="xsl:with-param">
				<xsl:attribute name="name">value</xsl:attribute>
				<xsl:attribute name="select"><xsl:value-of select="$fieldpath"/></xsl:attribute>
			</xsl:element>
			</xsl:element>

			<xsl:choose>
				<xsl:when test="$type='image' or $type='attach'">
					<xsl:element name="xsl:for-each">
						<xsl:attribute name="select"><xsl:value-of select="$fieldpath"/></xsl:attribute>
						<xsl:element name="xsl:call-template">
							<xsl:attribute name="name">attach</xsl:attribute>
							<xsl:element name="xsl:with-param">
								<xsl:attribute name="name">field</xsl:attribute>
								<xsl:value-of select="$name"/>
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
								<xsl:attribute name="name">mode</xsl:attribute>
								<xsl:choose>
									<xsl:when test="$formDisplay/document/on[@field=$name]/@mode"><xsl:value-of select="$formDisplay/document/on[@field=$name]/@mode"/></xsl:when>
									<xsl:otherwise>link</xsl:otherwise>
								</xsl:choose>
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
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="xsl:call-template">
						<xsl:attribute name="name"><xsl:value-of select="$type"/></xsl:attribute>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">field</xsl:attribute>
							<xsl:value-of select="$name"/>
						</xsl:element>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name">value</xsl:attribute>
							<xsl:attribute name="select"><xsl:value-of select="$fieldpath"/></xsl:attribute>
						</xsl:element>
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
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
</xsl:template>

<!-- Manage security -->
<xsl:template name="manageSecurity">
	<xsl:param name="control"/>
	<xsl:param name="doc"/>

	<xsl:variable name="fullPath">
		<xsl:call-template name="computeAbsolutePath">
			<xsl:with-param name="node" select="$doc/fields/descendant-or-self::field[@name=$control/@field]"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:element name="xsl:for-each">
		<xsl:attribute name="select">//<xsl:value-of select="$doc/@id"/></xsl:attribute>
		<xsl:element name="xsl:choose">
			<xsl:element name="xsl:when">
				<xsl:attribute name="test"><xsl:value-of select="$fullPath"/> = '<xsl:value-of select="$control/@value"/>'</xsl:attribute>	
				<xsl:element name="xsl:choose">
					<xsl:element name="xsl:when">
					<xsl:attribute name="test"><xsl:apply-templates select="$control/group" mode="condition"><xsl:with-param name="control" select="$control"/></xsl:apply-templates></xsl:attribute>
						<xsl:call-template name="manageDoc">
							<xsl:with-param name="docId" select="'.'"/>
						</xsl:call-template>
					</xsl:element>
					<xsl:element name="xsl:otherwise">
						<xsl:element name="xsl:if">
							<xsl:attribute name="test">$type='multiple'</xsl:attribute>
							<fo:block break-before="page">
								<xsl:attribute name="id">id</xsl:attribute>
							</fo:block>
						</xsl:element>
						<fo:block space-before="1.5cm" background-color="gray" space-after.optimum="0pt" space-before.optimum="5pt" color="white" text-align="center">
							<xsl:element name="xsl:value-of">
								<xsl:attribute name="select">$messages[@id='page.document.accesinterditaudocument']</xsl:attribute>
							</xsl:element>
						</fo:block>

					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="xsl:otherwise">
				<xsl:call-template name="manageDoc">
					<xsl:with-param name="docId" select="'.'"/>
				</xsl:call-template>
			</xsl:element>
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
		<xsl:attribute name="select"><xsl:if test="$docId!='.'">//</xsl:if><xsl:value-of select="$docId"/></xsl:attribute>
		<xsl:element name="xsl:with-param">
			<xsl:attribute name="name">type</xsl:attribute>
			<xsl:attribute name="select">$type</xsl:attribute>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template name="computeAbsolutePath">
	<xsl:param name="node"/><xsl:if test="name($node/parent::*)='fieldgroup'"><xsl:call-template name="computeAbsolutePath"><xsl:with-param name="node" select="$node/parent::*"/></xsl:call-template>/</xsl:if><xsl:choose><xsl:when test="$node/@path"><xsl:value-of select="$node/@path"/></xsl:when><xsl:otherwise><xsl:value-of select="$node/@name"/></xsl:otherwise></xsl:choose>
</xsl:template>

</xsl:stylesheet>

