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

<xsl:template match="application">
	
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
<map:sitemap xmlns:map="http://apache.org/cocoon/sitemap/1.0">
<xsl:text>
	</xsl:text>
<xsl:comment> =========================== Components ================================ </xsl:comment>
    <map:components>
        <map:generators default="xsp">
            <map:generator name="file" src="org.apache.cocoon.generation.FileGenerator" label="content,data" logger="sitemap.generator.file" pool-max="32" pool-min="8" pool-grow="4"/>
            <map:generator name="xsp" src="org.apache.cocoon.generation.ServerPagesGenerator" logger="sitemap.generator.serverpages" pool-max="32" pool-min="4" pool-grow="2"/>
			<map:generator name="directory" src="org.apache.cocoon.generation.DirectoryGenerator" logger="sitemap.generator.directory" pool-max="32" pool-min="4" pool-grow="2"/>
        </map:generators>
        <map:readers default="resource">
            <map:reader name="resource" src="org.apache.cocoon.reading.ResourceReader" logger="sitemap.reader.resource" pool-max="32"/>
            <map:reader name="thumbnail" src="fr.tech.sdx.xtogen.image.ThumbnailReader"/>
        </map:readers>

        <map:transformers default="xsl">
            <map:transformer name="xsl" src="org.apache.cocoon.transformation.TraxTransformer" logger="sitemap.transformer.xslt" pool-max="32" pool-min="8" pool-grow="2"/>
         	<map:transformer name="xinclude" src="org.apache.cocoon.transformation.XIncludeTransformer"/>
            <map:transformer name="cinclude" src="org.apache.cocoon.transformation.CachingCIncludeTransformer"/>
			<map:transformer name="i18n" src="org.apache.cocoon.transformation.I18nTransformer" logger="sitemap.transformer.i18n">
				<catalogue-name>catalog</catalogue-name>
				<catalogue-location>.</catalogue-location>
			</map:transformer>
        </map:transformers>

        <map:serializers default="html">
<xsl:text>
		</xsl:text>
<xsl:comment> XML </xsl:comment>
            <map:serializer name="xml" src="org.apache.cocoon.serialization.XMLSerializer" mime-type="text/xml" logger="sitemap.serializer.xml"/>

<xsl:text>
		</xsl:text>
<xsl:comment> HTML </xsl:comment>
            <map:serializer name="html" src="org.apache.cocoon.serialization.HTMLSerializer" mime-type="text/html" logger="sitemap.serializer.html" pool-max="32" pool-min="4" pool-grow="4">
                <buffer-size>1024</buffer-size>
                <encoding>UTF-8</encoding>
            </map:serializer>

<xsl:text>
		</xsl:text>
<xsl:comment> XHTML </xsl:comment>
            <map:serializer name="xhtml" mime-type="text/html" logger="sitemap.serializer.xhtml" src="org.apache.cocoon.serialization.XMLSerializer" pool-max="64" pool-min="2" pool-grow="2">
                <doctype-public>-//W3C//DTD XHTML 1.0 Strict//EN</doctype-public>
                <doctype-system>http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd</doctype-system>
                <encoding>UTF-8</encoding>
            </map:serializer>

<xsl:text>
		</xsl:text>
<xsl:comment> TEXT </xsl:comment>
            <map:serializer name="text" src="org.apache.cocoon.serialization.TextSerializer" mime-type="text/plain" logger="sitemap.serializer.text">
                <encoding>UTF-8</encoding>
            </map:serializer>

<xsl:text>
		</xsl:text>
<xsl:comment> VCF </xsl:comment>
            <map:serializer name="vcf" src="org.apache.cocoon.serialization.TextSerializer" mime-type="text/x-vcard" logger="sitemap.serializer.text">
                <encoding>iso-8859-1</encoding>
            </map:serializer>

<xsl:text>
		</xsl:text>
