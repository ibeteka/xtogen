/** 
 *  Fichier: ExternalListEditorTest.java
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
package fr.tech.sdx.xtogen.list;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import fr.tech.sdx.xtogen.util.FileHelper;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 *
 *  @author Pierre Dittgen (pierre.dittgen@pass-tech.fr)
 */
public class ExternalListEditorTest extends TestCase
{
	private static final String TEST_FILE_PATH
		 = "test\\fr\\tech\\sdx\\xtogen\\list\\list.xml";
	private static final String TEST_FILE_PATH_2
		 = "test\\fr\\tech\\sdx\\xtogen\\list\\list_temp.xml";

	public ExternalListEditorTest(String name)
	{
		super(name);
	}

	public void testNull()
		throws Exception
	{
		try
		{
			new ExternalListEditor(null);
			fail("new ExternalListEditor(null) didn't throw any exception");
		}
		catch (IllegalArgumentException iae)
		{
		}
	}
	
	public void testFile()
		throws Exception
	{
		ExternalListEditor ele = new ExternalListEditor(new File(TEST_FILE_PATH));
		ele.changeValue("foo","bar");
		System.err.println(ele.toString());
		ele.changeValue("it","javanais");
		System.err.println(ele.toString());
		ele.deleteValue("po");
		System.err.println(ele.toString());
		ele.deleteValue("de");
		System.err.println(ele.toString());
	}

	public void testSave()
		throws Exception
	{
		File originalFile = new File(TEST_FILE_PATH);
		File tempFile = new File(TEST_FILE_PATH_2);
		
		FileHelper.copy(originalFile, tempFile);
		ExternalListEditor elt = new ExternalListEditor(tempFile);
		System.err.println(elt.toString());
		elt.save();

		FileHelper.copy(originalFile, tempFile);
		elt = new ExternalListEditor(tempFile);
		System.err.println(elt.toString());
	
		tempFile.delete();
	}
	
	public void testNonExistentFile()
		throws Exception
	{
		File tempFile = new File(TEST_FILE_PATH_2);
		ExternalListEditor ele = new ExternalListEditor(tempFile);
		ele.changeValue("popo", "cool value");
		ele.save();
		
		System.err.println("------------------------------");
		BufferedReader br = new BufferedReader(new FileReader(tempFile));
		while (true)
		{
			String line = br.readLine();
			System.err.println("Line: " + line);
			if (line == null)
				break;
		}
		br.close();
		System.err.println("------------------------------");
		tempFile.delete();
	}
	
	public void testAddRemove()
		throws Exception
	{
		ExternalListEditor ele = new ExternalListEditor(new File(TEST_FILE_PATH));
		System.err.println(ele.toString());
		assertTrue("1st insertion", ele.addValue("foo", "bar"));
		System.err.println(ele.toString());
		assertTrue("2nd insertion", !ele.addValue("foo", "bar"));
		System.err.println(ele.toString());
	}
	
	public void testItemCount()
		throws Exception
	{
		ExternalListEditor ele = new ExternalListEditor(new File(TEST_FILE_PATH));
		System.err.println(ele.toString());
		System.err.println("Item count = " + ele.getItemCount());	
	}
	
	public void testValues()
		throws Exception
	{
		ExternalListEditor ele = new ExternalListEditor(new File(TEST_FILE_PATH));
		StringOrderedMap som = ele.getValues();
		String[] ids = som.keys();
		for (int i=0; i<ids.length; i++)
			System.err.println(ids[i] + " => " + som.get(ids[i]));
	}
	
	public void testFlush()
		throws Exception
	{
		ExternalListEditor ele = new ExternalListEditor(new File(TEST_FILE_PATH));
		System.err.println(ele.toString());
		assertTrue("Item count = " + ele.getItemCount(), ele.getItemCount() > 0);	
		ele.flush();
		System.err.println(ele.toString());
		assertTrue("Item count = " + ele.getItemCount(), ele.getItemCount() == 0);	
	}

	public void testContainsId()
		throws Exception
	{
		ExternalListEditor ele = new ExternalListEditor(new File(TEST_FILE_PATH));
		assertTrue("La liste ne contient pas l'allemand", ele.containsId("de"));			
		assertTrue("La liste contient le polonais !!!", !ele.containsId("po"));			
	}

	public static Test suite()
	{
		return new TestSuite(ExternalListEditorTest.class);
	}
}
