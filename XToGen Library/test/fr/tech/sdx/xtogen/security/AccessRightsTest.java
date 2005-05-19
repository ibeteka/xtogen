/** 
 * Fichier: RightsManagerTest.java
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
package fr.tech.sdx.xtogen.security;

import org.apache.regexp.RESyntaxException;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 */
public class AccessRightsTest extends TestCase
{
	public AccessRightsTest(String name)
	{
		super(name);
	}
	
	public void testNull()
	{
		try
		{
			new RightsManager.AccessRights(null);
			fail("new AccessRights(null) didn't throw any exception");
		}
		catch (IllegalArgumentException iae)
		{
		}
	}

	public void testNone()
		throws Exception
	{
		RightsManager.AccessRights ar = new RightsManager.AccessRights("none");
		assertEquals("apps size", 0, ar.getApps().length);
		assertTrue("no control flag", ar.noControl());
	}
	
	public void testEquality()
		throws Exception
	{
		final String s = "(saisie,fr.tech.sdx.bar) (saisie,fr.tech.sdx.foo)";
		
		RightsManager.AccessRights ar1 = new RightsManager.AccessRights(s);
		RightsManager.AccessRights ar2 = new RightsManager.AccessRights();
		ar2.addRights(s);
		
		assertEquals("Equality", ar1, ar2);
	}

	public void testAddition()
		throws Exception
	{
		final String s1 = "(saisie,fr.tech.sdx.bar) (saisie,fr.tech.sdx.foo)";
		final String s2 = "(saisie,fr.tech.sdx.foo)";
		final String s3 = "(saisie,fr.tech.sdx.bar)";
		
		RightsManager.AccessRights ar1 = new RightsManager.AccessRights(s1);
		RightsManager.AccessRights ar2 = new RightsManager.AccessRights();
		ar2.addRights(s2);
		ar2.addRights(s3);

		assertEquals("Equality", ar1, ar2);
	}
	
	public static Test suite()
	{
		return new TestSuite(AccessRightsTest.class);
	}
}
