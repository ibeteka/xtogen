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
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sdx="http://www.culture.gouv.fr/ns/sdx/sdx"
	exclude-result-prefixes = "sdx xsl"
>

	<xsl:include href="common.xsl"/>

	<xsl:variable name="dbParam" select="$urlparameter[@name='db']/@value"/>
	<xsl:variable name="useJavaScript" select="count(/sdx:document/recherche[@db=$dbParam]/zone[@mode='2cols']) != 0"/>

	<xsl:variable name="docDisplay" select="document('config_display.xml')/configuration_display/documenttypes/documenttype[@id=$dbParam]/search"/>

	<!-- Taille des champs input/select -->
	<xsl:variable name="globalInputSize">
		<xsl:choose>
			<xsl:when test="$docDisplay/global/input/@size"><xsl:value-of select="$docDisplay/global/input/@size"/></xsl:when>
			<xsl:otherwise>40</xsl:otherwise>
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

		<xsl:variable name="size">
			<xsl:choose>
				<xsl:when test="$docDisplay/on[@field=$name]/@size"><xsl:value-of select="$docDisplay/on[@field=$name]/@size"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$globalInputSize"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<input type="text" name="{$wordfieldprefix}{$name}" size="{$size}"/>
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

	function xfm_submit(form)
	{
		<xsl:for-each select="/sdx:document/recherche[@db=$dbParam]/zone[@mode='2cols']">
			<xsl:variable name="fieldname">
				<xsl:choose>
					<xsl:when test="@list"><xsl:value-of select="concat($choicefieldprefix,@name)"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			if (form.<xsl:value-of select="$fieldname"/>)
			{
				if (form.<xsl:value-of select="$fieldname"/>.length == 0)
					optionAdd(form.<xsl:value-of select="$fieldname"/>,"---","");
				selectAll(form.<xsl:value-of select="$fieldname"/>);
			}
		</xsl:for-each>

		return true;
	}
	
	function xfm_reset(form)
	{
	
	}

    </script>
	</xsl:if>
	</xsl:template>

<xsl:template name="isInter">
	<xsl:param name="terms"/>
	<xsl:param name="items"/>
	<xsl:choose>
	<xsl:when test="count($terms)=0">no</xsl:when>
	<xsl:when test="count($items)=0">no</xsl:when>
	<xsl:when test="count($items[@id=$terms[1]/@value])!=0">yes</xsl:when>
	<xsl:otherwise><xsl:call-template name="isInter"><xsl:with-param name="terms" select="$terms/following-sibling::*"/><xsl:with-param name="items" select="$items"/></xsl:call-template></xsl:otherwise>
	</xsl:choose>
