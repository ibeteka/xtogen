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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx" exclude-result-prefixes="sdx xsl">
    <xsl:import href="common.xsl"/>
    <xsl:param name="id" select="'admin'"/>
    <xsl:param name="pass"/>
    <xsl:template match="rights">
        <h2><xsl:value-of select="$messages[@id='page.login.droits']"/></h2>
        <p><xsl:value-of select="$messages[@id='page.login.explication']"/>
        <a class="nav" href="../sdx/admin/identities.xsp?app={/sdx:document/@app}">
        ../sdx/admin
        </a>.
        </p>
    </xsl:template>
    <xsl:template match="login">
        <form action="login.xsp" method="post" name="login">
			<input name="lang" value="{$lang}" type="hidden"/>
            <table border="0" cellpadding="5" cellspacing="0" align="center" class="form">
                <tr valign="top">
                    <td><xsl:value-of select="$messages[@id='page.login.codeutilisateur']"/></td>
                    <td>
                        <input name="id" size="30" type="text" value="{$id}"/>
                    </td>
                </tr>
                <tr valign="top">
                    <td><xsl:value-of select="$messages[@id='page.login.motdepasse']"/></td>
                    <td>
                        <input name="pass" size="30" type="password" value="{$pass}"/>
                    </td>
                </tr>
                <tr valign="top" align="center">
                    <td colspan="2">
						<xsl:if test="../sdx:user/@id">
                        	<input type="submit" value="{$messages[@id='page.login.deconnexion']}" name="logout"/>
						</xsl:if>
                        <input type="submit" value="{$messages[@id='page.login.entrer']}"/>
                    </td>
                </tr>
            </table>
        </form>
    </xsl:template>
    <xsl:template match="identified">
        <div class="alert">
            <b><xsl:value-of select="$messages[@id='page.login.identitereconnue']"/></b><br/>
            <b><xsl:value-of select="$messages[@id='page.login.vousappartenezaugroupe']"/>
				<xsl:for-each select="$currentuser/sdx:group">
					<xsl:if test="position()!=1">, </xsl:if><xsl:value-of select="@id"/>
				</xsl:for-each>
			</b>
        </div>
    </xsl:template>
    <xsl:template match="anonymous">
        <div class="alert"><xsl:value-of select="$messages[@id='page.login.identitenonreconnue']"/></div>
    </xsl:template>
    <xsl:template match="admin"/>
</xsl:stylesheet>
