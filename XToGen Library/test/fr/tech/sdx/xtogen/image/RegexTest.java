/** 
 *  Fichier: RegexTest.java
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
package fr.tech.sdx.xtogen.image;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 *
 */
public class RegexTest extends TestCase
{
	private static final String SIZE_REGEX = "([0-9]{2,3})x([0-9]{2,3})";

	public RegexTest(String name)
	{
		super(name);
	}

	public void testGetWidthAndHeight()
	{
		String maxSize = "458x912";
		Pattern p = Pattern.compile(SIZE_REGEX);
		Matcher m = p.matcher(maxSize);
		System.err.println("Match ? " + m.matches());
		int maxWidth = Integer.parseInt(m.group(1));
		int maxHeight = Integer.parseInt(m.group(2));
		System.err.println("Max size = " + maxSize);
		System.err.println("Computed max width = " + maxWidth);
		System.err.println("Computed max height = " + maxHeight);
	}
	
	public static Test suite()
	{
		return new TestSuite(RegexTest.class);
	}
}