<xsl:comment> XtoGen CSV </xsl:comment>
            <map:serializer name="csv" src="fr.tech.sdx.xtogen.serializer.CSVSerializer" logger="sitemap.serializer.xtgcsv">
                <encoding>iso-8859-1</encoding>
			</map:serializer>

<xsl:text>
		</xsl:text>
<xsl:comment> FOP </xsl:comment>
			<map:serializer name="fo2pdf"
                src="org.apache.cocoon.serialization.FOPSerializer"
                mime-type="application/pdf"/>

<xsl:text>
		</xsl:text>
<xsl:comment> ZIP </xsl:comment>
			<map:serializer name="zip"
                src="org.apache.cocoon.serialization.ZipArchiveSerializer"
                mime-type="application/x-zip"/>
       	</map:serializers>
        <map:selectors default="browser"/>
        <map:matchers default="wildcard">
            <map:matcher name="wildcard" src="org.apache.cocoon.matching.WildcardURIMatcherFactory"/>
        </map:matchers>
<xsl:text>
		</xsl:text>
<xsl:comment> actions </xsl:comment>
        <map:actions default="isAdmin">
            <map:action name="isAdmin" logger="sdx.sitemap.AdminAction" src="fr.gouv.culture.sdx.sitemap.AdminAction"/>
			<!--
			<map:action name="locale" src="org.apache.cocoon.acting.LocaleAction" logger="sitemap.LocaleAction">
				<locale-attribute>lang</locale-attribute>
				<store-in-session>false</store-in-session>
				<create-session>false</create-session>
				<store-in-request>false</store-in-request>
				<store-in-cookie>false</store-in-cookie>
 			</map:action>
			-->
			<map:action name="locale" src="fr.tech.sdx.xtogen.acting.LocaleAction" logger="sitemap.MyLocaleAction">
				<default-locale><xsl:value-of select="//languages/lang[@default]/@id"/></default-locale>
			</map:action>
        </map:actions>
    </map:components>
<xsl:text>
	</xsl:text>
