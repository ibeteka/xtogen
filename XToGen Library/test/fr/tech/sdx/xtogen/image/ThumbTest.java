/** 
 *  Fichier: ThumbTest.java
 * 
 *  XtoGen - Générateur d'applications SDX2
 *  Copyright (C) 2003 Ministère de la culture et de la communication, PASS Technologie
 *
 *  Ministère de la culture et de la communication,
 *  Mission de la recherche et de la technologie
 *  3 rue de Valois, 75042 Paris Cedex 01 (France)
 *  mrt@culture.fr, michel.bottin@culture.fr
 *
 *  PASS Technologie, 23, rue Pierre et Marie Curie, 94200 Ivry Sur Seine
 *  Nader Boutros, nader.boutros@pass-tech.fr
 *  Pierre Dittgen, pierre.dittgen@pass-tech.fr
 *
 *  Ce programme est un logiciel libre: vous pouvez le redistribuer
 *  et/ou le modifier selon les termes de la "GNU General Public
 *  License", tels que publiés par la "Free Software Foundation"; soit
 *  la version 2 de cette licence ou (à votre choix) toute version
 *  ultéieure.
 *
 *  Ce programme est distribué dans l'espoir qu'il sera utile, mais
 *  SANS AUCUNE GARANTIE, ni explicite ni implicite; sans même les
 *  garanties de commercialisation ou d'adaptation dans un but spécifique.
 *
 *  Se référer à la "GNU General Public License" pour plus de détails.
 *
 *  Vous devriez avoir reçu une copie de la "GNU General Public License"
 *  en même temps que ce programme; sinon, écrivez à la "Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA".
 */
package fr.tech.sdx.xtogen.image;

import java.io.File;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * @author Pierre Dittgen
 */
public class ThumbTest extends TestCase {

	/**
	 * Constructor.
	 * @param name Test case name
	 */
	public ThumbTest(String name) {
		super(name);
	}
    
    public void testThumbPhoto() {
    	Thumb t = new Thumb(new File("test/fr/tech/sdx/xtogen/image/Photo.jpg"));
        try {
        t.createThumbnail(new File("test/fr/tech/sdx/xtogen/image/Photo_t.jpg"), 80, 80);
        t.createThumbnail(new File("test/fr/tech/sdx/xtogen/image/Photo_t.png"), 120, 120);
        } catch (Exception e) {
        	fail("Error !!!! " + e);
        }
    }
    
    public static Test suite() {
    	return new TestSuite(ThumbTest.class);
    }

}
