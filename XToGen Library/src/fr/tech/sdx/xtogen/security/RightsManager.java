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
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.cocoon.environment.Context;
import org.apache.cocoon.environment.Request;
import org.apache.log4j.Logger;

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
	private static RightsManager instance = null;
    private static long instanceTime = 0L;

    /**
     * Singleton method
     * @param context Cocoon context
     * @param request Cocoon request
     * @return Single instance
     * @throws IOException If something bad occurs
     */
    public static RightsManager instance(Context context, Request request)
        throws IOException {
        
        String baseDir = context.getRealPath(
            request.getServletPath().substring(0,
            request.getServletPath().lastIndexOf('/')+1));
        File propFile = new File(baseDir, PROP_FILE_NAME);
        
        // If the rights manager is already loaded
        // and the conf file has not be modified since last reload
        // just send back current instance
        if (instance != null && instanceTime > propFile.lastModified()) {
            return instance;
        }
        
        // Else builds and returns instance
        instance = new RightsManager(context, request);
        instanceTime = System.currentTimeMillis();
    	return instance;
    }
    
	/**
	 * Constructor
	 * @param context Context
	 * @param request Request
	 * @throws IOException If something bad occurs
	 */
	RightsManager(Context context, Request request)
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
	RightsManager(String propFilePath)
		throws IOException
	{
        this(new File(propFilePath, PROP_FILE_NAME));
	}

    /**
     * Constructor
     * @param propFilePath Path of the access rights file
     * @throws IOException If the file can't be open
     */
    RightsManager(File propFile) throws IOException
    {
        LOG.debug("RightsManager() constructor()");
        if (propFile == null)
            throw new IllegalArgumentException("Null prop file");
        
        _rightsProp = new Properties();
        _rightsProp.load(new FileInputStream(propFile));
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
		
		private static Pattern _groupRe	= null;
		private static Pattern _noneRe	= null;
		
		private OrderedHashMap    _apps	      = new OrderedHashMap();
		private boolean           _noControl  = false;
		
		/**
		 * Lazy initialization for the group regular expression
		 * @return Group regular expression
		 */
		private static Pattern getGroupRe()
		{
			if (_groupRe == null)
				_groupRe = Pattern.compile(GROUP_APP_RE);
			return _groupRe;
		}

		/**
		 * Lazy initialization for the no control regular expression
		 * @return No control regular expression
		 */
		private static Pattern getNoControlRe()
		{
			if (_noneRe == null)
				_noneRe = Pattern.compile(NO_CONTROL_RE);
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
		{
			if (value == null)
				throw new IllegalArgumentException("Value is null");
		
            
            Matcher m = getNoControlRe().matcher(value);
            if (m.matches())
			{
				_noControl	= true;
				return;
			}
			
			Pattern groupAppRe	= getGroupRe();
			String appName		= null;
			String groupName	= null;
			List groups			= null;
			int index			= 0;
			while (true)
			{
				m = groupAppRe.matcher(value);
                if (!m.find(index))
					break;
				groupName = m.group(1);
				appName = m.group(2);
				if (_apps.containsKey(appName))
				{
					groups = (List)_apps.get(appName);
				}
				else
				{
					groups = new ArrayList();
				}
                if (!groups.contains(groupName)) {
                	groups.add(groupName);
                }
				_apps.put(appName, groups);
				index = m.end(0);
			}
		}
		
		/**
		 * Constructor
		 * @param value The value associated to a domain
		 */
		public AccessRights(String value)
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
			return (String[])_apps.keys().toArray(new String[0]);
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
			for (Iterator it=_apps.keys().iterator(); it.hasNext();)
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
        
        public static class OrderedHashMap {
        	private List keys = new ArrayList();
            private Map map = new HashMap();
	
			public int size() { return map.size(); }
			public void clear() { keys.clear(); map.clear(); }
			public boolean isEmpty() { return map.isEmpty(); }
			public boolean containsKey(Object arg0) {
                return map.containsKey(arg0);
			}
			public boolean containsValue(Object arg0) {
                return map.containsValue(arg0);
			}
            public Collection keys() { return keys; }
			public Object get(Object arg0) { return map.get(arg0); }
			public Object put(Object arg0, Object arg1) {
				if (!keys.contains(arg0)) {
					keys.add(arg0);
                }
				return map.put(arg0, arg1);
            }
            
        }
	}
}