<xsl:comment> =========================== Pipelines ================================= </xsl:comment>
    <map:pipelines>
		<xsl:if test="not(@mode) or @mode!='production'">
        <map:pipeline id="utils">
				<map:match pattern="**.xsp2src">
					<map:generate type="xsp">
						<xsl:attribute name="src">{1}.xsp</xsl:attribute>
					</map:generate>
					<map:transform type="cinclude"/>
					<map:transform src="../sdx/resources/xsl/xml.xsl"/>
					<map:serialize type="html"/>
				</map:match>
				<!-- Utility for viewing source xml or html -->
				<map:match pattern="**.xsp2xspX">
					<map:generate type="file">
						<xsl:attribute name="src">{1}.xsp</xsl:attribute>
					</map:generate>
					<map:serialize type="text"/>
				</map:match>
				<map:match pattern="**.xsp2xsp">
					<map:generate type="file">
						<xsl:attribute name="src">{1}.xsp</xsl:attribute>
					</map:generate>
					<map:transform src="../sdx/resources/xsl/xml.xsl"/>
					<map:serialize type="html"/>
				</map:match>
				<map:match pattern="**.xsp2sdxX">
					<map:generate type="xsp">
						<xsl:attribute name="src">{1}.xsp</xsl:attribute>
					</map:generate>
					<map:serialize type="text"/>
				</map:match>
				<map:match pattern="**.xsp2sdx">
					<map:generate type="xsp">
						<xsl:attribute name="src">{1}.xsp</xsl:attribute>
					</map:generate>
					<map:transform src="../sdx/resources/xsl/xml.xsl"/>
					<map:serialize type="html"/>
				</map:match>
				<map:match pattern="**.xsp2htmX">
					<map:generate type="xsp">
						<xsl:attribute name="src">{1}.xsp</xsl:attribute>
					</map:generate>
					<map:transform>
						<xsl:attribute name="src">xsl/{1}.xsl</xsl:attribute>
						<map:parameter name="use-request-parameters" value="true"/>
					</map:transform>
					<map:serialize type="text"/>
				</map:match>
				<map:match pattern="**.xsp2htm">
					<map:generate type="xsp">
						<xsl:attribute name="src">{1}.xsp</xsl:attribute>
					</map:generate>
					<map:transform>
						<xsl:attribute name="src">xsl/{1}.xsl</xsl:attribute>
						<map:parameter name="use-request-parameters" value="true"/>
					</map:transform>
					<map:transform src="../sdx/resources/xsl/xml.xsl"/>
					<map:serialize type="html"/>
				</map:match>
				<!-- Export PDF (debug) -->
				<map:match pattern="pdf_export.xspx">
					<map:generate type="xsp" src="pdf_export.xsp"/>
					<map:transform src="xsl/pdf_export.xsl"/>
					<map:serialize type="xml"/>
				</map:match>
				<xsl:for-each select="//documenttype">
					<map:match pattern="base_{@id}_export.pdfx">
						<map:generate type="xsp" src="pdf_base_export.xsp"/>
						<map:transform src="xsl/pdf_export.xsl"/>
						<map:serialize type="xml"/>
					</map:match>
				</xsl:for-each>
        </map:pipeline>
		</xsl:if>
        <map:pipeline>

		   <map:match pattern="thumbnail">
				<map:act type="request">
					<map:parameter name="parameters" value="true"/>
					<map:read type="thumbnail">
						<xsl:attribute name="src">{requestQuery}</xsl:attribute>
						<map:parameter name="app">
							<xsl:attribute name="value">{app}</xsl:attribute>
						</map:parameter>
						<map:parameter name="base">
							<xsl:attribute name="value">{base}</xsl:attribute>
						</map:parameter>
						<map:parameter name="id">
							<xsl:attribute name="value">{id}</xsl:attribute>
						</map:parameter>
						<map:parameter name="size">
							<xsl:attribute name="value">{size}</xsl:attribute>
						</map:parameter>
					</map:read>
				</map:act>
			</map:match>

		<!--
		<map:act type="locale">
		-->
<xsl:text>

		</xsl:text>
<xsl:comment> If no server redirection, a default welcome page </xsl:comment>
            <map:match pattern="">
                <map:redirect-to uri="index.xsp"/>
            </map:match>
            <map:match pattern="params.xsp">
                <map:generate type="xsp" src="params.xsp"/>
                <map:serialize/>
            </map:match>

<xsl:text>

		</xsl:text>
<xsl:comment> saisie </xsl:comment>
            <map:match pattern="saisie_*.xsp">
                <map:generate type="xsp">
					<xsl:attribute name="src">saisie_{1}.xsp</xsl:attribute>
				</map:generate>
				<map:transform type="cinclude"/>
                <map:transform src="xsl/saisie_document.xsl">
                    <map:parameter name="use-request-parameters" value="true"/>
                </map:transform>
                <map:serialize/>
            </map:match>

<xsl:text>

		</xsl:text>
<xsl:comment> recherche </xsl:comment>
            <map:match pattern="search_*.xsp">
                <map:generate type="xsp">
					<xsl:attribute name="src">search_{1}.xsp</xsl:attribute>
				</map:generate>
				<map:transform type="cinclude"/>
                <map:transform src="xsl/complex_search.xsl">
                    <map:parameter name="use-request-parameters" value="true"/>
                </map:transform>
                <map:serialize/>
            </map:match>

<xsl:text>

		</xsl:text>
<xsl:comment> Export XML </xsl:comment>
            <map:match pattern="export.xsp">
                <map:generate type="xsp" src="export.xsp"/>
                <map:transform src="xsl/export.xsl"/>
                <map:serialize type="xml"/>
            </map:match>

<xsl:text>

		</xsl:text>
<xsl:comment> Export VCF </xsl:comment>
            <map:match pattern="export_vcf.xsp">
                <map:generate type="xsp" src="vcf_export.xsp"/>
                <map:transform src="xsl/vcf_export.xsl"/>
                <map:serialize type="vcf"/>
            </map:match>
