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
<xsl:param name="applicationId"/>
<xsl:param name="structure_file"/>
<xsl:param name="file_url_prefix"/>
<xsl:output method="text" />

<xsl:variable name="security" select="/display/application/security"/>
<xsl:variable name="doctypes"
	select="document(concat($file_url_prefix,$structure_file))/application/documenttypes/documenttype"/>

<xsl:template match="/">
# XtoGen - Générateur d'applications SDX2 - http://xtogen.tech.fr
# Copyright (C) 2003 Ministère de la culture et de la communication,
# PASS Technologie
#
# Ministère de la culture et de la communication,
# Mission de la recherche et de la technologie
# 3 rue de Valois, 75042 Paris Cedex 01 (France)
# mrt@culture.fr, michel.bottin@culture.fr
#
# PASS Technologie, 23, rue Pierre et Marie Curie, 94200 Ivry Sur Seine
# Nader Boutros, nader.boutros@pass-tech.fr
# Pierre Dittgen, pierre.dittgen@pass-tech.fr
#
# Ce programme est un logiciel libre: vous pouvez le redistribuer
# et/ou le modifier selon les termes de la "GNU General Public
# License", tels que publiés par la "Free Software Foundation"; soit
# la version 2 de cette licence ou (à votre choix) toute version
# ultérieure.
#
# Ce programme est distribué dans l'espoir qu'il sera utile, mais
# SANS AUCUNE GARANTIE, ni explicite ni implicite; sans même les
# garanties de commercialisation ou d'adaptation dans un but spécifique.
#
# Se référer à la "GNU General Public License" pour plus de détails.
#
# Vous devriez avoir reçu une copie de la "GNU General Public License"
# en même temps que ce programme; sinon, écrivez à la "Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA".

<xsl:choose>
	<xsl:when test="count($security/domain)=0">
<xsl:text/>default = none
nav = none
search = none
static = none
index = none
<xsl:for-each select="$doctypes">
<xsl:text/>html-<xsl:value-of select="@id"/> = none
pdf-<xsl:value-of select="@id"/> = none
xml-<xsl:value-of select="@id"/> = none</xsl:for-each>
edit = (admins,<xsl:value-of select="$applicationId"/>)
base = (admins,<xsl:value-of select="$applicationId"/>)
attach = (admins,<xsl:value-of select="$applicationId"/>)
list = (admins,<xsl:value-of select="$applicationId"/>)<xsl:text/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="manageDomain">
			<xsl:with-param name="name">default</xsl:with-param>
			<xsl:with-param name="node" select="$security"/>
		</xsl:call-template>
		<xsl:call-template name="manageDomain">
			<xsl:with-param name="name">interface</xsl:with-param>
			<xsl:with-param name="node" select="$security"/>
		</xsl:call-template>
		<xsl:call-template name="manageDomain">
			<xsl:with-param name="name">document</xsl:with-param>
			<xsl:with-param name="node" select="$security"/>
		</xsl:call-template>
		<xsl:call-template name="manageDomain">
			<xsl:with-param name="name">backoffice</xsl:with-param>
			<xsl:with-param name="node" select="$security"/>
		</xsl:call-template>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- Tout le travail est fait ici -->
<xsl:template name="manageDomain">
	<xsl:param name="name"/>
	<xsl:param name="node"/>

	<xsl:choose>
		<!-- Default -->
		<xsl:when test="$name='default'">
			<xsl:choose>
				<xsl:when test="not($node/domain[@id='default'])">
					<xsl:message> Attention !!! Sécurité par défaut n'est pas définie</xsl:message>
					<xsl:call-template name="accessLine">
						<xsl:with-param name="name">default</xsl:with-param>
						<xsl:with-param name="nosecurity">yes</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$node/domain[@id='default']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<!-- Interface -->
		<xsl:when test="$name='interface'">
			<xsl:call-template name="subDomainRights">
				<xsl:with-param name="name">nav</xsl:with-param>
				<xsl:with-param name="domain">interface</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:call-template name="subDomainRights">
				<xsl:with-param name="name">search</xsl:with-param>
				<xsl:with-param name="domain">interface</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:call-template name="subDomainRights">
				<xsl:with-param name="name">static</xsl:with-param>
				<xsl:with-param name="domain">interface</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:call-template name="subDomainRights">
				<xsl:with-param name="name">index</xsl:with-param>
				<xsl:with-param name="domain">interface</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
		</xsl:when>

		<!-- Document -->
		<xsl:when test="$name='document'">
			<xsl:call-template name="subDomainRightsWithDoc">
				<xsl:with-param name="name">html</xsl:with-param>
				<xsl:with-param name="domain">document</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:call-template name="subDomainRightsWithDoc">
				<xsl:with-param name="name">pdf</xsl:with-param>
				<xsl:with-param name="domain">document</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:call-template name="subDomainRightsWithDoc">
				<xsl:with-param name="name">xml</xsl:with-param>
				<xsl:with-param name="domain">document</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
		</xsl:when>

		<!-- Back office -->
		<xsl:when test="$name='backoffice'">
			<xsl:call-template name="subDomainRights">
				<xsl:with-param name="name">edit</xsl:with-param>
				<xsl:with-param name="domain">backoffice</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:call-template name="subDomainRights">
				<xsl:with-param name="name">base</xsl:with-param>
				<xsl:with-param name="domain">backoffice</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:call-template name="subDomainRights">
				<xsl:with-param name="name">attach</xsl:with-param>
				<xsl:with-param name="domain">backoffice</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:call-template name="subDomainRights">
				<xsl:with-param name="name">list</xsl:with-param>
				<xsl:with-param name="domain">backoffice</xsl:with-param>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<!-- Pour appliquer les droits des sous-domaines avec type de document -->
