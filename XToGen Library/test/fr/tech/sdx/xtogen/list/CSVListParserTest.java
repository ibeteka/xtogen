/** 
 *  Fichier: CSVListParserTest.java
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
package fr.tech.sdx.xtogen.list;

import java.io.File;
import java.util.Properties;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 *
 *  @author Pierre Dittgen (pierre.dittgen@pass-tech.fr)
 */
public class CSVListParserTest extends TestCase
{
	private final static String TEST_FILE
		= "test/fr/tech/sdx/xtogen/list/export.csv";
		
	
	public CSVListParserTest(String name)
	{
		super(name);
	}

	public void testHeader()
		throws Exception
	{
		CSVListParser csvle
			= new CSVListParser(new File(TEST_FILE), "standard", ",", "\"");
		System.err.println("Headers");
		System.err.println("=======");
		String[] headers = csvle.getHeaders();
		for (int i=0; i<headers.length; i++)
		{
			System.err.println("\t" + headers[i]);
		}
	}
	
	public void testValues()
		throws Exception
	{
		CSVListParser csvle
			= new CSVListParser(new File(TEST_FILE), "standard", ",", "\"");
		System.err.println("Headers");
		System.err.println("=======");
		String[] headers = csvle.getHeaders();
		for (int i=0; i<headers.length; i++)
			System.err.println("\t" + headers[i]);
		while (csvle.hasRow())
		{
			Properties prop = csvle.getRow();
			System.err.println("-- Row --");
			prop.list(System.err);
		}
	}

	public static Test suite()
	{
		return new TestSuite(CSVListParserTest.class);
	}
}