<xsl:text>

		</xsl:text>
<xsl:comment> Export CSV </xsl:comment>
            <map:match pattern="list_export.csv">
                <map:generate type="xsp" src="csv_list_export.xsp"/>
                <map:serialize type="csv"/>
            </map:match>
			<xsl:for-each select="documenttypes/documenttype">
            <map:match pattern="base_{@id}_export.csv">
                <map:generate type="xsp" src="csv_base_export.xsp"/>
                <map:transform src="xsl/csv_base_{@id}_export.xsl"/>
                <map:serialize type="csv"/>
            </map:match>
			</xsl:for-each>
<xsl:text>

		</xsl:text>
<xsl:comment> Export ZIP </xsl:comment>
			<xsl:for-each select="documenttypes/documenttype">
            <map:match pattern="base_{@id}_export.zip">
                <map:generate type="xsp" src="zip_base_{@id}_export.xsp"/>
                <map:transform src="xsl/zip_base_export.xsl"/>
                <map:transform src="xsl/zip_del_doublons.xsl"/>
                <map:serialize type="zip"/>
            </map:match>
			</xsl:for-each>
			<xsl:for-each select="documenttypes/documenttype">
            <map:match pattern="base_{@id}_export.zipx">
                <map:generate type="xsp" src="zip_base_{@id}_export.xsp"/>
                <map:transform src="xsl/zip_base_export.xsl"/>
                <map:serialize type="xml"/>
            </map:match>
			</xsl:for-each>
			<xsl:for-each select="documenttypes/documenttype">
            <map:match pattern="base_{@id}_export.zipxx">
                <map:generate type="xsp" src="zip_base_{@id}_export.xsp"/>
                <map:transform src="xsl/zip_base_export.xsl"/>
                <map:transform src="xsl/zip_del_doublons.xsl"/>
                <map:serialize type="xml"/>
            </map:match>
			</xsl:for-each>
<xsl:text>

		</xsl:text>
<xsl:comment> Export PDF </xsl:comment>
			<xsl:for-each select="documenttypes/documenttype">
            <map:match pattern="base_{@id}_export.pdf">
                <map:generate type="xsp" src="pdf_base_export.xsp"/>
                <map:transform src="xsl/pdf_export.xsl"/>
                <map:serialize type="fo2pdf"/>
            </map:match>
			</xsl:for-each>

            <map:match pattern="pdf_export.xsp">
                <map:generate type="xsp" src="pdf_export.xsp"/>
                <map:transform src="xsl/pdf_export.xsl"/>
                <map:serialize type="fo2pdf"/>
            </map:match>

<xsl:text>

		</xsl:text>
<xsl:comment> Liste de fichiers </xsl:comment>
			<xsl:for-each select="documenttypes/documenttype">
				<map:match pattern="list_attach_{@id}">
					<map:generate type="directory" src="documents/{@id}/attach"/>
					<map:serialize type="xml"/>
				</map:match>
			</xsl:for-each>

<xsl:text>

		</xsl:text>
<xsl:comment> Termes </xsl:comment>
			<xsl:for-each select="documenttypes/documenttype">
				<map:match pattern="terms_{@id}">
					<map:generate type="xsp" src="terms_{@id}.xsp"/>
					<map:serialize type="xml"/>
				</map:match>
			</xsl:for-each>
<xsl:text>
		</xsl:text>
<xsl:comment> listes </xsl:comment>
			<xsl:for-each select="documenttypes/documenttype">
				<map:match pattern="list_{@id}.xsp">
					<map:generate type="xsp" src="terms_{@id}.xsp"/>
					<map:transform type="cinclude"/>
					<map:transform src="xsl/liste.xsl">
						<map:parameter name="use-request-parameters" value="true"/>
					</map:transform>
					<map:serialize/>
				</map:match>
			</xsl:for-each>
