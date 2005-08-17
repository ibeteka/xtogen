// Ce fichier de fonctions JavaScript a été récupéré
// du code de l'administration des applications SDX
// Auteurs : AJLSM
// revu et réarrangé par Pierre DITTGEN

/* =========== Ancienne partie a supprimer des que possible ============ */
function isSelect (select) {
  if (select && select.options) return true
  return false
}


function getOptionByValue (select, value) {
  if (!select.options) return false;
  for (var i = 0; (i>-1 && i<select.length); i=i+1) {
	if (select.options[i].value == value) {
	  select.selectedIndex = i;
	  return select.options[i];
	}
  }
  return false;
}

function optionUp (select) {
  if (document.layers) return;
  if (!isSelect(select)) return false;
  var i=select.selectedIndex;
  if (i < 1) {
	  select.selectedIndex=-1;
	  return false;
  }
  else {
	var option0=select.options[i-1];
	var option1=select.options[i];
	select.selectedIndex=select.selectedIndex-1;
	optionDel(select);
	optionDel(select);
	optionAdd (select, option1.text, option1.value);
	optionAdd (select, option0.text, option0.value);
	select.selectedIndex=i-1;
  }
  return true
}

function optionDown (select) {
  if (document.layers) return;
  if (!isSelect(select)) return;
  var i=select.selectedIndex;
  if (i<0 || i>select.options.length-2) { select.selectedIndex=-1; return;}
  else {
	var option0=select.options[i];
	var option1=select.options[i+1];
	optionDel(select);
	optionDel(select);
	optionAdd (select, option1.text, option1.value);
	optionAdd (select, option0.text, option0.value);
	select.selectedIndex=i+1;
  }
}

// TODO multi delete
function optionDel (select) {
  if (!isSelect(select)) return false;
  var i=select.selectedIndex;
  if (i<0) return false;
  select.options[i]=null;
  if (select.options.length > i) select.selectedIndex=i;
  return true
}

function xfm_selectReset (select) {
  if (!isSelect(select)) return;
  while (select.options[0]!=null) { select.options[0]=null }
}

function selectAll(select)
{
	if (select && select.options && select.options.length && select.options.length > 0)
		for (var i=0; i<select.options.length; i++)
			select.options[i].selected=true;

}

function optionAdd (select, text, value) {
  if (!isSelect(select)) return;
  if (getOptionByValue(select, value)) return;
  var opt= new Option (text, value);
  var I=select.selectedIndex;
  I=(I<0)?select.options.length:I;
  for (var i=I; i<select.options.length + 1; i++) {
	var tmp=select.options[i];
	select.options[i]=opt;
	opt=tmp;
  }
}

function xfm_selectAdd (select1, select2)
{
	var options=select1.options; 
	for (var i=0; i<options.length; i++)
		if (options[i].selected) {
			optionAdd(select2, options[i].text, options[i].value);
		}
}


function xfm_selectKeydown (select, select2) {

	// if (navigator.appName.search('Explorer')!=-1) {document.key = key()};
	// NS4 handling could be done with initKey()
	var K=key();
	if (document.ctrl) { 
			if (K==40) {optionDown (select); return false;} // down alert('down');
			else if (K==38) {optionUp(select); return false; } // up alert ('up');

	}
	else if (K==46) {optionDel(select) }
	else if (K==13) {
		if (select2 && select2.options) xfm_selectAdd(select, select2);
		return false;
		
		} // return
	// else { this.selectedIndex=selectRank(this, document.buffer); return false };
	// alert(K);
	if (window.event && window.event.keyCode == 8 && navigator.appName.search('Explorer')!=-1 ) { //backSpace
		window.event.cancelBubble = true;
		window.event.returnValue = false;
		return false;
	}
	return true;
}

function selectSize (select, input, lines, maxWidth) {

	if (document.layers) return;
	if ( navigator.appName.search('Explorer')!=-1 ) {
		if (!lines) lines=5;
		select.size=lines;
		if (!maxWidth) maxWidth=400;
		var offWidth = select.offsetWidth;
		offWidth= (offWidth>maxWidth)?maxWidth:offWidth;
		select.style.width = offWidth ;
		input.style.width = offWidth-25 ;
	}

}

