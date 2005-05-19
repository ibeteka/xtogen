/** 
 * Fichier: RightsManagerTest.java
 * 
 *	XtoGen - Générateur d'applications SDX2
 * 	Copyright (C) 2003 Ministère de la culture et de la communication, PASS Technologie
 *
 *	Ministère de la culture et de la communication,
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
 *	License", tels que publiés par la "Free Software Foundation"; soit
 *	la version 2 de cette licence ou (à votre choix) toute version
 *	ultéieure.
 *
 *	Ce programme est distribué dans l'espoir qu'il sera utile, mais
 *	SANS AUCUNE GARANTIE, ni explicite ni implicite; sans même les
 *	garanties de commercialisation ou d'adaptation dans un but spécifique.
 *
 *	Se référer à la "GNU General Public License" pour plus de détails.
 *
 *	Vous devriez avoir reçu une copie de la "GNU General Public License"
 *	en même temps que ce programme; sinon, écrivez à la "Free Software
 *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA".
 */
package fr.tech.sdx.xtogen.security;

import java.io.File;
import java.io.IOException;

import org.apache.log4j.Logger;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * @author Pierre Dittgen <a href="mailto:pierre.dittgen@pass-tech.fr"/>
 */
public class RightsManagerTest extends TestCase
{
	private static final String TEST_FILE_PATH = "test\\fr\\tech\\sdx\\xtogen\\security";
	private static final Logger LOG
        = Logger.getLogger(RightsManagerTest.class);
    
	public void testNull()
		throws Exception
	{
		try
		{
			new RightsManager((String)null);
			fail("new RightsManager(null) didn't throw any exception");
		}
		catch (IllegalArgumentException iae)
		{
		}
        try
        {
            new RightsManager((File)null);
            fail("new RightsManager(null) didn't throw any exception");
        }
        catch (IllegalArgumentException iae)
        {
        }
	}
	
	public void testInexistentFile()
	{
		try
		{
			new RightsManager("notfoundfile");
			fail("new RightsManager(filenotfound) didn't throw any exception");
		}
		catch (IOException ioe)
		{
		}
	}
	
	public void testGetSingleValue()
		throws Exception
	{
		RightsManager rm = new RightsManager(TEST_FILE_PATH);
		
		RightsManager.AccessRights ar = rm.getAccessRights("indexSingle.xsp");
		String[] apps = ar.getApps();

		assertEquals("Apps size", 1, apps.length);
		String[] groups = ar.getGroups(apps[0]);
		assertEquals("Groups size", 1, groups.length);
		assertEquals("Group value", "consultant", groups[0]);
		assertEquals("App value", "fr.tech.sdx.toto", apps[0]);
	}

	public void testGetMultipleValue()
		throws Exception
	{
		RightsManager rm = new RightsManager(TEST_FILE_PATH);
		
		RightsManager.AccessRights ar = rm.getAccessRights("indexMultiple.xsp");
		System.err.println(" ");
        System.err.println("TOTOT " + ar);
        
		String[] apps = ar.getApps();
		assertEquals("Apps size", 3, apps.length);
		checkGroupApp(ar, 3, 0, "consultant", "fr.tech.sdx.toto");
		checkGroupApp(ar, 3, 1, "admins", "fr.tech.sdx.tata");
		checkGroupApp(ar, 3, 2, "saisie", "fr.tech.sdx.foo");
	}

	private void checkGroupApp(RightsManager.AccessRights ar, String group, String app)
	{
		String[] apps = ar.getApps();
		assertEquals("Apps size", 1, apps.length);
		assertEquals("Application name", app, apps[0]);
		String[] groups = ar.getGroups(apps[0]);
		assertEquals("Groups size", 1, groups.length);
		assertEquals("Group value", group, groups[0]);
	}

	private void checkGroupApp(RightsManager.AccessRights ar, int size, int index, String group, String app)
	{
		String[] apps = ar.getApps();
        String[] groups = ar.getGroups(apps[index]);
        assertEquals("Groups size", 1, groups.length);
        assertEquals("Group value", group, groups[0]);
		assertEquals("Apps size", size, apps.length);
		assertEquals("Application name", app, apps[index]);
	}

	public void testGetDefault()
		throws Exception
	{
		RightsManager rm = new RightsManager(TEST_FILE_PATH);
		
		RightsManager.AccessRights ar = rm.getAccessRights("default");

		checkGroupApp(ar, "saisie", "fr.tech.sdx.bar");

		ar = rm.getAccessRights("default.xsp");
		checkGroupApp(ar, "saisie", "fr.tech.sdx.bar");
		
		ar = rm.getAccessRights("notfound.xsp");
		checkGroupApp(ar, "saisie", "fr.tech.sdx.bar");
	}
	
	public void testMultipleDomain()
		throws Exception
	{
		RightsManager rm = new RightsManager(TEST_FILE_PATH);
		
		RightsManager.AccessRights ar
			= rm.getAccessRights("foo|bar");
		System.err.println(ar);
		assertEquals("Number of apps", 2, ar.getApps().length);
	}

	public static Test suite()
	{
		return new TestSuite(RightsManagerTest.class);
	}

}
