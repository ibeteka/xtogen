// Ce fichier de fonctions JavaScript a été récupéré
// du code de l'administration des applications SDX
// 
// Auteurs : AJLSM

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
  if (document.layers) return
  if (!isSelect(select)) return false;
  var i=select.selectedIndex;
  if (i<1) { select.selectedIndex=-1; return -1}
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
  if (document.layers) return
  if (!isSelect(select)) return false;
  var i=select.selectedIndex;
  if (i<0 || i>select.options.length-2) { select.selectedIndex=-1; return -1}
  else {
	var option0=select.options[i];
	var option1=select.options[i+1];
	optionDel(select);
	optionDel(select);
	optionAdd (select, option1.text, option1.value);
	optionAdd (select, option0.text, option0.value);
	select.selectedIndex=i+1;
  }
  return true
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
  if (!isSelect(select)) return false;
  while (select.options[0]!=null) { select.options[0]=null }
}

function selectAll(select)
{
	if (select && select.options && select.options.length && select.options.length > 0)
		for (var i=0; i<select.options.length; i++)
			select.options[i].selected=true;

}

function optionAdd (select, text, value) {
  if (!isSelect(select)) return false;
  if (getOptionByValue(select, value)) return false;
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

// constructeur d'un select "taper-dedans"
function selectFind (select, input, lines, maxWidth) {	//=SF
	initKey ();
	if ( navigator.appName.search('Explorer')!=-1 ) {
		select.onkeydown = Bspace;
		selectSize (select, input, lines, maxWidth);
	}
	select.input = input;
	input.select=select;
	input.onkeydown=SFkeydown;
	input.onkeyup=SFkeyup;
//	select.ondblclick=SFgoHref
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

function initKey () {
	document.key = 0, document.buffer = '', document.delay=2000, document.timer= new Date ().getTime() ; 
	if (document.layers) {
		document.captureEvents(Event.KEYDOWN); document.onkeydown = key;
		 // document.captureEvents(Event.KEYPRESS); document.onkeypress = key;
		 // document.captureEvents(Event.KEYUP); document.onkeyup = key;
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

function Bspace() {
	if (window.event && window.event.keyCode == 8 ) {
		window.event.cancelBubble = true;
		window.event.returnValue = false;
		return false;
	}
}

function selectRank (select, txt) { 
	if (!txt) return false;
	txt=noAccents(txt.toLowerCase()).replace (/[\\\/\^\$\+\?\(\)\|\{\}\,\[\]]/gi, '.');
	var len=txt.length+1;
	var re=new RegExp('^'+ txt, 'i');
	var sup=select.options.length - 1;
	var inf=0;
	var dir=1;
	var dif=sup-inf;
	var i=(select.selectedIndex>0)?select.selectedIndex:dif;
	while (dif>0.49) {
		var a=select.options[Math.floor(i)].text;
		a = noAccents(a.substring(0, len).toLowerCase());
		if (a.search(re) != -1) { dir=-1; sup = i; dif=sup-inf}
		else {
			T=[txt, a].sort();
			if (T[0]==txt) {sup= i; dir=-1; dif=sup-inf}
			else {inf=i; dir=1; dif=sup-inf;}
		}
		dif=dif/2;
		if (dir==-1) {i=inf+dif} else {i=sup-dif}
	}
	return sup
}
function noAccents (S) {
	var out='';
	for (var i=0; i<S.length; i++) {
		var a=S.charCodeAt(i);
		if ( a==232 || a==233 || a==234 || a==235) a=101;
		if ( a==200 || a==201 || a==202 || a==203 ) a=69;
		if ( a==194 || a==195 || a==196 ) a=65;
		if ( a==224 || a==226 || a==228 ) a=97;
		if ( a==212 ) a=79;
		if ( a==244 ) a=111;
		out += String.fromCharCode(a);
	}
	return out;
}

function SFmatch (select, txt, direction) {
	txt = txt.replace (/[\\\/\^\$\+\?\(\)\|\{\}\,\[\]]/gi, '.').replace (/\*/gi, '.*');
	txt=noAccents(txt);
//	txt=txt.replace(' ', '\b ');
	var tab = txt.split(' ');
	for (var i in tab) {	
		tab[i] = new RegExp (tab[i], 'gi');
	}
	if (direction == -1 || direction == 1) {
		var i=select.selectedIndex+direction;
	}
	else {var i=0; direction=1; }
	for (i; (i>-1 && i<select.length); i=i+direction) {
		opt=noAccents(select.options[i].text);
		for (var j in tab) {	
			if (opt.search(tab[j]) == -1) {var f=false; break } else {var f=true; }
		}
		if (f) {return i};	
	}
	return -1;
}

function SFsearch (select, txt) {
	if (txt.search(/ /gi) != -1) { select.selectedIndex = SFmatch (select, txt); }
	else { select.selectedIndex=selectRank (select, txt) }
}

function optionGo (select, i) {
	if (i<0 || i>select.options.length-1) {return -1}
	select.selectedIndex = i;
	return i;
}

function SFkey (select, input) {
	if (navigator.appName.search('Explorer')!=-1) {document.key = key()};
	var K=document.key;
	// alert(K);
	if (K==13) {return false} // return
	if (K==36) {select.noSearch=true; select.selectedIndex = 0; return; } // home
	if (K==35) {select.noSearch=true; select.selectedIndex = select.options.length-1 ; return; } // end
	if (document.layers) {
		if (K==40) {select.noSearch=true; optionGo(select, select.selectedIndex+1); return } // up
		if (K==38) {select.noSearch=true; optionGo(select, select.selectedIndex-1); return } // down
	}
	if (K==33) {select.noSearch=true; select.selectedIndex=SFmatch(select, input.value, -1); return } // prev occur, pageUp
	if (K==34) {select.noSearch=true; select.selectedIndex=SFmatch(select, input.value, 1); return } // next occur, pageDown

	if ( input.value != '' && !select.noSearch ) { SFsearch(select, input.value); return}
	select.noSearch=false;
}

function SFkeydown() {
	if (navigator.appName.search('Explorer')!=-1) {document.key = key()};
	var K=document.key;
	if (K==40) {this.select.noSearch=true; optionGo(this.select, this.select.selectedIndex+1); return } // up 
	if (K==38) {this.select.noSearch=true; optionGo(this.select, this.select.selectedIndex-1); return } // down
}
function SFkeyup() {
	SFkey(this.select, this );
}

function SFgoHref (select, input) {
	var i=select.selectedIndex;
	if (i<0) return false;
	var page=select.options[i].value;
alert (page);
}


