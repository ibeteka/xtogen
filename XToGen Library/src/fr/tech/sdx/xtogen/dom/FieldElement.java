/** 
 * Fichier: FieldElement.java
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
package fr.tech.sdx.xtogen.dom;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.StringTokenizer;

import org.apache.cocoon.components.request.multipart.FilePartFile;
import org.apache.cocoon.environment.Request;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


/**
 * Bean class to ease field handling
 */
public abstract class FieldElement
{
	private String	_name			= null;
	private String	_path			= null;
	private String	_absolutePath	= null;
	private String	_groupPrefix	= "";
	private List	_values			= new ArrayList();
	private boolean _multilingual	= false;
	
	/** Field prefix */
	public static final String FIELD_PREFIX	= "f_";

	/** For label */
	protected static final String LABEL_SUFFIX		= ".label";

	/** For upload file */
	public static final String UPLOAD_SUFFIX = ".upload";

	/**
	 * Constructor
	 * @param name Field name
	 * @param path Field path
	 */
	public FieldElement(String name, String path)
	{
		if (name == null)
			throw new IllegalArgumentException("Name is null");
		if (path == null)
			throw new IllegalArgumentException("Path is null");
		
		_name	= name;
		_path	= path;
		if ("".equals(path))	
			_path	= name;
		_absolutePath = _path;
	}

	/**
	 * Sets absolute path of field
	 * @param absolutePath New absolute path
	 */
	public void setAbsolutePath(String absolutePath)
	{
		if (absolutePath == null)
			throw new IllegalArgumentException("Absolute path is null");
		_absolutePath = absolutePath;
	}
	
	/**
	 * Gets absolute path
	 * @return Absolute path
	 */
	public String getAbsolutePath()
	{
		return _absolutePath;
	}
	
	/**
	 * Gets name
	 * @return Field name
	 */
	public final String getName()
	{
		return _name;
	}

	/**
	 * Sets a new group prefix
	 * @param groupPrefix New group prefix
	 */
	public final void setGroupPrefix(String groupPrefix)
	{
		_groupPrefix = groupPrefix;
	}

	/**
	 * Gets the inner group prefix
	 * @return Group prefix
	 */
	protected String getGroupPrefix()
	{
		return _groupPrefix;
	}
	
	/**
	 * Gets path
	 * @return Field path
	 */
	public final String getPath()
	{
		return _path;
	}
	
	/**
	 * For debugging purpose
	 * @return A string version of the object
	 */
	public final String toString()
	{
		return "Element(" + _name + "," + _path + "," + _absolutePath + ","
			+ _values + ")\n";
	}

	/**
	 * Indicates if the field element has a value
	 * @return true if the element has no value, else false
	 */
	public final boolean isEmpty()
	{
		return _values.isEmpty();	
	}

	/**
	 * Creates an element
	 * @param top The top element
	 * @param dom The dom to populate
	 * @param request Cocoon request
	 */
	public final void buildValuedElement(Element top, Document dom, Request request)
	{
		extractValues(_name, request);
		
		// Builds the element
		StringTokenizer st	= new StringTokenizer(_path, "/");
		Element parent		= top;
		String elementStr	= null;
		while (st.hasMoreTokens())
		{
			elementStr = st.nextToken();
			
			// If it's a leave
			if (!st.hasMoreTokens())
			{
				populateElement(dom, elementStr, parent, request);
				break;
			}
			
			// If not
			Element elt = getChild(parent, elementStr); 
				
			// Creates it if it doesn't exist
			if (elt == null)
			{
				elt = dom.createElement(elementStr);
				parent.appendChild(elt);
			}
			parent = elt;
		}
	}
	
	/**
	 * Handy method to get a child by its name
	 * @param elt The parent element
	 * @param name Child name
	 * @return Element Found element or null if not found
	 */
	private Element getChild(Element elt, String name)
	{
		NodeList children = elt.getChildNodes();
		for (int i=0; i<children.getLength(); i++)
		{
			Node node = children.item(i);
			if (name.equals(node.getNodeName()) && node instanceof Element)
				return (Element)node; 
		}
		return null;
	}

	/**
	 * Creates leaves nodes
	 * @param dom DOM document
	 * @param name Node name
	 * @param parent Parent node
	 */
	private void populateElement(Document dom, String name, Element parent, Request request)
	{
		// Special case for attribute
		if (name.startsWith("@"))
		{
			if (_values.size() == 0)
				return;
			FieldValue fv = (FieldValue)_values.get(0);
			parent.setAttribute(name.substring(1), fv.getTextValue());
			return;
		}
		
		// General case for text nodes
		for (int i=0; i<_values.size(); i++)
		{
			// Else creates one element per value
			Element newElement = dom.createElement(name);
			parent.appendChild(newElement);
		
			// Value
			FieldValue fv = (FieldValue)_values.get(i);
			fv.populateElement(dom, newElement, request);
			
			// Removes the element if it's empty
			if (isEmpty(newElement))
				parent.removeChild(newElement);
		}
	}

