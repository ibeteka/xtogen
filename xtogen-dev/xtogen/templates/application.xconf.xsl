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
	exclude-result-prefixes="sdx">
<xsl:output method="xml" indent="yes"/>

<xsl:param name="app_name"/>
<xsl:param name="application_id"/>
<xsl:param name="display_config_file"/>
<xsl:param name="file_url_prefix"/>

<xsl:include href="xtogen-common-functions.xsl"/>

<xsl:template match="application">
<xsl:variable name="defaultLang" select="languages/lang[@default='true']/@id"/>
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
<sdx:application xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx" id="{$application_id}" xml:lang="{$defaultLang}" xmlns="http://www.culture.gouv.fr/ns/sdx/sdx">

    <sdx:userDocumentBase>
        <sdx:repositories>
            <sdx:repository id="users" type="FS" baseDirectory="users/xml" depth="0" extent="1000"/>
        </sdx:repositories>
        <sdx:fieldList xml:lang="{$defaultLang}" variant="">
            <sdx:field name="name" type="field" brief="true"/>
            <sdx:field name="firstname" type="field" brief="true"/>
            <sdx:field name="lastname" type="field" brief="true"/>
            <sdx:field name="description" type="word"/>
            <sdx:field name="lang" type="field" brief="true"/>
            <sdx:field name="variant" type="field" brief="true"/>
            <sdx:field name="email" type="field" brief="true"/>
            <sdx:field name="content" type="word" default="true">
                <sdx:name xml:lang="{$defaultLang}">Texte intégral</sdx:name>
            </sdx:field>
        </sdx:fieldList>
        <sdx:index>
            <sdx:pipeline>
                <sdx:transformation id="step1" type="XSLT" src="/sdx/resources/indexation/index-identity.xsl"/>
            </sdx:pipeline>
        </sdx:index>
    </sdx:userDocumentBase>
    <!-- Configuring the default administration group and user
	     within that group and an optional "userPassword" attribute -->
    <sdx:admin groupId="admins" userId="admin" userPassword=""/>

    <sdx:documentBases>
		<xsl:apply-templates select="//documenttype"/>
	</sdx:documentBases>

</sdx:application>
</xsl:template>

<xsl:template match="documenttype">
	<xsl:variable name="defaultLang" select="/application/languages/lang[@default='true']/@id"/>
	<xsl:variable name="id" select="@id"/>
	<xsl:variable name="docinfo" select="document(concat($file_url_prefix,$display_config_file))/display/documenttypes/documenttype[@id=$id]"/>
	<xsl:text>

	</xsl:text>
	<xsl:comment> <xsl:value-of select="$id"/> </xsl:comment>
	<sdx:documentBase id="{$id}" type="lucene" keepOriginalDocuments="true">
		<xsl:if test="position()=1">
			<xsl:attribute name="default">true</xsl:attribute>
		</xsl:if>
		<sdx:queryParser class="fr.gouv.culture.sdx.search.lucene.queryparser.DefaultQueryParser"/>
		<sdx:repositories>
			<sdx:repository type="FS" id="{$id}Repo" baseDirectory="repos/{$id}" depth="0" extent="100" default="true">
				<sdx:database type="HSQL"/>
			</sdx:repository>
		</sdx:repositories>
		<sdx:fieldList xml:lang="{$defaultLang}">
			<xsl:for-each select="//languages/lang">
				<xsl:variable name="lg" select="translate(@id,'-','_')"/>
				<sdx:field name="xtgpleintexte_{$lg}" type="word" brief="true" xml:lang="{@id}"/>
			</xsl:for-each>
			<sdx:field name="xtgtitle" type="field" brief="true"/>
			<sdx:field name="xtgdoclang" type="field" brief="true"/>
			<xsl:apply-templates select="fields/field|fields/fieldgroup">
				<xsl:with-param name="docinfo" select="$docinfo"/>
			</xsl:apply-templates>
		</sdx:fieldList>
		<sdx:index>
			<sdx:pipeline>
				<sdx:transformation id="index-{@id}" type="XSLT" src="index-{@id}.xsl"/>
				<xsl:if test="count(fields/descendant::field[@type='image' or @type='attach']) != 0">
				<sdx:transformation id="retire_doublons" type="XSLT" src="retire_doublons.xsl"/>
				</xsl:if>
			</sdx:pipeline>
		</sdx:index>
		<xsl:apply-templates select="$docinfo/oai">
			<xsl:with-param name="id" select="$id"/>
		</xsl:apply-templates>
	</sdx:documentBase>
