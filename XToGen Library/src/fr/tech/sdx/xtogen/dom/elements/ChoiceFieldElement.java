/** 
 * Fichier: ChoiceFieldElement.java
 * 
 *	XtoGen - G�n�rateur d'applications SDX2
 * 	Copyright (C) 2003 Minist�re de la culture et de la communication, PASS Technologie
 *
 *	Minist�re de la culture et de la communication,
 *	Mission de la recherche et de la technologie
 *	3 rue de Valois, 75042 Paris Cedex 01 (France)
 *	mrt@culture.fr, michel.bottin@culture.fr
 *
 *	PASS Technologie, 23, rue Pierre et Marie Curie, 94200 Ivry Sur Seine
 *	Nader Boutros, nader.boutros@pass-tech.fr
 *	Pierre Dittgen, pierre.dittgen@pass-tech.fr
 *
 *	Ce programme est un logiciel libre: vous pouvez le redistribuer
 *	et/ou le modifier selon les termes de la "GNU General Public
 *	License", tels que publi�s par la "Free Software Foundation"; soit
 *	la version 2 de cette licence ou (� votre choix) toute version
 *	ult�ieure.
 *
 *	Ce programme est distribu� dans l'espoir qu'il sera utile, mais
 *	SANS AUCUNE GARANTIE, ni explicite ni implicite; sans m�me les
 *	garanties de commercialisation ou d'adaptation dans un but sp�cifique.
 *
 *	Se r�f�rer � la "GNU General Public License" pour plus de d�tails.
 *
 *	Vous devriez avoir re�u une copie de la "GNU General Public License"
 *	en m�me temps que ce programme; sinon, �crivez � la "Free Software
 *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA".
 */
package fr.tech.sdx.xtogen.dom.elements;

import org.apache.cocoon.environment.Request;

/**
 * @author Pierre Dittgen <a href="mailto:pierre.dittgen@pass-tech.fr"/>
 */
public class ChoiceFieldElement extends NormalFieldElement
{
	// for additional choice value
	private static final String CHOICE_SUFFIX	= ".text";

	/**
	 * Constructor
	 * @param name Field name
	 * @param path Field path
	 */
	public ChoiceFieldElement(String name, String path)
	{
		super(name, path);
	}

	/**
	 * Extract values
	 * @param name Field name
	 * @param request Servlet request
	 */
	public final void extractValues(String name, Request request)
	{
		super.extractValues(name, request);
		
		String[] additionalValues
			= getValues(request, name, CHOICE_SUFFIX);
		
		for (int i=0; i<additionalValues.length; i++)
			if (!"".equals(additionalValues[i]))
			{
				addValue(createFieldValue(additionalValues[i]));
			}
	}
}