<xsl:template name="subDomainRightsWithDoc">
	<xsl:param name="name"/>
	<xsl:param name="domain"/>
	<xsl:param name="node"/>

	<xsl:choose>
		<!-- On applique les droits par défaut si le domaine n'existe pas -->
		<xsl:when test="not($node/domain[@id=$domain])">
			<xsl:for-each select="$doctypes">
				<xsl:call-template name="defaultRights">
					<xsl:with-param name="name" select="concat($name,'-',@id)"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<!-- Sinon on regarde par type de document -->
		<xsl:otherwise>
			<xsl:for-each select="$doctypes">
				<xsl:variable name="dt" select="@id"/>
				<xsl:choose>
					<!-- On applique les droits du type de document du sous-domaine s'ils existent -->
					<xsl:when test="$node/domain[@id=$domain]/domain[@id=$name]/documenttype[@id=$dt]">
						<xsl:call-template name="domainRights">
							<xsl:with-param name="name" select="concat($name,'-',$dt)"/>
							<xsl:with-param name="node" select="$node/domain[@id=$domain]/domain[@id=$name]/documenttype[@id=$dt]"/>
						</xsl:call-template>
					</xsl:when>
					<!-- On applique les droits du sous-domaine s'ils existent -->
					<xsl:when test="$node/domain[@id=$domain]/domain[@id=$name]">
						<xsl:call-template name="domainRights">
							<xsl:with-param name="name" select="concat($name,'-',$dt)"/>
							<xsl:with-param name="node" select="$node/domain[@id=$domain]/domain[@id=$name]"/>
						</xsl:call-template>
					</xsl:when>
					<!-- On applique les droits du type de document du domain s'ils existent -->
					<xsl:when test="$node/domain[@id=$domain]/documenttype[@id=$dt]">
						<xsl:call-template name="domainRights">
							<xsl:with-param name="name" select="concat($name,'-',$dt)"/>
							<xsl:with-param name="node" select="$node/domain[@id=$domain]/documenttype[@id=$dt]"/>
						</xsl:call-template>
					</xsl:when>
					<!-- Sinon les droits du domaine -->
					<xsl:otherwise>
						<xsl:call-template name="domainRights">
							<xsl:with-param name="name" select="concat($name,'-',$dt)"/>
							<xsl:with-param name="node" select="$node/domain[@id=$domain]"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Pour appliquer les droits des sous-domaines -->
<xsl:template name="subDomainRights">
	<xsl:param name="name"/>
	<xsl:param name="domain"/>
	<xsl:param name="node"/>

	<xsl:choose>
		<!-- On applique les droits par défaut si le domaine n'existe pas -->
		<xsl:when test="not($node/domain[@id=$domain])">
			<xsl:call-template name="defaultRights">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:when>
		<!-- On applique les droits du sous-domaine s'ils existent -->
		<xsl:when test="$node/domain[@id=$domain]/domain[@id=$name]">
			<xsl:call-template name="domainRights">
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="node" select="$node/domain[@id=$domain]/domain[@id=$name]"/>
			</xsl:call-template>
		</xsl:when>
		<!-- Sinon les droits du domaine -->
		<xsl:otherwise>
			<xsl:call-template name="domainRights">
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="node" select="$node/domain[@id=$domain]"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Pour appliquer les droits donnés -->
<xsl:template name="domainRights">
	<xsl:param name="name"/>
	<xsl:param name="node"/>

	<xsl:choose>
		<!-- On applique les droits du domaine s'ils existent -->
		<xsl:when test="$node/group or $node/nosecurity">
			<xsl:call-template name="accessLine">
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="groups" select="$node"/>
			</xsl:call-template>
		</xsl:when>
		<!-- Sinon ceux du domaine réel... -->
		<xsl:when test="name($node)='documenttype' and ($node/parent::*/group or $node/parent::*/nosecurity)">
			<xsl:call-template name="accessLine">
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="groups" select="$node/parent::*"/>
			</xsl:call-template>
		</xsl:when>		
		<!-- Sinon les droits par défaut -->
		<xsl:otherwise>
			<xsl:call-template name="defaultRights">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Pour appliquer les droits par défaut -->
<xsl:template name="defaultRights">
	<xsl:param name="name"/>

	<xsl:choose>
		<xsl:when test="not($security/domain[@id='default'])">
			<xsl:call-template name="accessLine">
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="nosecurity">yes</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="accessLine">
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="groups" select="$security/domain[@id='default']"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Pour écrire la ligne -->
<xsl:template name="accessLine">
	<xsl:param name="name"/>
	<xsl:param name="groups"/>
	<xsl:param name="nosecurity">no</xsl:param>
<xsl:value-of select="$name"/> = <xsl:choose>
	<xsl:when test="$nosecurity='no'"><xsl:apply-templates select="$groups/nosecurity|$groups/group"/></xsl:when>
	<xsl:otherwise>none</xsl:otherwise></xsl:choose>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- Juste pour défaut -->
<xsl:template match="domain">
	<xsl:call-template name="accessLine">
		<xsl:with-param name="name" select="@id"/>
		<xsl:with-param name="groups" select="."/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="nosecurity">none</xsl:template>

<xsl:template match="group">(<xsl:value-of select="@id"/>,<xsl:choose>
<xsl:when test="@app"><xsl:value-of select="@app"/></xsl:when>
<xsl:otherwise><xsl:value-of select="$applicationId"/></xsl:otherwise>
</xsl:choose>) </xsl:template>

</xsl:stylesheet>
