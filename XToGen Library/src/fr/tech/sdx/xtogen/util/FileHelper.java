/** 
 * Fichier: FileHelper.java
 * 
 *	XtoGen - Générateur d'applications SDX2
 * 	Copyright (C) 2003 Ministère de la culture et de la communication,
 *  PASS Technologie
 *
 *	Ministère de la culture et de la communication,
 *	Mission de la recherche et de la technologie
 *	3 rue de Valois, 75042 Paris Cedex 01 (France)
 *	mrt@culture.fr, michel.bottin@culture.fr
 *
 *	PASS Technologie, 23, rue Pierre et Marie Curie, 94200 Ivry Sur Seine
 *	pierre.dittgen@pass-tech.fr
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
	 * Copy in into out
	 * @param in Input stream
	 * @param out Output stream
	 * @throws IOException If something bad occurs
	 */
	public static void copy(InputStream in, OutputStream out)
		throws IOException
	{
		byte[] buffer = new byte[8192];
		int length = -1;

		while ((length = in.read(buffer)) > -1) {
			out.write(buffer, 0, length);
		}
		in.close();
		in = null;
		out.flush();
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