<xsl:text>

		</xsl:text>
<xsl:comment> Recherche linéaire (pour alphabet) </xsl:comment>
			<xsl:for-each select="documenttypes/documenttype">
				<map:match pattern="linear_{@id}">
					<map:generate type="xsp" src="linear_{@id}.xsp"/>
					<map:serialize type="xml"/>
				</map:match>
				<map:match pattern="linear_{@id}.xsp">
					<map:generate type="xsp" src="linear_{@id}.xsp"/>
					<map:transform type="cinclude"/>
					<map:transform src="xsl/liste.xsl">
						<map:parameter name="use-request-parameters" value="true"/>
					</map:transform>
					<map:serialize/>
				</map:match>
			</xsl:for-each>
<xsl:text>
		</xsl:text>
<xsl:comment> contenu </xsl:comment>
			<map:match pattern="base_content">
				<map:generate type="xsp" src="base_content.xsp"/>
				<map:serialize type="xml"/>
			</map:match>
<xsl:text>
		</xsl:text>
<xsl:comment> galeries </xsl:comment>
			<xsl:for-each select="documenttypes/documenttype">
				<map:match pattern="gallery_{@id}.xsp">
					<map:generate type="xsp" src="terms_{@id}.xsp"/>
					<map:transform type="cinclude"/>
					<map:transform src="xsl/gallery.xsl">
						<map:parameter name="use-request-parameters" value="true"/>
					</map:transform>
					<map:serialize/>
				</map:match>
			</xsl:for-each>
<xsl:text>

		</xsl:text>
<xsl:comment> requetes </xsl:comment>
			<xsl:for-each select="documenttypes/documenttype">
				<map:match pattern="query_{@id}.xsp">
					<map:generate type="xsp" src="query_{@id}.xsp"/>
					<map:transform type="cinclude"/>
					<map:transform src="xsl/query.xsl">
						<map:parameter name="use-request-parameters" value="true"/>
					</map:transform>
					<map:serialize/>
				</map:match>
				<map:match pattern="query_{@id}">
					<map:generate type="xsp" src="query_{@id}.xsp"/>
					<map:serialize type="xml"/>
				</map:match>
			</xsl:for-each>
<xsl:text>

		</xsl:text>
<xsl:comment> import csv </xsl:comment>
			<xsl:for-each select="documenttypes/documenttype">
				<map:match pattern="csv_base_import_{@id}.xsp">
					<map:generate type="xsp" src="csv_base_import_{@id}.xsp"/>
					<map:transform type="cinclude"/>
					<map:transform src="xsl/csv_base_import.xsl">
						<map:parameter name="use-request-parameters" value="true"/>
					</map:transform>
					<map:serialize/>
				</map:match>
			</xsl:for-each>
<xsl:text>

		</xsl:text>
<xsl:comment> Pour les exports off-line </xsl:comment>
				<map:match pattern="base_export">
					<map:generate type="xsp" src="base_export.xsp"/>
					<map:serialize type="xml"/>
				</map:match>
<xsl:text>

		</xsl:text>
<xsl:comment> Cas général </xsl:comment>
            <map:match pattern="*.xsp">
                <map:generate type="xsp">
					<xsl:attribute name="src">{1}.xsp</xsl:attribute>
				</map:generate>
				<map:transform type="cinclude"/>
                <map:transform>
					<xsl:attribute name="src">xsl/{1}.xsl</xsl:attribute>
                    <map:parameter name="use-request-parameters" value="true"/>
                </map:transform>
				<!--
				<map:transform type="i18n"/>
				<map:act type="mylocale">
      				<map:transform type="i18n">
						<map:parameter name="locale" value="{mylocale}"/>
      				</map:transform>
				</map:act>
				-->
                <map:serialize/>
            </map:match>
			<!--
			</map:act>
			-->
        </map:pipeline>
    </map:pipelines>
</map:sitemap>
</xsl:template>

</xsl:stylesheet>