</xsl:template>

	<xsl:template match="recherche">
		<xsl:variable name="dbId" select="@db"/>
		<xsl:choose>
			<xsl:when test="$dbParam=$dbId">
				<h2><xsl:value-of select="$messages[@id='bouton.recherche']"/></h2>
				<h3><xsl:value-of select="$labels/doctype[@name=$dbId]/label"/>
					<xsl:if test="location">
					&#160;<small>
					(<xsl:for-each select="location">
						<xsl:if test="position() != 1">, </xsl:if>
						<xsl:value-of select="@app"/>
					</xsl:for-each>)</small></xsl:if></h3>
				<br/>
				<fieldset>
					<legend><xsl:value-of select="$messages[@id='common.recherchepleintexte']"/></legend>
					<form action="ft_search_{@db}.xsp" method="GET">
						<input type="hidden" name="f" value="{concat('xtgpleintexte_',translate($lang,'-','_'))}"/>
						<input type="hidden" name="sortfield" value="xtgtitle"/>
						<input type="text" name="v"/>
						<input type="submit" value="{$messages[@id='page.search.rechercher']}"/>
					</form>
				</fieldset>
				</xsl:if>
				<br/>
				<fieldset>
					<legend><xsl:value-of select="$messages[@id='common.recherchedetaillee']"/></legend>
				<table border="0">
				<form action="search_{@db}.xsp" method="GET">
					<xsl:if test="$useJavaScript">
						<xsl:attribute name="onsubmit">if (window.xfm_submit) return xfm_submit(this);</xsl:attribute>
					</xsl:if>
					<input type="hidden" name="sortfield" value="{$currentdoctypedefaultsortfield}"/>
					<input type="hidden" name="order" value="ascendant"/>
					<input type="hidden" name="qlang" value="{$lang}"/>
					<xsl:for-each select="zone">
						<tr>
							<xsl:apply-templates select="."/>
						</tr>
					</xsl:for-each>
					<tr>
					<td colspan="4">
						<span class="commentaire"><xsl:value-of select="$messages[@id='page.search.operateuraappliquerentrelescriteresderecherchesurlesdifferentschamps']"/></span>
						<br/>
						<input type="radio" name="complex.query.op" value="or" checked="checked"><xsl:value-of select="$messages[@id='common.ou']"/></input>
						<input type="radio" name="complex.query.op" value="and"><xsl:value-of select="$messages[@id='common.et']"/></input>
					</td>
					</tr>
					<tr><td colspan="4">
						<xsl:choose>
							<xsl:when test="$useJavaScript">
								<input type="submit" onblur="if (window.xfm_blur) xfm_blur(this);" onfocus="if (window.xfm_focus) xfm_focus(this);" value="{$messages[@id='page.search.rechercher']}"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="submit" value="{$messages[@id='page.search.rechercher']}"/>
							</xsl:otherwise>
						</xsl:choose>
						<input type="reset" value="{$messages[@id='page.search.reinitialiser']}"/>
					</td></tr>
				</form>
				</table>
				</fieldset>
			</xsl:when>
			<!-- pas de parametre db :-( -->
			<xsl:when test="count($urlparameter[@name='db']) = 0">
				<xsl:if test="../recherche[1]/@db = $dbId">
					<h2><xsl:value-of select="$messages[@id='bouton.recherche']"/></h2>
				</xsl:if>
				<a class="nav" href="search.xsp?db={$dbId}"><xsl:value-of select="$messages[@id='page.search.recherchedans']"/>&#160;<xsl:value-of select="@db"/></a>&#160;
				<xsl:if test="location"><small>(<xsl:for-each select="location"><xsl:if test="position()!=1">, </xsl:if><xsl:value-of select="@app"/></xsl:for-each>)</small></xsl:if><br/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- champ de type texte -->
	<xsl:template match="zone[@type='texte']">
		<xsl:variable name="dbId" select="../@db"/>
		<xsl:variable name="fieldname">
			<xsl:choose>
				<xsl:when test="starts-with(@name, $wordfieldprefix)">
					<xsl:value-of select="substring-after(@name,$wordfieldprefix)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<td><xsl:value-of select="$labels/doctype[@name=$dbId]/field[@name=$fieldname]"/></td>
		<td>
			<xsl:if test="@lang='multi'">
				<span class="commentaire"><xsl:value-of select="$messages[@id='page.search.languederechercheduchamp']"/></span>&#160;
				<xsl:call-template name="langCombo">
					<xsl:with-param name="name" select="concat(@name,'.lang')"/>
				</xsl:call-template>
				<br/>
			</xsl:if>
			<xsl:call-template name="textInput">
				<xsl:with-param name="name" select="$fieldname"/>
			</xsl:call-template>
		</td>
	</xsl:template>

	<!-- list item templates -->
	<xsl:template name="optionitem">
		<xsl:param name="item"/>
		<xsl:param name="terms"/>
		<xsl:variable name="id" select="$item/@id"/>
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="string-length($item) &gt; 40">
					<xsl:value-of select="substring($item,0,40)"/>...
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$item"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="count($terms[@value=$id]) &gt; 0">
			<option value="{$id}"><xsl:value-of select="$display"/></option>
		</xsl:if>
	</xsl:template>

	<xsl:template name="inputitem">
		<xsl:param name="item"/>
		<xsl:param name="terms"/>
		<xsl:param name="htmlmode"/>
		<xsl:param name="otherfieldname"/>
		<xsl:variable name="id" select="$item/@id"/>
		<xsl:if test="count($terms[@value=$id]) &gt; 0">
			<div class="float">
				<input type="{$htmlmode}" name="{$otherfieldname}" value="{$id}"><xsl:value-of select="$item"/></input>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- champ de type choix -->
	<xsl:template match="zone[@type='choice']">
		<xsl:variable name="dbId" select="../@db"/>
		<xsl:variable name="fieldname" select="@name"/>

		<xsl:variable name="otherfieldname">
			<xsl:choose>
				<xsl:when test="@list"><xsl:value-of select="concat($choicefieldprefix,@name)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="mode" select="@mode"/>

		<xsl:variable name="sort">
			<xsl:choose>
				<xsl:when test="@sort='true'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="url" select="concat(/sdx:document/@server,'/',/sdx:document/@appbypath,'/terms_',$dbId,'?hpp=-1&amp;field=',$otherfieldname)"/>
		<xsl:variable name="terms" select="document($url)/sdx:document/sdx:terms/sdx:term"/>
		<xsl:variable name="liste" select="document(concat('lang/liste/',$lang,'/',$lang,'_',@list,'.xml'))/list"/>
		<xsl:variable name="isInter">
			<xsl:call-template name="isInter">
				<xsl:with-param name="terms" select="$terms"/>
				<xsl:with-param name="items" select="$liste/item"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="empty">
			<xsl:choose>
				<!-- Liste non contrôlée et pas de valeurs portées par
					 les documents -->
				<xsl:when test="not(@list) and count($terms)=0">yes</xsl:when>

				<!-- Liste controlée mais vide -->
				<xsl:when test="@list and count($liste/item)=0">yes</xsl:when>

				<!-- Liste controlée non vide mais intersection vide -->
				<xsl:when test="@list and $isInter='no'">yes</xsl:when>

				<!-- Sinon c'est plein -->
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<td valign="top">
			<xsl:value-of select="$labels/doctype[@name=$dbId]/field[@name=$fieldname]"/>
		</td>

		<td>
		<xsl:variable name="selectsize">
			<xsl:call-template name="listSize">
				<xsl:with-param name="name" select="$fieldname"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<!-- 2 colonnes -->
			<xsl:when test="$mode='2cols' and $empty='no'">
				<table border="0">
				<tr>
				<td>
				<select multiple="multiple" size="{$selectsize}" onkeydown="return xfm_selectKeydown (this, this.form.{$otherfieldname});" type="text" onblur="if (window.xfm_blur) xfm_blur(this);" onfocus="if (window.xfm_focus) xfm_focus(this);">
					<xsl:choose>
						<!-- liste externe -->
						<xsl:when test="@list">
							<xsl:choose>
								<xsl:when test="$sort='true'">
									<xsl:for-each select="$liste/item">
										<xsl:sort/>
										<xsl:call-template name="optionitem">
											<xsl:with-param name="item" select="."/>
											<xsl:with-param name="terms" select="$terms"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="$liste/item">
										<xsl:call-template name="optionitem">
											<xsl:with-param name="item" select="."/>
											<xsl:with-param name="terms" select="$terms"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!-- liste ouverte -->
						<xsl:otherwise>
							<xsl:for-each select="$terms">
								<xsl:variable name="display">
									<xsl:choose>
										<xsl:when test="string-length(@value) &gt; 40">
											<xsl:value-of select="substring(@value,0,40)"/>...
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@value"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<option value="{@value}"><xsl:value-of select="$display"/></option>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</select>
				</td>
				<td>
				<input type="button" value=" &gt; " onclick="for (var i=0; this.form.length; i++) if (this.form[i]==this) break; xfm_selectAdd(this.form[i-1],this.form.{$otherfieldname}); "/>
				</td>
				<td>
				<select multiple="multiple" size="{$selectsize}" onkeydown="return xfm_selectKeydown(this)" type="text" onblur="if (window.xfm_blur) xfm_blur(this);" onfocus="if (window.xfm_focus) xfm_focus(this);" name="{$otherfieldname}"/>
				</td>
				<td>
                <input type="button" value=" - " onclick="optionDel(this.form.{$otherfieldname}); "/><br/>
                <input type="button" value=" ^ " onclick="optionUp(this.form.{$otherfieldname}); "/><br/>
                <input type="button" value=" v " onclick="optionDown(this.form.{$otherfieldname}); "/><br/>
				<input type="button" value=" 0 " onclick="xfm_selectReset(this.form.{$otherfieldname}); "/>
				</td>
				</tr>
				</table>
			</xsl:when>

			<!-- Multiple combo or combo -->
			<xsl:when test="($mode='Mcombo' or $mode='combo') and $empty='no'">
				<table border="0">
				<tr><td valign="top">
				<select name="{$otherfieldname}">
					<xsl:if test="$mode='Mcombo'">
						<xsl:attribute name="multiple">multiple</xsl:attribute>
						<xsl:attribute name="size"><xsl:value-of select="$selectsize"/></xsl:attribute>
					</xsl:if>
					<option value="" selected="selected">---</option>
					<xsl:choose>
						<!-- liste externe -->
						<xsl:when test="@list">
							<xsl:choose>
								<xsl:when test="$sort='true'">
									<xsl:for-each select="$liste/item">
										<xsl:sort/>
										<xsl:call-template name="optionitem">
											<xsl:with-param name="item" select="."/>
											<xsl:with-param name="terms" select="$terms"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="$liste/item">
										<xsl:call-template name="optionitem">
											<xsl:with-param name="item" select="."/>
											<xsl:with-param name="terms" select="$terms"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!-- liste ouverte -->
						<xsl:otherwise>
							<xsl:for-each select="$terms">
								<xsl:variable name="display">
									<xsl:choose>
										<xsl:when test="string-length(@value) &gt; 40">
											<xsl:value-of select="substring(@value,0,40)"/>...
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@value"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<option value="{@value}"><xsl:value-of select="$display"/></option>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</select>
				</td>
				<td valign="top">
					<xsl:if test="$mode='Mcombo' and $empty='no'">
						<span class="commentaire"><xsl:value-of select="$messages[@id='page.search.operateuraappliquerentrelesvaleursdelaliste']"/></span><br/>
						<input type="radio" name="{@name}.op" value="or" checked="checked"><xsl:value-of select="$messages[@id='common.ou']"/></input>
						<input type="radio" name="{@name}.op" value="and"><xsl:value-of select="$messages[@id='common.et']"/></input>
					</xsl:if>
				</td></tr>
				</table>
			</xsl:when>

			<!-- Check boxes or radio -->
			<xsl:when test="($mode='check' or $mode='radio') and $empty='no'">
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
				<xsl:choose>
					<!-- liste externe -->
					<xsl:when test="@list">
						<xsl:choose>
							<xsl:when test="$sort='true'">
								<xsl:for-each select="$liste/item">
									<xsl:sort/>
									<xsl:call-template name="inputitem">
										<xsl:with-param name="item" select="."/>
										<xsl:with-param name="terms" select="$terms"/>
										<xsl:with-param name="htmlmode" select="$htmlmode"/>
										<xsl:with-param name="otherfieldname" select="$otherfieldname"/>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$liste/item">
									<xsl:call-template name="inputitem">
										<xsl:with-param name="item" select="."/>
										<xsl:with-param name="terms" select="$terms"/>
										<xsl:with-param name="htmlmode" select="$htmlmode"/>
										<xsl:with-param name="otherfieldname" select="$otherfieldname"/>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- liste ouverte -->
					<xsl:otherwise>
						<xsl:for-each select="$terms">
							<div class="float">
								<input type="{$htmlmode}" name="{$otherfieldname}" value="{@value}"><xsl:value-of select="@value"/></input>
							</div>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$empty='yes'">
				<div class="warning"><xsl:value-of select="$messages[@id='common.pasdevaleurdisponible']"/></div>
			</xsl:when>
		</xsl:choose>
		</td>
		<td>
		<xsl:choose>
			<xsl:when test="($mode='check' or $mode='2cols') and $empty='no'">
				<span class="commentaire"><xsl:value-of select="$messages[@id='page.search.operateuraappliquerentrelesvaleursdelaliste']"/></span><br/>
				<input type="radio" name="{@name}.op" value="or" checked="checked"><xsl:value-of select="$messages[@id='common.ou']"/></input>
				<input type="radio" name="{@name}.op" value="and"><xsl:value-of select="$messages[@id='common.et']"/></input>
			</xsl:when>
			<xsl:when test="$mode='check'"/>
			<xsl:otherwise>
				<input type="hidden" name="{@name}.op" value="or"/>
			</xsl:otherwise>
		</xsl:choose>
		</td>
	</xsl:template>


</xsl:stylesheet>
