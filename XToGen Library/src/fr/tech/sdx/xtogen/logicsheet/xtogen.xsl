<?xml version="1.0"?>
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
	xmlns:xsp="http://apache.org/xsp"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	xmlns:xtg="http://xtogen.tech.fr">
<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="xtg:authentication">
		<xsp:logic>
		
			org.apache.log4j.Logger LOG
				= org.apache.log4j.Logger.getLogger(fr.tech.sdx.xtogen.security.RightsManager.class);
		
			<xsl:choose>
				<xsl:when test="@doctype">
					String domain = "<xsl:value-of select="@domain"/>-"
						+ request.getParameter("<xsl:value-of select="@doctype"/>");
				</xsl:when>
				<xsl:otherwise>
					String domain = "<xsl:value-of select="@domain"/>";
				</xsl:otherwise>
			</xsl:choose>

			fr.tech.sdx.xtogen.security.RightsManager rm
				= new fr.tech.sdx.xtogen.security.RightsManager(context,request);
			fr.tech.sdx.xtogen.security.RightsManager.AccessRights ar
				= rm.getAccessRights(domain);
			LOG.debug(domain);
			LOG.debug(ar);

			// No authentication needed
			if (ar.noControl())
			{
				LOG.debug("No authentication needed");
				<xsl:apply-templates/>
			}
			// Authentication needed and user not authenticated
			else if (sdx_user == null || sdx_user.getAppId() == null)
			{
				LOG.debug("Authentication needed: user not authenticated");
				<sdx:fallback>
					<link show="replace" actuate="onload" time="0" href="login.xsp"/>
				</sdx:fallback>
			}
			// Authentication needed and user is authenticated
			else
			{
				LOG.debug("Authentication needed: user is authenticated");

				// Check, now
				String[] groups = ar.getGroups(sdx_user.getAppId());
				LOG.debug("Groups :");
				for (int i=0; i&lt;groups.length; i++)
					LOG.debug("Group #" + i + " = " + groups[i]);

				// Authentication: ok
				if (ar.noControl() || (groups.length != 0 &amp;&amp; sdx_user.isMember(groups, false)))
				{
					LOG.debug("ok");
					<xsl:apply-templates/>
				}
				// Authentication: ko
				else
				{
					LOG.debug("ko");
					<sdx:fallback>
						<link show="replace" actuate="onload" time="0" href="login.xsp"/>
					</sdx:fallback>
				}
			}
		</xsp:logic>
	</xsl:template>
	
	<xsl:template match="xtg:createExternalListEditor">
	{
		String listFile = <xsl:value-of select="@dirvar"/>
			+ <xsl:value-of select="@langvar"/>	+ File.separator
			+ <xsl:value-of select="@langvar"/> + "_" + list + ".xml";
				
		try
		{
			<xsl:value-of select="@var"/> = new fr.tech.sdx.xtogen.list.ExternalListEditor(new File(listFile));
		}
		catch (javax.xml.parsers.ParserConfigurationException pce)
		{
			<error key="impossibledetrouverunparseurxml">
				<xsp:attribute name="file"><xsp:expr>listFile</xsp:expr></xsp:attribute>
			</error>
		}
		catch (org.xml.sax.SAXException se)
		{
			<error key="fichierxmlnonvalide">
				<xsp:attribute name="file"><xsp:expr>listFile</xsp:expr></xsp:attribute>
			</error>
		}
		catch (java.io.IOException ioe)
		{
			<error key="erreurlorsdelouverturedufichier">
				<xsp:attribute name="file"><xsp:expr>listFile</xsp:expr></xsp:attribute>
			</error>
		}

		if (<xsl:value-of select="@var"/> != null)
		{
			<xsl:choose>
				<xsl:when test="@op='mod'">
					<xsl:value-of select="@var"/>.changeValue(<xsl:value-of select="@id"/>,<xsl:value-of select="@value"/>);
				</xsl:when>
				<xsl:when test="@op='add'">
					boolean addBool = <xsl:value-of select="@var"/>.addValue(<xsl:value-of select="@id"/>,<xsl:value-of select="@value"/>);
				</xsl:when>
				<xsl:when test="@op='del'">
					<xsl:value-of select="@var"/>.deleteValue(<xsl:value-of select="@id"/>);
				</xsl:when>
				<xsl:when test="@op='flush'">
					<xsl:value-of select="@var"/>.flush();
				</xsl:when>
			</xsl:choose>
			
			try
			{
				<xsl:value-of select="@var"/>.save();
				<xsl:choose>
					<xsl:when test="@op='mod'">
						<success key="modificationeffectuee"/>
					</xsl:when>
					<xsl:when test="@op='add'">
						if (addBool)
						{
							<success key="ajouteffectue"/>
						}
						else
						{
							<error key="iddejautilise">
								<xsp:attribute name="file"><xsp:expr>listFile</xsp:expr></xsp:attribute>
							</error>
						}
					</xsl:when>
					<xsl:when test="@op='del' or @op='flush'">
						<success key="suppressioneffectuee"/>
					</xsl:when>
				</xsl:choose>
			}
			catch (java.io.IOException ioe)
			{
				<error key="erreurlorsdelasauvegardedufichier">
					<xsp:attribute name="file"><xsp:expr>listFile</xsp:expr></xsp:attribute>
				</error>
			}
		}
	}
	</xsl:template>

	<xsl:template match="node()|@*" priority="-1">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
