/** 
 * Fichier: LanguageHelper.java
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

import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.Session;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 */
public class LanguageHelper
{
	/**
	 * Handy method to get language information
	 * @param request Cocoon request
	 * @param defaultLanguage Default language
	 * @return Session language if found, else default language
	 */
	public static String getCurrentLanguage(Request request, String defaultLanguage)
	{
		// Gets the session
		Session session = request.getSession(false);
		
		// No session => return default language
		if (session == null)
			return defaultLanguage;
		
		// Returns session lang if not null
		String sessionLang = (String)session.getAttribute("lang");
		if (sessionLang != null)
			return sessionLang;
		
		// Default behaviour
		return defaultLanguage;
	}
}
