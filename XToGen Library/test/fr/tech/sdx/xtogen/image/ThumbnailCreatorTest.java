/** 
 *  Fichier: ThumbnailCreatorTest.java
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

import java.awt.Dimension;
import java.io.File;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 *
 */
public class ThumbnailCreatorTest extends TestCase
{
	public ThumbnailCreatorTest(String name)
	{
		super(name);
	}

	public void testReduceJpeg()
		throws Exception
	{
		File SOURCE_FILE = new File("test/fr/tech/sdx/xtogen/image/fleurs_oranges.jpg");
		File DEST_FILE = new File("test/fr/tech/sdx/xtogen/image/fleurs_oranges_t.jpg");
		
		ThumbnailCreator tc = new ThumbnailCreator(SOURCE_FILE);
		tc.createThumbnail(DEST_FILE, 150, 150);
	}

	public void testReducePng()
		throws Exception
	{
		File SOURCE_FILE = new File("test/fr/tech/sdx/xtogen/image/bluespace.png");
		File DEST_FILE = new File("test/fr/tech/sdx/xtogen/image/bluespace_png_t.png");
		
		ThumbnailCreator tc = new ThumbnailCreator(SOURCE_FILE);
		tc.createThumbnail(DEST_FILE, 150, 150);
	}

	public void testReduceGif()
		throws Exception
	{
		File SOURCE_FILE = new File("test/fr/tech/sdx/xtogen/image/bluespace.gif");
		File DEST_FILE = new File("test/fr/tech/sdx/xtogen/image/bluespace_gif_t.png");
		
		ThumbnailCreator tc = new ThumbnailCreator(SOURCE_FILE);
		tc.createThumbnail(DEST_FILE, 150, 150);
	}

	public void testExist()
		throws Exception
	{
		File SOURCE_FILE = new File("test/fr/tech/sdx/xtogen/image/bluespace.gif");
		File DEST_FILE = new File("test/fr/tech/sdx/xtogen/image/bluespace_gif_t.png");
		File ODEST_FILE = new File("test/fr/tech/sdx/xtogen/image/bluespace_gif_t.png");

		if (DEST_FILE.exists())
			DEST_FILE.delete();
		assertTrue("La vignette existe d�j� !", !DEST_FILE.exists());		
		assertTrue("L'autre vignette existe d�j� !", !ODEST_FILE.exists());		
		ThumbnailCreator tc = new ThumbnailCreator(SOURCE_FILE);
		tc.createThumbnail(DEST_FILE, 150, 150);
		assertTrue("La vignette n'existe pas encore !", DEST_FILE.exists());
		assertTrue("Le fichier est vide !", DEST_FILE.length() != 0);
		assertTrue("L'autre vignette n'existe pas encore !", ODEST_FILE.exists());
		assertTrue("L'autre fichier est vide !", ODEST_FILE.length() != 0);
	}

	public void testReduceAndChangeFormat()
		throws Exception
	{
		File SOURCE_FILE = new File("test/fr/tech/sdx/xtogen/image/Photo.jpg");
		String DEST_FILE_NAME = "test/fr/tech/sdx/xtogen/image/Vignette";
	
		ThumbnailCreator tc = new ThumbnailCreator(SOURCE_FILE);
		tc.createThumbnail(new File(DEST_FILE_NAME + ".png"), 150, 150);
		tc.createThumbnail(new File(DEST_FILE_NAME + ".jpg"), 150, 150);
	}

	private void assertDimension(int imW, int imH, int maxW, int maxH, int tW, int tH)
	{
		Dimension d = ThumbnailCreator.computeThumbnailDimension(imW, imH, maxW, maxH);
		assertEquals("Computed width is wrong", tW, d.width);
		assertEquals("Computed height is wrong", tH, d.height);
	}

	public void testComputeDimension()
	{
		assertDimension(15, 15, 150, 150, 15, 15);
		assertDimension(10, 15, 150, 150, 10, 15);
		assertDimension(1000, 2000, 100, 100, 50, 100);
	}

	public static Test suite()
	{
		return new TestSuite(ThumbnailCreatorTest.class);
	}
}