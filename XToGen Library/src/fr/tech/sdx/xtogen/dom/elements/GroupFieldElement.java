/** 
 *  Fichier: GroupFieldElement.java
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
package fr.tech.sdx.xtogen.dom.elements;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.cocoon.environment.Request;

import fr.tech.sdx.xtogen.dom.FieldElement;
import fr.tech.sdx.xtogen.dom.FieldValue;

/**
 *
 *  @author Pierre Dittgen (pierre.dittgen@pass-tech.fr)
 */
public class GroupFieldElement extends FieldElement
{
	private static final String WITNESS_SUFFIX	= ".tag";
	private static final String DELETE_SUFFIX	= ".delete";

	private List _children = new ArrayList();
	

	/**
	 * Constructor
	 * @param name Field name
	 * @param path Field path
	 */
	public GroupFieldElement(String name, String path)
	{
		super(name, path);
	}

	/**
	 * Extract values from name
	 * @param name Field name
	 * @param request Servlet request
	 */
	public final void extractValues(String name, Request request)
	{
		String[] witnesses = reduce(getValues(request, name, WITNESS_SUFFIX));
		String[] deletes = getValues(request, name, DELETE_SUFFIX);
		Set deleteSet = new HashSet();
		for (int i=0; i<deletes.length; i++)
			deleteSet.add(deletes[i]);

		// For each witness
		for (int i=0; i<witnesses.length; i++)
		{
			String witness = witnesses[i];
			if (deleteSet.contains(witness))
				continue;

			FieldValue value = createFieldValue("");
			String groupPrefix = computeGroupPrefix(witness);
			value.setGroupPrefix(groupPrefix);
			for (Iterator it=_children.iterator(); it.hasNext();)
			{
				FieldElement fe = (FieldElement)it.next();
				value.addChild(fe);
			}
			
			addValue(value);
		}
	}

	/**
	 * Reduces a list
	 * @param input A list of string
	 * @return A list of unique values
	 */
	private String[] reduce(String[] input)
	{
		List result = new ArrayList();
		Set set = new HashSet();
		for (int i=0; i<input.length; i++)
		{
			if (set.contains(input[i]))
				continue;
			set.add(input[i]);
			result.add(input[i]);
		}
		
		return (String[])result.toArray(new String[0]);
	}

	/**
	 * @param witness
	 * @return
	 */
	private String computeGroupPrefix(String witness)
	{
		return getGroupPrefix() + witness + '_';
	}

	/**
	 * Adds a new field element
	 * @param fe Field element
	 */
	public final void addFieldElement(FieldElement fe)
	{
		fe.setAbsolutePath(getAbsolutePath() + "/" + fe.getPath());
		_children.add(fe);
	}

	/**
	 * Gets the list of attached files
	 * @return Attached files collection
	 */
	public final Collection getAttachedFiles()
	{
		List result = new ArrayList();
		
		for (Iterator it=result.iterator(); it.hasNext();)
		{
			FieldElement fe = (FieldElement)it.next();
			result.addAll(fe.getAttachedFiles());
		}
		
		return result;
	}

	/**
	 * Gets an element by its name
	 * @param fieldName Field name
	 * @return The so named field element or null if not found
	 */
	public FieldElement getFieldByName(String fieldName)
	{
		if (getName().equals(fieldName))
			return this;
		
		for (Iterator it=_children.iterator(); it.hasNext();)
		{
			FieldElement child = (FieldElement)it.next();
			FieldElement namedElement = child.getFieldByName(fieldName);
			if (namedElement != null)
				return namedElement;
		}

		return null;
	}

}
