<?xml version="1.0" encoding="utf-8"?>
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
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	xmlns:dir="http://apache.org/cocoon/directory/2.0"
	xmlns:xtg="http://xtogen.tech.fr"
	exclude-result-prefixes="sdx xsl dir xtg">
    <xsl:import href="common.xsl"/>
    <xsl:import href="admin_saisie_all_docs.xsl"/>

	<xsl:variable name="dbId" select="$urlparameter[@name='db']/@value"/>
	<xsl:variable name="docType" select="$labels/doctype[@name=$dbId]"/>
	<xsl:variable name="docId" select="$urlparameter[@name='id']/@value"/>
	<xsl:variable name="mode" select="$urlparameter[@name='mode']/@value"/>

	<xsl:variable name="prefix">f_</xsl:variable>

	<xsl:variable name="docDisplay" select="document('config_display.xml')/configuration_display/documenttypes/documenttype[@id=$dbId]/edit"/>
	<xsl:variable name="useJavaScript" select="count($docDisplay/on[@mode='2cols']) != 0"/>

	<!-- Taille des champs input/textarea/select -->
	<xsl:variable name="globalInputSize">
		<xsl:choose>
			<xsl:when test="$docDisplay/global/input/@size"><xsl:value-of select="$docDisplay/global/input/@size"/></xsl:when>
			<xsl:otherwise>40</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="globalTextareaCols">
		<xsl:choose>
			<xsl:when test="$docDisplay/global/textarea/@cols"><xsl:value-of select="$docDisplay/global/textarea/@cols"/></xsl:when>
			<xsl:otherwise>60</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="globalTextareaRows">
		<xsl:choose>
			<xsl:when test="$docDisplay/global/textarea/@rows"><xsl:value-of select="$docDisplay/global/textarea/@rows"/></xsl:when>
			<xsl:otherwise>10</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="globalSelectSize">
		<xsl:choose>
			<xsl:when test="$docDisplay/global/select/@size"><xsl:value-of select="$docDisplay/global/select/@size"/></xsl:when>
			<xsl:otherwise>6</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Créer un input text -->
	<xsl:template name="textInput">
		<xsl:param name="name"/>
		<xsl:param name="gprefix"/>
		<xsl:param name="value"/>
		<xsl:param name="readonly">false</xsl:param>

		<xsl:variable name="size">
			<xsl:choose>
				<xsl:when test="$docDisplay/on[@field=$name]/@size"><xsl:value-of select="$docDisplay/on[@field=$name]/@size"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$globalInputSize"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<input type="text" name="{$prefix}{$gprefix}{$name}" size="{$size}">
			<xsl:if test="$value">
				<xsl:attribute name="value"><xsl:value-of select="$value"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$readonly='true'">
				<xsl:attribute name="disabled">disabled</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>

	<!-- Créer une zone texte (textarea) -->
	<xsl:template name="areaInput">
		<xsl:param name="name"/>
		<xsl:param name="gprefix"/>
		<xsl:param name="value"/>
		<xsl:param name="readonly">false</xsl:param>

		<xsl:variable name="cols">
			<xsl:choose>
				<xsl:when test="$docDisplay/on[@field=$name]/@cols"><xsl:value-of select="$docDisplay/on[@field=$name]/@cols"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$globalTextareaCols"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="rows">
			<xsl:choose>
				<xsl:when test="$docDisplay/on[@field=$name]/@rows"><xsl:value-of select="$docDisplay/on[@field=$name]/@rows"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$globalTextareaRows"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<textarea name="{$prefix}{$gprefix}{$name}" rows="{$rows}" cols="{$cols}">
			<xsl:if test="$readonly='true'">
				<xsl:attribute name="disabled">disabled</xsl:attribute>
			</xsl:if>
			<xsl:if test="$value">
				<xsl:apply-templates select="$value/child::*|text()" mode="copy"/>
			</xsl:if>
		</textarea>
	</xsl:template>

	<!-- Obtenir la taille d'une liste  -->
	<xsl:template name="listSize">
		<xsl:param name="name"/>

		<xsl:choose>
			<xsl:when test="$docDisplay/on[@field=$name]/@size"><xsl:value-of select="$docDisplay/on[@field=$name]/@size"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$globalSelectSize"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="script" mode="head">
	<xsl:if test="$useJavaScript">
	<script type="text/javascript" src="{/sdx:document/@server}/{/sdx:document/@appbypath}/js/selects.js"/>
	<script type="text/javascript" language="javascript">

	// Ce code JavaScript ainsi que les différents petits inserts
	// viennent de la page d'administration SDX
	// et ont été écrits par AJLSM
    
    function xfm_blur(o)
    {
        if (!o.className) return true;
        o.className=o.className.replace(/ ?xfm_focus/gi, ''); 
        return true;
    }

    function xfm_focus(o) 
    {
        document.xfm_last = o;
        if (!o.className) return true;
        o.className=o.className + ' xfm_focus'; 
        return true;
    }
    
	function xfm_load()
	{
		
		return true;
	}

	function getInputValue(obj)
	{
		if ((typeof(obj.length) != "undefined") &amp;&amp; (typeof(obj.type)=="undefined"))
		{
			var values = new Array();
			for (var i=0; i&lt;obj.length; i++)
			{
				var v = obj[i].value;
				if (v != null)
					values[values.length] = v;
			}
			return values;
		}

		var ret = new Array();
		ret[0] = obj.value;
		return ret;
	}

	function xfm_submit(form)
	{
		values = getInputValue(form['<xsl:value-of select="$prefix"/>2cols.id']);
		for (i=0; i&lt;values.length; i++)
		{
			var hid = values[i];
			if (form[hid]) selectAll(form[hid]);
		}

		return true;
	}
	
	function xfm_reset(form)
	{
	
	}
    </script>
	</xsl:if>
	<script type="text/javascript" language="javascript">

	// Changes the display of the div and the button
	function alter(doc,bt)
	{
		if (document.getElementById(doc).style.display == "none")
		{
			document.getElementById(doc).style.display = "block";
			document.getElementById(bt).src = "icones/moins.png";
		}
		else
		{
			document.getElementById(doc).style.display = "none";
			document.getElementById(bt).src = "icones/plus.png";
		}
	}

	// Open Attach browser window
	function openBrowser(fid)
	{
		window.open('attach_browser_<xsl:value-of select="$currentdoctype"/>.xsp?fid='+fid,'Saisie','toolbar=no,location=no,status=no,menubar=no,scrollbars=yes');
		return false;
	}
	</script>
	</xsl:template>

    <xsl:template match="sdx:navigation" mode="in">
        <tr>
            <td>
                <xsl:apply-templates select="sdx:previous"/>
            </td>
            <td align="right">
                <xsl:apply-templates select="sdx:next"/>
            </td>
        </tr>
    </xsl:template>

	<xsl:template match="document">
		<xsl:variable name="base" select="$urlparameter[@name='db']/@value"/>
		<h2>
			<xsl:choose>
				<xsl:when test="$mode='copy'">
					<xsl:value-of select="$messages[@id='page.admin.copiededocument']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$messages[@id='page.admin.saisie']"/>
				</xsl:otherwise>
			</xsl:choose>
		</h2>
		<div align="right">
			<xsl:for-each select="$titlefields/dbase[@id!=$base and not(@external)]">
				<small><xsl:if test="position()!=1">&#160;</xsl:if><a href="admin_saisie.xsp?db={@id}"><xsl:value-of select="@id"/></a></small>
			</xsl:for-each>
		</div>
		<h3><xsl:value-of select="$messages[@id='page.admin.basededocuments']"/>&#160;<xsl:value-of select="$base"/></h3>
		<xsl:if test="$urlparameter[@name='id']">&#160;<small>(<xsl:value-of select="$urlparameter[@name='id']/@value"/>)</small></xsl:if>
		<form id="saisie" name="saisie" method="POST" action="saisie_{$base}.xsp" enctype="multipart/form-data">
			<xsl:if test="$useJavaScript">
				<xsl:attribute name="onsubmit">if (window.xfm_submit) return xfm_submit(this);</xsl:attribute>
			</xsl:if>
			<input type="hidden" name="document.base" value="{$base}"/>
			<input type="hidden" name="interfaceLang" value="{$lang}"/>
			<!-- Batch editing -->
			<xsl:if test="//sdx:navigation/sdx:next">
				<xsl:variable name="batchnav" select="//sdx:navigation"/>
				<input type="hidden" name="qid" value="{$batchnav/@qid}"/>
				<input type="hidden" name="nextid" value="{$batchnav/sdx:next/@id}"/>
				<input type="hidden" name="nextno" value="{$batchnav/sdx:next/@no}"/>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:choose>
				<xsl:when test="$useJavaScript">
					<input type="submit" onblur="if (window.xfm_blur) xfm_blur(this);" onfocus="if (window.xfm_focus) xfm_focus(this);" value="{$messages[@id='common.ok']}"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="submit" value="{$messages[@id='common.ok']}"/>
				</xsl:otherwise>
			</xsl:choose>
		</form>
	</xsl:template>

	<!-- Pour les labels -->
	<xsl:template name="label">
		<xsl:param name="field"/>
		<td valign="top" class="attribut"><xsl:value-of select="$docType/field[@name=$field]"/></td>
	</xsl:template>

	<!-- Pour éviter les affichages intempestifs -->
	<xsl:template match="today"/>

	<!-- Pour la gestion des modifications -->
	<xsl:template name="manageVersioning">
		<xsl:param name="root"/>

		<xsl:choose>
			<xsl:when test="$root/xtg:version">
				<xsl:apply-templates select="$root/xtg:version/xtg:created" mode="hidden"/>
				<xsl:apply-templates select="$root/xtg:version/xtg:modified" mode="hidden"/>
				<xsl:call-template name="hidden-versioning">
					<xsl:with-param name="on" select="/sdx:document/today"/>
					<xsl:with-param name="by" select="/sdx:document/sdx:user/@id"/>
					<xsl:with-param name="type">modified</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="hidden-versioning">
					<xsl:with-param name="on" select="/sdx:document/today"/>
					<xsl:with-param name="by" select="/sdx:document/sdx:user/@id"/>
					<xsl:with-param name="type">created</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="xtg:created" mode="hidden">
		<xsl:call-template name="hidden-versioning">
			<xsl:with-param name="on" select="@on"/>
			<xsl:with-param name="by" select="@by"/>
			<xsl:with-param name="type">created</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="xtg:modified" mode="hidden">
		<xsl:call-template name="hidden-versioning">
			<xsl:with-param name="on" select="@on"/>
			<xsl:with-param name="by" select="@by"/>
			<xsl:with-param name="type">modified</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="hidden-versioning">
		<xsl:param name="on"/>
		<xsl:param name="by"/>
		<xsl:param name="type"/>

		<input type="hidden" name="{$prefix}versioning.{$type}.on" value="{$on}"/>
		<input type="hidden" name="{$prefix}versioning.{$type}.by" value="{$by}"/>
	</xsl:template>

	<!-- Chaîne de caractères -->
	<xsl:template name="string">
		<xsl:param name="gprefix"/>
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:param name="multilingual">no</xsl:param>
		<xsl:param name="readonly">false</xsl:param>
		<xsl:if test="$multilingual='yes'">
			<span class="commentaire"><xsl:value-of select="$messages[@id='page.saisie.langueassocieeauchamp']"/></span>&#160;
			<xsl:call-template name="langCombo">
				<xsl:with-param name="name" select="concat($prefix,$gprefix,$field,'.lang')"/>
				<xsl:with-param name="aLang"><xsl:if test="$value"><xsl:value-of select="$value/@xml:lang"/></xsl:if></xsl:with-param>
			</xsl:call-template>
			<br/>
		</xsl:if>
		<xsl:call-template name="textInput">
			<xsl:with-param name="name" select="$field"/>
			<xsl:with-param name="gprefix" select="$gprefix"/>
			<xsl:with-param name="value" select="$value"/>
			<xsl:with-param name="readonly" select="$readonly"/>
		</xsl:call-template>
	</xsl:template>

	<!-- E-mail -->
	<xsl:template name="email">
		<xsl:param name="gprefix"/>
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:param name="readonly">false</xsl:param>

		<xsl:call-template name="textInput">
			<xsl:with-param name="name" select="$field"/>
			<xsl:with-param name="gprefix" select="$gprefix"/>
			<xsl:with-param name="value" select="$value"/>
			<xsl:with-param name="readonly" select="$readonly"/>
		</xsl:call-template>
		<span class="commentaire"><xsl:value-of select="$messages[@id='page.saisie.email']"/></span>
		<xsl:text> </xsl:text>
		<xsl:call-template name="textInput">
			<xsl:with-param name="name" select="concat($field,'.label')"/>
			<xsl:with-param name="gprefix" select="$gprefix"/>
			<xsl:with-param name="value">
				<xsl:if test="$value">
					<xsl:value-of select="$value/@label"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="readonly" select="$readonly"/>
		</xsl:call-template>
		<span class="commentaire"><xsl:value-of select="$messages[@id='page.saisie.libelleoptionneldelemail']"/></span>
		<br/>
	</xsl:template>

	<!-- url -->
	<xsl:template name="url">
		<xsl:param name="gprefix"/>
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:param name="readonly">false</xsl:param>

		<xsl:call-template name="textInput">
			<xsl:with-param name="name" select="$field"/>
			<xsl:with-param name="gprefix" select="$gprefix"/>
			<xsl:with-param name="value" select="$value"/>
			<xsl:with-param name="readonly" select="$readonly"/>
		</xsl:call-template>
		<span class="commentaire"><xsl:value-of select="$messages[@id='page.saisie.adresseurl']"/></span>
		<xsl:text> </xsl:text>
		<xsl:call-template name="textInput">
			<xsl:with-param name="name" select="concat($field,'.label')"/>
			<xsl:with-param name="gprefix" select="$gprefix"/>
			<xsl:with-param name="value">
				<xsl:if test="$value">
					<xsl:value-of select="$value/@label"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="readonly" select="$readonly"/>
		</xsl:call-template>
		<span class="commentaire"><xsl:value-of select="$messages[@id='page.saisie.libelleoptionneldelurl']"/></span>
		<br/>
	</xsl:template>

	<!-- list items -->
	<xsl:template name="twocolsitem">
		<xsl:param name="item"/>
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="string-length($item) &gt;40">
					<xsl:value-of select="substring($item,0,40)"/>...
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$item"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<option value="{$item}"><xsl:value-of select="$display"/></option>
	</xsl:template>

	<xsl:template name="twocolsitem2">
		<xsl:param name="item"/>
		<xsl:param name="value"/>
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="string-length($item) &gt;40">
					<xsl:value-of select="substring($item,0,40)"/>...
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$item"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="count($value[text()=$item]) &gt; 0 or $value=$item">
			<option value="{$item}"><xsl:value-of select="$display"/></option>
		</xsl:if>
	</xsl:template>

	<xsl:template name="comboitem">
		<xsl:param name="item"/>
		<xsl:param name="value"/>
		<xsl:param name="mode"/>
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="string-length($item) &gt;40">
					<xsl:value-of select="substring($item,0,40)"/>...
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$item"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<option value="{$item}"><xsl:if test="(count($value[text()=$item])&gt;0 or $value=$item) or ($mode='combo' and $value='' and $item/@default='true')"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if><xsl:value-of select="$display"/></option>
	</xsl:template>

	<xsl:template name="radioitem">
		<xsl:param name="htmlmode"/>
		<xsl:param name="otherfieldname"/>
		<xsl:param name="value"/>
		<xsl:param name="mode"/>
		<xsl:param name="item"/>
		<div class="float">
			<input type="{$htmlmode}" name="{$otherfieldname}" value="{$item}">
				<xsl:if test="(count($value[text()=$item])&gt;0 or $value=$item) or ($value='' and $item/@default='true' and $mode='radio')">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$item"/>
			</input>
		</div>
	</xsl:template>
	
	<!-- Liste de choix -->
	<xsl:template name="choice">
		<xsl:param name="gprefix"/>
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:param name="list"/>
		<xsl:param name="doclang"/>
		<xsl:param name="mode"/>
		<xsl:param name="sort"/>

		<td class="saisie" valign="top">
		<xsl:variable name="listfile" select="concat('lang/liste/',$doclang,'/',$doclang,'_',$list,'.xml')"/>
		<xsl:variable name="url" select="concat($rootUrl,'terms_',$dbId,'?hpp=-1&amp;field=',$field)"/>
		<xsl:variable name="otherfieldname" select="concat($prefix,$gprefix,$field)"/>
		<xsl:variable name="selectsize">
			<xsl:call-template name="listSize">
				<xsl:with-param name="name" select="$field"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<!-- 2 colonnes -->
			<xsl:when test="$mode='2cols'">
				<table border="0">
				<tr>
				<td>
				<select multiple="multiple" size="{$selectsize}" onkeydown="return xfm_selectKeydown (this, this.form[&quot;{$otherfieldname}&quot;]);" type="text" onblur="if (window.xfm_blur) xfm_blur(this);" onfocus="if (window.xfm_focus) xfm_focus(this);">
				 	<xsl:choose>
						<!-- Liste externe -->
						<xsl:when test="$list != ''">
							<xsl:variable name="elts" select="document($listfile)/list/item"/>
							<xsl:choose>
								<xsl:when test="$sort='true'">
									<xsl:for-each select="$elts">
										<xsl:sort/>
										<xsl:call-template name="twocolsitem">
											<xsl:with-param name="item" select="."/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="$elts">
										<xsl:call-template name="twocolsitem">
											<xsl:with-param name="item" select="."/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<!-- Liste ouverte -->
						<xsl:otherwise>
							<xsl:variable name="elts" select="document($url)/sdx:document/sdx:terms/sdx:term"/>
							<xsl:for-each select="$elts">
								<xsl:variable name="current" select="@value"/>
								<xsl:variable name="display">
									<xsl:choose>
										<xsl:when test="string-length(@value) &gt;40">
											<xsl:value-of select="substring(@value,0,40)"/>...
										</xsl:when>
										<xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<option value="{@value}"><xsl:value-of select="$display"/></option>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</select>
				</td>
				<td>
				<input type="button" value=" &gt; " onclick="for (var i=0; this.form.length; i++) if (this.form[i]==this) break; xfm_selectAdd(this.form[i-1],this.form[&quot;{$otherfieldname}&quot;]); "/>
				</td>
				<td>
				<input type="hidden" name="{$prefix}2cols.id" value="{$otherfieldname}"/>
				<select multiple="multiple" size="{$selectsize}" onkeydown="return xfm_selectKeydown(this)" type="text" onblur="if (window.xfm_blur) xfm_blur(this);" onfocus="if (window.xfm_focus) xfm_focus(this);" name="{$otherfieldname}">
				 	<xsl:choose>
						<!-- Liste externe -->
						<xsl:when test="$list != ''">
							<xsl:variable name="elts" select="document($listfile)/list/item"/>
							<xsl:choose>
								<xsl:when test="$sort='true'">
									<xsl:for-each select="$elts">
										<xsl:sort/>
										<xsl:call-template name="twocolsitem2">
											<xsl:with-param name="item" select="."/>
											<xsl:with-param name="value" select="$value"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="$elts">
										<xsl:call-template name="twocolsitem2">
											<xsl:with-param name="item" select="."/>
											<xsl:with-param name="value" select="$value"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<!-- Liste ouverte -->
						<xsl:otherwise>
							<xsl:variable name="elts" select="document($url)/sdx:document/sdx:terms/sdx:term"/>
							<xsl:for-each select="$elts">
								<xsl:variable name="current" select="@value"/>
								<xsl:variable name="display">
									<xsl:choose>
										<xsl:when test="string-length(@value) &gt;40">
											<xsl:value-of select="substring(@value,0,40)"/>...
										</xsl:when>
										<xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:if test="count($value[text()=$current]) &gt; 0 or $value=$current">
									<option value="{@value}"><xsl:value-of select="$display"/></option>
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</select>
				</td>
				<td>
                <input type="button" value=" - " onclick="optionDel(this.form[&quot;{$otherfieldname}&quot;]); "/><br/>
                <input type="button" value=" ^ " onclick="optionUp(this.form[&quot;{$otherfieldname}&quot;]); "/><br/>
                <input type="button" value=" v " onclick="optionDown(this.form[&quot;{$otherfieldname}&quot;]); "/><br/>
				<input type="button" value=" 0 " onclick="xfm_selectReset(this.form[&quot;{$otherfieldname}&quot;]); "/>
				</td>
				</tr>
				</table>

			</xsl:when>

			<!-- Mode combo -->
			<xsl:when test="$mode='Mcombo' or $mode='combo'">
				<xsl:if test="$value != '' and $list != ''">
					<xsl:variable name="elts" select="document($listfile)/list/item"/>
					<xsl:choose>
						<xsl:when test="count($value)!=0">
							<xsl:for-each select="$value">
								<xsl:variable name="current" select="."/>
								<xsl:if test="count($elts[text()=$current]) = 0">
									<div class="float">
									<span class="notinlist"><xsl:value-of select="$current"/></span>
										<input type="checkbox" name="{$otherfieldname}" value="{$current}" checked="checked"/>
									</div>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="count($elts[text()=$value]) = 0">
								<div class="float">
								<span class="notinlist"><xsl:value-of select="$value"/></span>
									<input type="checkbox" name="{$otherfieldname}" value="{$value}" checked="checked"/>
								</div>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<select name="{$otherfieldname}">
					<xsl:if test="$mode='Mcombo'">
						<xsl:attribute name="multiple">multiple</xsl:attribute>
						<xsl:attribute name="size"><xsl:value-of select="$selectsize"/></xsl:attribute>
					</xsl:if>
					<option value="---">---</option>
					<xsl:choose>
						<!-- Liste externe -->
						<xsl:when test="$list != ''">
							<xsl:variable name="elts" select="document($listfile)/list/item"/>
							<xsl:choose>
								<xsl:when test="$sort='true'">
									<xsl:for-each select="$elts">
										<xsl:sort/>
										<xsl:call-template name="comboitem">
											<xsl:with-param name="item" select="."/>
											<xsl:with-param name="value" select="$value"/>
											<xsl:with-param name="mode" select="$mode"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="$elts">
										<xsl:call-template name="comboitem">
											<xsl:with-param name="item" select="."/>
											<xsl:with-param name="value" select="$value"/>
											<xsl:with-param name="mode" select="$mode"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!-- Liste ouverte -->
						<xsl:otherwise>
							<xsl:variable name="elts" select="document($url)/sdx:document/sdx:terms/sdx:term"/>
							<xsl:for-each select="$elts">
								<xsl:variable name="current" select="@value"/>
								<xsl:variable name="display">
									<xsl:choose>
										<xsl:when test="string-length(@value) &gt;40">
											<xsl:value-of select="substring(@value,0,40)"/>...
										</xsl:when>
										<xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<option value="{@value}"><xsl:if test="count($value[text()=$current])&gt;0 or $value=$current"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if><xsl:value-of select="$display"/></option>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</select>
			</xsl:when>

			<!-- Mode radio ou checkbox -->
			<xsl:when test="$mode='check' or $mode='radio'">
				<xsl:variable name="htmlmode">
					<xsl:choose>
						<xsl:when test="$mode='check'">checkbox</xsl:when>
						<xsl:otherwise>radio</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$mode='radio'">
					<div class="float">
					<input type="radio" name="{$otherfieldname}" value="" checked="checked"><i><xsl:value-of select="$messages[@id='page.search.aucuneselection']"/></i></input>
					</div>
				</xsl:if>
				<xsl:variable name="terms" select="document($url)/sdx:document/sdx:terms/sdx:term"/>
				<xsl:choose>
					<!-- Liste externe -->
					<xsl:when test="$list != ''">
						<xsl:variable name="items" select="document($listfile)/list/item"/>
						<xsl:if test="$value != ''">
							<xsl:choose>
								<xsl:when test="count($value)!=0">
									<xsl:for-each select="$value">
										<xsl:variable name="current" select="."/>
										<xsl:if test="count($items[text()=$current]) = 0">
											<div class="float">
											<span class="notinlist"><xsl:value-of select="$current"/></span>
												<input type="checkbox" name="{$otherfieldname}" value="{$current}" checked="checked"/>
											</div>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="count($items[text()=$value]) = 0">
										<div class="float">
										<span class="notinlist"><xsl:value-of select="$value"/></span>
											<input type="checkbox" name="{$otherfieldname}" value="{$value}" checked="checked"/>
										</div>
									</xsl:if>

								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="count($items)=0">
							<span class="warning"><xsl:value-of select="$messages[@id='common.pasdevaleurdisponible']"/></span>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="$sort='true'">
								<xsl:for-each select="$items">
									<xsl:sort/>
									<xsl:call-template name="radioitem">
										<xsl:with-param name="item" select="."/>
										<xsl:with-param name="value" select="$value"/>
										<xsl:with-param name="mode" select="$mode"/>
										<xsl:with-param name="otherfieldname" select="$otherfieldname"/>
										<xsl:with-param name="htmlmode" select="$htmlmode"/>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$items">
									<xsl:call-template name="radioitem">
										<xsl:with-param name="item" select="."/>
										<xsl:with-param name="value" select="$value"/>
										<xsl:with-param name="mode" select="$mode"/>
										<xsl:with-param name="otherfieldname" select="$otherfieldname"/>
										<xsl:with-param name="htmlmode" select="$htmlmode"/>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<!-- Liste ouverte -->
					<xsl:otherwise>
						<xsl:if test="$mode='check' and count($terms) = 0">
							<div class="float">
							<i><xsl:value-of select="$messages[@id='page.search.aucuneselection']"/></i>
							</div>
						</xsl:if>
						<xsl:for-each select="$terms">
							<xsl:variable name="val" select="@value"/>
							<div class="float">
								<input type="{$htmlmode}" name="{$otherfieldname}" value="{@value}">
									<xsl:if test="count($value[text()=$val]) &gt; 0 or $value=$val">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="@value"/>
								</input>
							</div>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		</td><td class="saisie" valign="top">
		<xsl:if test="$list=''">
			<span class="commentaire">
				<xsl:value-of select="$messages[@id='page.saisie.valeursupplementaire']"/>
			</span>
			<br/>
			<xsl:call-template name="textInput">
				<xsl:with-param name="name" select="concat($field,'.text')"/>
				<xsl:with-param name="gprefix" select="$gprefix"/>
			</xsl:call-template>
		</xsl:if>
		</td>
	</xsl:template>

	<!-- Relation -->
	<xsl:template name="relation">
		<xsl:param name="gprefix"/>
		<xsl:param name="value"/>
		<xsl:param name="field"/>
		<xsl:param name="mode"/>

		<xsl:variable name="db" select="$relations/relation[@doc=$dbId and @field=$field]"/>
		<xsl:variable name="titlefield" select="$titlefields/dbase[@id=$db]"/>
		<xsl:variable name="url" select="concat($rootUrl,'query_',$db,'?f=sdxall&amp;v=1&amp;hpp=-1&amp;sortfield=xtgtitle')"/>
		<xsl:variable name="selectsize">
			<xsl:call-template name="listSize">
				<xsl:with-param name="name" select="$field"/>
			</xsl:call-template>
		</xsl:variable>
		<td colspan="2" class="saisie">
		<select name="{$prefix}{$gprefix}{$field}">
			<xsl:if test="$mode='Mcombo'">
				<xsl:attribute name="multiple">multiple</xsl:attribute>
				<xsl:attribute name="size"><xsl:value-of select="$selectsize"/></xsl:attribute>
			</xsl:if>
			<option value="---">---</option>
			<xsl:for-each select="document($url)/sdx:document/sdx:results/sdx:result">
				<xsl:element name="option">
					<xsl:variable name="current" select="sdx:field[@name='sdxdocid']/@value"/>
					<xsl:attribute name="value"><xsl:value-of select="$current"/></xsl:attribute>
					<xsl:if test="count($value[text()=$current]) &gt; 0 or $value=$current">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:variable name="v" select="sdx:field[@name=$titlefield]/@value"/>
					<xsl:choose>
						<xsl:when test="string-length($v) &gt;40">
							<xsl:value-of select="substring($v,0,40)"/>...
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="$v"/></xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:for-each>
		</select>
		</td>
	</xsl:template>

	<!-- Texte libre -->
	<xsl:template name="text">
		<xsl:param name="gprefix"/>
		<xsl:param name="field"/>
		<xsl:param name="value"/>
		<xsl:param name="multilingual">no</xsl:param>

		<xsl:if test="$multilingual='yes'">
			<span class="commentaire"><xsl:value-of select="$messages[@id='page.saisie.langueassocieeauchamp']"/></span>&#160;
			<xsl:call-template name="langCombo">
				<xsl:with-param name="name" select="concat($prefix,$gprefix,$field,'.lang')"/>
				<xsl:with-param name="aLang"><xsl:if test="$value"><xsl:value-of select="$value/@xml:lang"/></xsl:if></xsl:with-param>
			</xsl:call-template>
			<br/>
		</xsl:if>
		<xsl:call-template name="areaInput">
			<xsl:with-param name="name" select="$field"/>
			<xsl:with-param name="gprefix" select="$gprefix"/>
			<xsl:with-param name="value" select="$value"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Pour éviter l'affichage du namespace -->
	<xsl:template match="node()" mode="copy">
		<xsl:choose>
			<xsl:when test="name() != ''">
				<xsl:element name="{name()}">
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates select="node()" mode="copy"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@* | node()" mode="copy"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> 

	<!-- List thumbnail -->
	<xsl:template name="listthumb">
		<xsl:variable name="files" select="document(concat($rootUrl,'list_attach_',$dbId))/dir:directory"/>
		<xsl:for-each select="$files/dir:file">
			<xsl:variable name="len" select="string-length(@name)"/>
			<!-- Vérification de la longueur du nom de fichier -->
			<xsl:if test="$len &gt; 4">
				
				<xsl:variable name="minus" select="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
				<xsl:variable name="ext3" select="substring($minus, $len - 3)"/>
				<xsl:variable name="ext4" select="substring($minus, $len - 4)"/>
				<!-- Vérification de l'extension -->
				<xsl:if test="$ext3='.png' or $ext3='.gif' or $ext3='.jpg' or $ext4='.jpeg'">
					<option value="attach/{@name}"><xsl:value-of select="@name"/></option>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- attach -->
	<xsl:template name="attach">
		<xsl:param name="gprefix"/>
		<xsl:param name="field"/>
		<xsl:param name="mode"/>
		<xsl:param name="value"/>
		<xsl:param name="docid"/>

		<table border="0" bgcolor="#e0e0e0" width="100%">
		<xsl:variable name="files" select="document(concat($rootUrl,'list_attach_',$dbId))/dir:directory"/>
		<xsl:choose>
			<!-- Document attaché valué -->
			<xsl:when test="$value != ''">
				<xsl:variable name="id" select="generate-id($value)"/>
				<tr>
				<td class="saisie">
					<xsl:if test="$mode!='browser'">
					<xsl:value-of select="$messages[@id='page.saisie.fichierattache']"/> :
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$mode='upload'">
							<b>
							<xsl:choose>
								<xsl:when test="starts-with($value,'attach/')"><xsl:value-of select="substring-after($value,'attach/')"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
							</xsl:choose>
							</b><br/>
							<input type="hidden" name="{$prefix}{$gprefix}{$field}" value="{$value}"/>
						</xsl:when>
						<xsl:when test="$mode='browser'">
							<input type="text" id="{$prefix}{$gprefix}{$field}_{$id}" name="{$prefix}{$gprefix}{$field}" value="{$value}"/><xsl:text> </xsl:text>
							<input type="button" value="{$messages[@id='page.admin.navigateurdepiecesattachees']}..." onClick="openBrowser('{$prefix}{$gprefix}{$field}_{$id}')"/><br/>
						</xsl:when>
						<xsl:otherwise>
							<select name="{$prefix}{$gprefix}{$field}">
								<option value="{$value}" selected="selected">-&gt; <xsl:value-of select="$value"/></option>
								<xsl:for-each select="$files/dir:file">
									<option value="attach/{@name}"><xsl:value-of select="@name"/></option>
								</xsl:for-each>
							</select><br/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$mode='link'">
							<xsl:value-of select="$messages[@id='page.saisie.icone']"/> :
							<select name="{$prefix}{$gprefix}{$field}.thn">
								<option value="{$value/@thn}" selected="selected">-&gt; <xsl:value-of select="$value/@thn"/></option>
								<xsl:call-template name="listthumb"/>
							</select><br/>
							<xsl:value-of select="$messages[@id='page.saisie.libelle']"/> :
							<xsl:call-template name="textInput">
								<xsl:with-param name="name" select="concat($field,'.label')"/>
								<xsl:with-param name="gprefix" select="$gprefix"/>
								<xsl:with-param name="value" select="$value/@label"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$mode='upload'">
							<xsl:if test="$value/@thn">
								<input type="hidden" name="{$prefix}{$gprefix}{$field}.thn" value="{$value/@thn}"/>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
					<input type="hidden" name="{$prefix}{$gprefix}{$field}.tag" value="{$id}"/>
					<input type="checkbox" name="{$prefix}{$gprefix}{$field}.delete" value="{$id}"><span class="commentaire"><xsl:value-of select="$messages[@id='page.saisie.retirerlefichierattache']"/></span></input>
				</td>
				<td>
					<!-- L'url de l'image à afficher -->
					<xsl:variable name="thnsize">
						<xsl:choose>
							<xsl:when test="$conf_disp/documenttypes/documenttype[@id=$dbId]/edit/on[@field=$field and @thnsize]">
								<xsl:value-of select="$conf_disp/documenttypes/documenttype[@id=$dbId]/edit/on[@field=$field]/@thnsize"/>
							</xsl:when>
							<xsl:otherwise>150x150</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="imgurl">
						<xsl:choose>
							<xsl:when test="$mode='upload' or $mode='browser'"><xsl:value-of select="concat($rootUrl,'thumbnail?app=',$urlparameter[@name='app']/@value,'&amp;base=',$dbId,'&amp;id=',$value,'&amp;size=',$thnsize)"/></xsl:when>
							<xsl:when test="$mode='link'"><xsl:value-of select="concat(/sdx:document/@api-url,'/getatt?app=',$urlparameter[@name='app']/@value,'&amp;base=',$dbId,'&amp;doc=',$docid,'&amp;id=',$value/@thn)"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="concat(/sdx:document/@api-url,'/getatt?app=',$urlparameter[@name='app']/@value,'&amp;db=',$dbId,'&amp;doc=',$docid,'&amp;id=',$value)"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="($mode='link' and $value/@thn) or ($mode='inline' and $value) or ($mode='upload' or $mode='browser')">
						<img alt="{$imgurl}" id="{$prefix}{$gprefix}{$field}_{$id}_img" src="{$imgurl}"/>
					</xsl:if>
				</td>
				</tr>
			</xsl:when>

			<!-- Pièce attachée à saisir -->
			<xsl:otherwise>
				
				<tr><td class="saisie">
				<xsl:if test="$mode!='browser'">
				<xsl:value-of select="$messages[@id='page.saisie.fichierattache']"/> :
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$mode='inline' or $mode='link'">
						<select name="{$prefix}{$gprefix}{$field}">
							<option value="">---</option>
							<xsl:for-each select="$files/dir:file">
								<option value="attach/{@name}"><xsl:value-of select="@name"/></option>
							</xsl:for-each>
						</select>
					</xsl:when>
					<xsl:when test="$mode='browser'">
						<input type="text" id="{$prefix}{$gprefix}{$field}_empty" name="{$prefix}{$gprefix}{$field}"/><xsl:text> </xsl:text>
						<input type="button" value="{$messages[@id='page.admin.navigateurdepiecesattachees']}..." onClick="openBrowser('{$prefix}{$gprefix}{$field}_empty')"/>
					</xsl:when>
					<xsl:when test="$mode='upload'">
						<input type="file" name="{$prefix}{$gprefix}{$field}.upload"/>
					</xsl:when>
				</xsl:choose>
				<br/>

				<xsl:if test="$mode='link'">
					<xsl:value-of select="$messages[@id='page.saisie.icone']"/> :
					<select name="{$prefix}{$gprefix}{$field}.thn">
						<option value="">---</option>
						<xsl:call-template name="listthumb"/>
					</select>
					<br/>
					<xsl:value-of select="$messages[@id='page.saisie.libelle']"/> :
					<xsl:call-template name="textInput">
						<xsl:with-param name="name" select="concat($field,'.label')"/>
						<xsl:with-param name="gprefix" select="$gprefix"/>
					</xsl:call-template>
					<br/>
					<span class="commentaire"><xsl:value-of select="$messages[@id='page.saisie.commentairefichierattache']"/></span>
				</xsl:if>
				</td>
			<td>
				<img id="{$prefix}{$gprefix}{$field}_empty_img" alt="blank" src="icones/transparent.png"/>
			</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
		</table>
		<br/>
	</xsl:template>

	<xsl:template name="lastElement">
		<xsl:param name="str"/>
		<xsl:param name="sep"/>

		<xsl:choose>
			<xsl:when test="contains($str,$sep)">
				<xsl:call-template name="lastElement">
					<xsl:with-param name="str" select="substring-after($str,$sep)"/>
					<xsl:with-param name="sep" select="$sep"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="fieldgroupfooter">
		<xsl:param name="withoutdeletecheck"/>
		<xsl:param name="gprefix"/>
		<xsl:param name="name"/>
		<xsl:param name="value"/>

		<xsl:variable name="gprefixwtu" select="substring($gprefix,1,string-length($gprefix)-1)"/>
		<xsl:variable name="deleteid">
			<xsl:call-template name="lastElement">
				<xsl:with-param name="sep" select="'_'"/>
				<xsl:with-param name="str" select="$gprefixwtu"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="myprefix">
			<xsl:choose>
				<xsl:when test="string-length($gprefix)=(string-length($deleteid)+1)"></xsl:when>
				<xsl:otherwise><xsl:value-of select="concat(substring($gprefixwtu,1,string-length($gprefixwtu)-string-length($deleteid)-1),'_')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!--
		<b>GP = [<xsl:value-of select="$gprefix"/>]</b><br/>
		<b>DI = [<xsl:value-of select="$deleteid"/>]</b><br/>
		<b>MYPREFIX = [<xsl:value-of select="$myprefix"/>]</b>
		-->

		<input type="hidden" name="{$prefix}{$myprefix}{$name}.tag" value="{$deleteid}"/>
		<xsl:if test="not($withoutdeletecheck)">
		<span class="commentaire"><xsl:value-of select="$messages[@id='page.saisie.supprimerlegroupe']"/></span><input type="checkbox" name="{$prefix}{$myprefix}{$name}.delete" value="{$deleteid}"/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
