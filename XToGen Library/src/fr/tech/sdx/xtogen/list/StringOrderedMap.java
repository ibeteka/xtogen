/** 
 *  Fichier: OrderedMap.java
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * A map that remembers the order of key insertion
 * 
 *  @author Pierre Dittgen (pierre.dittgen@pass-tech.fr)
 */
public class StringOrderedMap
{
	private List 	_keys	= new ArrayList();
	private Map		_map	= new HashMap();

	/**
	 * Gets an object by its id
	 * @param obj Object id
	 * @return The object or "" if not found
	 */
	public String get(String obj)
	{
		if (obj == null)
			throw new IllegalArgumentException("obj is null");
		
		if (_map.containsKey(obj))
			return (String)_map.get(obj);
		return "";
	}
	
	/**
	 * The list of keys as entered
	 * @return Key list
	 */
	public String[] keys()
	{
		return (String[])_keys.toArray(new String[0]);
	}
	
	/**
	 * Puts a new pair (key,value) in the map
	 * @param key Object key
	 * @param value Object value
	 */
	public void put(String key, String value)
	{
		if (key == null)
			throw new IllegalArgumentException("Key is null");
		if (value == null)
			throw new IllegalArgumentException("Value is null");
			
		if (!_map.containsKey(key))
			_keys.add(key);
		_map.put(key, value);
	}

	/**
	 * Resets the map 
	 */
	public void reset()
	{
		_keys.clear();
		_map.clear();
	}
}
