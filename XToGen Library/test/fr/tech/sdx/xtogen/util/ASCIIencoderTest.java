/** 
 *  Fichier: ASCIIencoderTest.java
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
package fr.tech.sdx.xtogen.util;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 *
 */
public class ASCIIencoderTest extends TestCase
{
	public ASCIIencoderTest(String name)
	{
		super(name);
	}
	
	private void assertAscii(char c)
	{
		assertTrue("Test avec le caractere <" + c + ">", ASCIIencoder.isAscii(c));
	}
	private void assertNotAscii(char c)
	{
		assertTrue("Test avec le caractere <" + c + ">", !ASCIIencoder.isAscii(c));
	}
	
	public void testIsAscii()
	{
		String s1 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.";
		for (int i=0; i<s1.length(); i++)
			assertAscii(s1.charAt(i));

		String s2 = "éàçèâîô- ";
		for (int i=0; i<s2.length(); i++)
			assertNotAscii(s2.charAt(i));
	}
	
	public void testNull()
	{
		try
		{
			ASCIIencoder.removeAccents(null);
			fail("removeAccents(null) didn't throw any exception");
		}
		catch (IllegalArgumentException iae)
		{
		}
		catch (Exception e)
		{
			fail("removeAccents(null) threw an unexpected exception");
		}
	}
	
	public void testRemove()
	{
		String data = "Hélène est à côté du chalût";
		System.err.println("Before = " + data);
		String result = ASCIIencoder.removeAccents(data);
		System.err.println("After = " + result);
	}	
	
	public static Test suite()
	{
		return new TestSuite(ASCIIencoderTest.class);
	}
}
