/** 
 * Fichier: FileHelper.java
 * 
 *	XtoGen - G�n�rateur d'applications SDX2
 * 	Copyright (C) 2003 Minist�re de la culture et de la communication,
 *  PASS Technologie
 *
 *	Minist�re de la culture et de la communication,
 *	Mission de la recherche et de la technologie
 *	3 rue de Valois, 75042 Paris Cedex 01 (France)
 *	mrt@culture.fr, michel.bottin@culture.fr
 *
 *	PASS Technologie, 23, rue Pierre et Marie Curie, 94200 Ivry Sur Seine
 *	pierre.dittgen@pass-tech.fr
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
package fr.tech.sdx.xtogen.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.cocoon.environment.Context;
import org.apache.cocoon.environment.Request;

/**
 * @author Pierre Dittgen (pierre.dittgen@pass-tech.fr)
 *
 * A class to copy files
 */
public final class FileHelper
{
	private static final int BUFF_SIZE = 1024;
	private FileHelper() {}

	/**
	 * Copy a file into another
	 * 
	 * @param src Source file
	 * @param dst Destination file
	 * @throws IOException If something goes wrong
	 */
	public static void copy(File src, File dst)
		throws IOException
	{
		InputStream in = new FileInputStream(src);
		OutputStream out = new FileOutputStream(dst);
		
		byte[] buffer = new byte[BUFF_SIZE];
		int len;
		while ((len = in.read(buffer)) != -1)
			out.write(buffer, 0, len);
		in.close();
		out.flush();
		out.close();
	}

	/**
	 * Gets application directory
	 * 
	 * @param context Cocoon context
	 * @param request Servlet request
	 * @return Application directory as a string
	 */
	public static String getBaseDir(Context context, Request request)
	{
		String servletPath = request.getServletPath();
		return context.getRealPath(
			servletPath.substring(0,servletPath.lastIndexOf('/')+1));
	}
}
