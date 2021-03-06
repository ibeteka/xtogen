<?xml version="1.0" encoding="utf-8"?>
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
	exclude-result-prefixes="sdx xsl">
<xsl:output method="text"/>

<!-- Placer ici tous les types de documents à traiter -->
<xsl:template match="/sdx:document">
	<xsl:apply-templates select="document/ressource"/>
	<xsl:apply-templates select="document/fonds"/>
	<xsl:apply-templates select="document/institution"/>
</xsl:template>

<!-- Un template par type de document -->
<xsl:template match="ressource">
<tutu>BEGIN:VCARD
VERSION:2.1
FN:<xsl:value-of select="fn"/>
TEL;WORK;VOICE:<xsl:value-of select="contacts/voice"/>
TEL;WORK;FAX:<xsl:value-of select="contacts/fax"/>
ADR;WORK:;;<xsl:value-of select="address/adr/street"/>;<xsl:value-of select="address/adr/locality"/>;;<xsl:value-of select="address/adr/pcode"/>;<xsl:value-of select="address/adr/country"/>
EMAIL:<xsl:value-of select="contacts/email"/>
URL;WORK:<xsl:value-of select="more/url"/>
END:VCARD
</tutu>
</xsl:template>

<!--

	Le format VCard est un format texte commençant par les 2 lignes suivantes :
BEGIN:VCARD
VERSION:2.1

	et terminant par :
END:VCARD

	Entre cet en-tête et ce pied de fichier, on trouve une ligne par champ
	du contact à renseigner.
	Plus d'infos : http://www.imc.org/pdi/

-->

</xsl:stylesheet>