	/**
	 * Determines if a node is empty
	 * @param elt The element to test
	 * @return true if it's empty, else false
	 */
	private boolean isEmpty(Element elt)
	{
		// Element has attributes, so isn't empty 
		if (elt.hasAttributes())
			return false;
		
		// No attributes, no child => empty
		NodeList children = elt.getChildNodes();
		if	(children.getLength() == 0)
			return true;
		
		// Else, browse all children					
		for (int i=0; i<children.getLength(); i++)
		{
			Node child = children.item(i);
			if (child.getNodeType() == Node.TEXT_NODE
			&& !"".equals(child.getNodeValue()))
				return false;

			if (child.getNodeType() == Node.ELEMENT_NODE
			&& !isEmpty((Element)child))
				return false;			
		}

		return true;
	}

	/**
	 * Extract values from name
	 * @param name Field name
	 * @param request Servlet request
	 */
	public abstract void extractValues(String name, Request request);

	/**
	 * Gets the value from an input field
	 * @param request Servlet request
	 * @param name Field name
	 * @param suffix Field suffix
	 * @return Field value
	 */
	protected final String[] getValues(Request request, String name, String suffix)
	{
		return getValues(request, name + suffix);
	}
	
	/**
	 * Gets the value of an upload file
	 * @param request Servlet request
	 * @param name Field name
	 * @return FilePartFile
	 */
	protected final FilePartFile getUploadFile(Request request, String name)
	{
		String parameterName = FIELD_PREFIX + _groupPrefix + name + UPLOAD_SUFFIX;
		return (FilePartFile)request.get(parameterName);
	}
	
	/**
	 * Gets the value of an upload file
	 * @param request Servlet request
	 * @param name Field name
	 * @return FilePartFile
	 */
	protected final String getUploadFileName(Request request, String name)
	{
		String parameterName = FIELD_PREFIX + _groupPrefix + name + UPLOAD_SUFFIX;
		return request.getParameter(parameterName);
	}
	
	/**
	 * Gets values
	 * @param request Servlet request
	 * @param name Field name
	 * @return The list of values
	 */
	protected final String[] getValues(Request request, String name)
	{
		String parameterName = FIELD_PREFIX + _groupPrefix + name;
		String[] values = request.getParameterValues(parameterName);
		if (values == null)
			return new String[0];

		List returnList = new ArrayList();

		for (int i=0; i<values.length; i++)
		{
			// If the value isn't a multivalued one
			if (values[i].indexOf('$') == -1)
			{
				returnList.add(values[i].trim());
				continue;
			}
			
			// Else, cut around $ sign
			StringTokenizer st
				= new StringTokenizer(values[i], "$");
			while (st.hasMoreTokens())
				returnList.add(st.nextToken().trim());
		}

		String[] toReturn = (String[])returnList.toArray(new String[0]);
		return toReturn;
	}

	/**
	 * Adds a value
	 * @param value The value to add
	 */
	protected final void addValue(FieldValue value)
	{
		_values.add(value);
	}

	/**
	 * Gets attached files
	 * @return The list of attached file names
	 */
	public Collection getAttachedFiles()
	{
		return Collections.EMPTY_LIST;
	}
	
	/**
	 * Gets field values
	 * @return A list of values
	 */
	public List getValues()
	{
		return _values;
	}

	/**
	 * Creates a new field value
	 * @param value Field value
	 * @return The newly created field value
	 */
	protected FieldValue createFieldValue(String value)
	{
		return new FieldValue(_path, value);
	}

	/**
	 * Resets
	 */
	public final void reset()
	{
		_values.clear();
	}

	/**
	 * Gets field by name
	 * @param fieldName Field name
	 * @return field or null if not found
	 */
	public FieldElement getFieldByName(String fieldName)
	{
		if (_name.equals(fieldName))
			return this;
		return null;
	}

	/**
	 * Sets the fact that the field is now multilingual 
	 */
	void setMultilingual()
	{
		_multilingual = true;
	}

	/**
	 * Indicates if the field element is a multilingual one
	 * @return true or false
	 */
	protected boolean isMultilingual()
	{
		return _multilingual;
	}
}