</xsl:template>

<xsl:template match="oai">
	<xsl:param name="id"/>

	<xsl:variable name="adminEmail">
		<xsl:choose>
			<xsl:when test="@adminEmail"><xsl:value-of select="@adminEmail"/></xsl:when>
			<xsl:otherwise>sdx-admin@mycompany.com</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="sdxUrl">
		<xsl:choose>
			<xsl:when test="@sdxUrl"><xsl:value-of select="@sdxUrl"/></xsl:when>
			<xsl:otherwise>http://localhost:8080/sdx</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<sdx:oai-repository name="OAI repository for {$id} document base" adminEmail="{$adminEmail}" baseURL="{$sdxUrl}/sdx/oai/{$app_name}/{$id}">
		<sdx:oai-format name="OAI Dublin core" metadataPrefix="oai_dc" namespace="http://purl.org/dc/elements/1.1/" schemaUrl="http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
			<sdx:oai-fields>
				<xsl:if test="not(on[@oaiField='title'])">
				<sdx:oai-field name="title" sdxField="xtgtitle" repeated="concatenate" separator=" ;; "/>
				</xsl:if>
				<xsl:if test="not(on[@oaiField='identifier'])">
				<sdx:oai-field name="identifier" sdxField="sdxdocid"/>
				</xsl:if>
				<xsl:for-each select="on">
					<sdx:oai-field name="{@oaiField}" sdxField="{@field}">
						<xsl:attribute name="repeated">
							<xsl:choose>
								<xsl:when test="@repeated"><xsl:value-of select="@repeated"/></xsl:when>
								<xsl:otherwise>repeated</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="@separator"><xsl:attribute name="separator"><xsl:value-of select="@separator"/></xsl:attribute></xsl:if>
					</sdx:oai-field>
				</xsl:for-each>
			</sdx:oai-fields>
		</sdx:oai-format>
	</sdx:oai-repository>
</xsl:template>

<xsl:template match="fieldgroup">
	<xsl:param name="docinfo"/>
	<xsl:apply-templates select="field|fieldgroup">
		<xsl:with-param name="docinfo" select="$docinfo"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="field">
	<xsl:param name="docinfo"/>
	<xsl:variable name="name" select="@name"/>
	<sdx:field name="{$name}" type="field">
		<xsl:if test="$docinfo/nav/on[@field=$name] or @default or @type='attach' or @brief='true'">
			<xsl:attribute name="brief">true</xsl:attribute>
		</xsl:if>
	</sdx:field>
	<xsl:if test="not(@type) or @type='string' or @type='text'">
		<xsl:choose>
			<xsl:when test="not(@lang)">
				<sdx:field name="{$xtg_wordprefix}{$name}" type="word"/>
			</xsl:when>
			<xsl:when test="@lang='multi'">
				<xsl:for-each select="//languages/lang">
					<xsl:variable name="lg" select="translate(@id,'-','_')"/>
					<sdx:field name="{$xtg_wordprefix}{$name}_{$lg}" type="word" xml:lang="{@id}"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<sdx:field name="{$xtg_wordprefix}{$name}" type="word" xml:lang="{@lang}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:if test="@type='choice' and @list">
		<xsl:element name="sdx:field">
			<xsl:attribute name="name"><xsl:value-of select="concat($xtg_choiceidprefix,$name)"/></xsl:attribute>
			<xsl:attribute name="type">field</xsl:attribute>
			<xsl:if test="$docinfo/nav/on[@field=$name] or @default or @brief='true'">
				<xsl:attribute name="brief">true</xsl:attribute>
			</xsl:if>
		</xsl:element>
		<xsl:if test="@match">
			<sdx:field name="{$xtg_choiceidprefix}{@match}" type="field" brief="true"/>
		</xsl:if>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
