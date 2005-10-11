// Ce fichier de fonctions JavaScript a été récupéré
// du code de l'administration des applications SDX
// Auteurs : AJLSM
// revu et réarrangé par Pierre DITTGEN

/**
 * Clears the select content
 * @param selectId HTML select element id
 */
function _2colsClearSelection(selectId) {

	var select = document.getElementById(selectId);
	while (select.options[0] != null) {
		select.options[0] = null;
	}

	// To avoid form submission
	return false;
}

/**
 * Moves the selected option down
 * @param selectId HTML select element id
 */
function _2colsOptionDown(selectId) {

	var select = document.getElementById(selectId);
	var index = select.selectedIndex;

	if (index < 0 || index == select.options.length - 1) {
		return false;
	}
	var option1 = select.options[index];
	var option2 = select.options[index + 1];
	select.options[index] = new Option(option2.text, option2.value);
	select.options[index + 1] = new Option(option1.text, option1.value);
	select.selectedIndex = index + 1;

	// To avoid form submission
	return false;
}

/**
 * Moves the selected option up
 * @param selectId HTML select element id
 */
function _2colsOptionUp(selectId) {

	var select = document.getElementById(selectId);
	var index = select.selectedIndex;

	if (index < 1) {
		return false;
	}
	var option1 = select.options[index - 1];
	var option2 = select.options[index];
	select.options[index - 1] = new Option(option2.text, option2.value);
	select.options[index] = new Option(option1.text, option1.value);
	select.selectedIndex = index - 1;

	// To avoid form submission
	return false;
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

	// To avoid form submission
	return false;
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

	// To avoid form submission
	return false;
}