function key (e)	{ // don't work in a NS select
	document.key = document.layers ? e.which 
			: document.all ? event.keyCode 
			: e.keyCode ;
	if (parseInt(navigator.appVersion)>3) {
		if (navigator.appName=="Netscape") { 
			var mString =(e.modifiers+32).toString(2).substring(3,6);
			document.shift=(mString.charAt(0)=="1");
			document.ctrl =(mString.charAt(1)=="1");
			document.alt  =(mString.charAt(2)=="1");
	}
		else {
			document.shift=event.shiftKey;
			document.alt  =event.altKey;
			document.ctrl =event.ctrlKey;
		}
	}
	var tmp=new Date ().getTime();
	// alert ('now : ' + tmp +' last : ' + document.timer + ' now-last :' + (tmp - document.timer) + ' delay : ' +	document.delay); 
	
 // traitement de buffer, à vérifier
	if ( (tmp - document.timer) > document.delay) { document.buffer=''; document.timer= new Date ().getTime();} else {document.timer= new Date ().getTime();}

	document.buffer =	document.key==13 ? '' //return
					: document.key==13 ? '' // escape
					: document.key==8 ? document.buffer.substr(0, document.buffer.length-1) // backSpace
					: document.buffer + String.fromCharCode (document.key);


					return document.key;
}

function optionGo (select, i) {
	if (i<0 || i>select.options.length-1) {return -1}
	select.selectedIndex = i;
	return i;
}

/* =========== Nouvelle partie ou comment faire la même chose en trois fois moins de code ======== */
/**
 * Clears the select content
 * @param selectId HTML select element id
 */
function _2colsClearSelection(selectId) {

	var select = document.getElementById(selectId);
	while (select.options[0] != null) {
		select.options[0] = null;
	}
}

/**
 * Moves the selected option down
 * @param selectId HTML select element id
 */
function _2colsOptionDown(selectId) {

	var select = document.getElementById(selectId);
	var index = select.selectedIndex;

	if (index < 0 || index == select.options.length - 1) {
		return;
	}
	var option1 = select.options[index];
	var option2 = select.options[index + 1];
	select.options[index] = new Option(option2.text, option2.value);
	select.options[index + 1] = new Option(option1.text, option1.value);
	select.selectedIndex = index + 1;
}

/**
 * Moves the selected option up
 * @param selectId HTML select element id
 */
function _2colsOptionUp(selectId) {

	var select = document.getElementById(selectId);
	var index = select.selectedIndex;

	if (index < 1) {
		return;
	}
	var option1 = select.options[index - 1];
	var option2 = select.options[index];
	select.options[index - 1] = new Option(option2.text, option2.value);
	select.options[index] = new Option(option1.text, option1.value);
	select.selectedIndex = index - 1;
}

/**
 * Deletes the selected options
 * @param selectId HTML select element id
 */
function _2colsOptionDel(selectId) {

	var select = document.getElementById(selectId);
	var selectedIndices = new Array();
	var i = 0;
	for (i=0; i<select.options.length; i++) {
		if (select.options[i].selected) {
			selectedIndices.push(i);
		}
	}
	for (i=0; i<selectedIndices.length; i++) {
		var index = selectedIndices[i];
	    select.options[index - i] = null;
	}
}

/**
 * Checks if a select doesn't already contains an option
 * @param select HTML select element
 * @param text Option text
 * @param value Option value
 * @return true if an option with same text and value already exists in the list, else false
 */
function __2colsAlreadyInSelect(select, text, value) {
	for (var i=0; i<select.options.length; i++) {
		var option = select.options[i];
		if (option.text == text && option.value == value) {
			return true;
		}
	}
	return false;
}

/**
 * Adds an option in the given select if it doesn't already appear in the select
 * @param select HTML select element
 * @param text Option text
 * @param value Option value
 */
function __2colsOptionAdd (select, text, value) {

	if (__2colsAlreadyInSelect(select, text, value)) {
		return;
	}

	var opt = new Option(text, value);
	var len = select.options.length;
	select.options[len] = opt;
}


/**
 * Moves selected values from one select to another one
 * @param selectId HTML select element id
 */
function _2colsShiftValues(selectId) {
	// First find the selects
	var select1 = document.getElementById(selectId + '_repository');
	var select2 = document.getElementById(selectId);
	
	// Then adds all the selected options
	var options = select1.options; 
	for (var i=0; i<options.length; i++) {
		if (options[i].selected) {
			__2colsOptionAdd(select2, options[i].text, options[i].value);
		}
	}
}
