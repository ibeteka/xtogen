/**
 * Fichier: RightsManager.java
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
 *	Nader Boutros, nader.boutros@pass-tech.fr
 *	Pierre Dittgen, pierre.dittgen@pass-tech.fr
 *
 *	Ce programme est un logiciel libre: vous pouvez le redistribuer
 *	et/ou le modifier selon les termes de la "GNU General Public
 *	License", tels que publiés par la "Free Software Foundation"; soit
 *	la version 2 de cette licence ou (à votre choix) toute version
 *	ultérieure.
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
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;

import org.apache.cocoon.environment.Context;
import org.apache.cocoon.environment.Request;
import org.apache.log4j.Logger;
import org.apache.regexp.RE;
import org.apache.regexp.RESyntaxException;

/**
 * Gestion des droits des utilisateurs à accéder aux pages
 * 
 * @author Pierre Dittgen <a href="mailto:pierre.dittgen@pass-tech.fr"/>
 */
public class RightsManager
{
	/** Le nom du fichier contenant la définition des droits */
	public static final String PROP_FILE_NAME = "access_rights.properties";
	private Properties _rightsProp = null;
	
	private static final Logger LOG
		= Logger.getLogger(RightsManager.class);
	
	/**
	 * Constructor
	 * @param context Context
	 * @param request Request
	 * @throws IOException If something bad occurs
	 */
	public RightsManager(Context context, Request request)
		throws IOException
	{
		this(context.getRealPath(
			request.getServletPath().substring(0,
			request.getServletPath().lastIndexOf('/')+1)));
	}

	/**
	 * Constructor
	 * @param propFilePath Path of the access rights file
	 * @throws IOException If the file can't be open
	 */
	public RightsManager(String propFilePath)
		throws IOException
	{
		if (propFilePath == null)
			throw new IllegalArgumentException("Null file path");
		
		_rightsProp = new Properties();
		_rightsProp.load(new FileInputStream(new File(propFilePath,
			PROP_FILE_NAME)));
		if (!_rightsProp.containsKey("default"))
			LOG.warn("Warning: no default rights!");
	}

	/**
	 * Gets the lists of the access rights for one domain
	 * @param domainName Name of the domain
	 * @return The access rights for the page
	 * @throws RESyntaxException If something wrong occurs
	 */
	public final AccessRights getAccessRights(String domainName)
		throws RESyntaxException
	{
		if (domainName == null)
			throw new IllegalArgumentException("Null page name");
		
		// Single domain
		if (domainName.indexOf("|") == -1)
		{
			if (_rightsProp.containsKey(domainName))
				return new AccessRights(_rightsProp.getProperty(domainName));
			return new AccessRights(_rightsProp.getProperty("default"));
		}
		
		// Multiple domain
		StringTokenizer st = new StringTokenizer(domainName, "|");
		AccessRights ar = new AccessRights();
		while (st.hasMoreTokens())
		{
			String dom = st.nextToken();
			if (_rightsProp.containsKey(dom))
				ar.addRights(_rightsProp.getProperty(dom));
		}
		
		return ar;
	}


	/**
	 * @author Pierre Dittgen <a href="mailto:pierre.dittgen@pass-tech.fr"/>
	 */
	public static class AccessRights
	{
		private static final String GROUP_APP_RE
			= "\\(([^,]+),([^)]+)\\)";
		private static final String NO_CONTROL_RE
			= " *none *";
		
		private static RE _groupRe	= null;
		private static RE _noneRe	= null;
		
		private Map		_apps		= new HashMap();
		private boolean	_noControl	= false;
		
		/**
		 * Lazy initialization for the group regular expression
		 * @return Group regular expression
		 * @throws RESyntaxException
		 */
		private static RE getGroupRe()
			throws RESyntaxException
		{
			if (_groupRe == null)
				_groupRe = new RE(GROUP_APP_RE);
			return _groupRe;
		}

		/**
		 * Lazy initialization for the no control regular expression
		 * @return No control regular expression
		 * @throws RESyntaxException
		 */
		private static RE getNoControlRe()
			throws RESyntaxException
		{
			if (_noneRe == null)
				_noneRe = new RE(NO_CONTROL_RE);
			return _noneRe;
		}
		
		/**
		 * Constructor
		 */
		public AccessRights()
		{
		}

		/**
		 * Adds acces rights
		 * @param value The value associated to a domain
		 */
		public void addRights(String value)
			throws RESyntaxException
		{
			if (value == null)
				throw new IllegalArgumentException("Value is null");
			
			if (getNoControlRe().match(value))
			{
				_noControl	= true;
				return;
			}
			
			RE groupAppRe		= getGroupRe();
			String appName		= null;
			String groupName	= null;
			List groups			= null;
			int index			= 0;
			while (true)
			{
				if (!groupAppRe.match(value, index))
					break;
				groupName = groupAppRe.getParen(1);
				appName = groupAppRe.getParen(2);
				if (_apps.containsKey(appName))
				{
					groups = (List)_apps.get(appName);
				}
				else
				{
					groups = new ArrayList();
				}
				groups.add(groupName);
				_apps.put(appName, groups);
				index = groupAppRe.getParenEnd(0);
			}
		}
		
		/**
		 * Constructor
		 * @param value The value associated to a domain
		 * @throws RESyntaxException If something bad occurs
		 */
		public AccessRights(String value)
			throws RESyntaxException
		{
			addRights(value);
		}
		
		/**
		 * Gets the groups defined for one application
		 * @param appName Application name
		 * @return The associated groups
		 */
		public final String[] getGroups(String appName)
		{
			if (!_apps.containsKey(appName))
				return new String[0];
			List groups = (List)_apps.get(appName);
			return (String[])groups.toArray(new String[0]);
		}

		/**
		 * Gets the list of application names
		 * @return Application names
		 */
		public final String[] getApps()
		{
			return (String[])_apps.keySet().toArray(new String[0]);
		}

		/**
		 * Indicates if we have to test against the user identity
		 * @return true if no control has to be done
		 */
		public final boolean noControl()
		{ 
			return _noControl;
		}

		/**
		 * For debugging purpose
		 */
		public String toString()
		{
			StringBuffer sb = new StringBuffer("Access right = ");
			
			String[] apps = getApps();
			for (int i=0; i<apps.length; i++)
			{
				String[] groups = getGroups(apps[i]);
				for (int j=0; j<groups.length; j++)
				{
					if (j!=0 || i!=0)
						sb.append(", ");
					sb.append("Profile (").append(groups[j])
					  .append(",").append(apps[i]).append(")");
				}
			}
			
			return sb.toString();
		}

		/**
		 * Tests the equality between two objects
		 * @param o The object to test
		 * @return True if they're the same, else false
		 */
		public boolean equals(Object o)
		{
			if (o == null || !(o instanceof AccessRights))
				return false;
			if (o == this)
				return true;
			AccessRights otherAr = (AccessRights)o;

			// No control test
			if (_noControl != otherAr._noControl)
				return false;
			
			// Apps length test
			if (_apps.size() != otherAr._apps.size())
				return false;
			
			// Apps values test
			for (Iterator it=_apps.keySet().iterator(); it.hasNext();)
			{
				String app = (String)it.next();
				List myList = (List)_apps.get(app);
				List otherList = (List)otherAr._apps.get(app);
				
				if (myList.size() != otherList.size())
					return false;
				
				for (int i=0; i<myList.size(); i++)
				{
					String myGroup = (String)myList.get(i);
					String otherGroup = (String)otherList.get(i);
					if (!myGroup.equals(otherGroup))
						return false;
				}
			}
			
			return true;
		}	
	}
}
