/** 
 * Fichier: FieldValue.java
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
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import org.apache.cocoon.environment.Request;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

/**
 * FieldValue
 */
public class FieldValue
{
	private String		_textValue		= null;
	private Document	_doc			= null;
	private Properties	_attributes		= new Properties();
	private List		_children		= new ArrayList();
	private String		_groupPrefix	= null;

	/**
	 * Constructor
	 * @param fieldPath Field path
	 * @param textValue Text value
	 */
	public FieldValue(String fieldPath, String textValue)
	{
		_textValue	= textValue;
	}
	
	/**
	 * Constructor
	 * @param doc DOM document
	 */
	public FieldValue(Document doc)
	{
		_doc = doc;
	}

	/**
	 * Adds a string attribute to the list
	 * @param name Attribute name
	 * @param value Attribute value
	 */
	public final void addAttribute(String name, String value)
	{
		_attributes.setProperty(name, value);
	}

	/**
	 * Adds an element to the dom
	 * @param dom The dom to populate
	 * @param parent The element to append to
	 * @param request Cocoon request
	 */
	public final void populateElement(Document dom, Element parent, Request request)
	{
		// Text node
		if (_textValue != null && !"".equals(_textValue))
		{
			parent.appendChild(dom.createTextNode(_textValue));
		}
		// dom node
		if (_doc != null)
		{
			NodeList list = _doc.getDocumentElement().getChildNodes();
			for (int i=0; i<list.getLength(); i++)
				parent.appendChild(dom.importNode(list.item(i), true));
		}
		
		// Attributes
		for (Iterator it=_attributes.keySet().iterator(); it.hasNext();)
		{
			String name = (String)it.next();
			parent.setAttribute(name, _attributes.getProperty(name));
		}
		
		// Children
		for (Iterator it=_children.iterator(); it.hasNext();)
		{
			FieldElement fe = (FieldElement)it.next();
			fe.reset();
			fe.setGroupPrefix(_groupPrefix);
			fe.buildValuedElement(parent, dom, request);
		}
	}

	/**
	 * Gets the text value of the field
	 * @return text value
	 */
	public final String getTextValue()
	{
		return _textValue;
	}
	
	/**
	 * Gets the value of an attribute
	 * @param attributeName Attribute name
	 * @return The attribute value
	 */
	public String getAttribute(String attributeName)
	{
		return _attributes.getProperty(attributeName);
	}

	/**
	 * Adds a child
	 * @param fe Child field element
	 */
	public void addChild(FieldElement fe)
	{
		_children.add(fe);
	}

	/**
	 * Sets a new group prefix
	 * @param groupPrefix Group prefix
	 */
	public void setGroupPrefix(String groupPrefix)
	{
		_groupPrefix = groupPrefix;
	}

	/**
	 * For debugging purpose
	 * @return A string version of the object
	 */
	public String toString()
	{
		StringBuffer buffer = new StringBuffer("");
		
		buffer.append("Field value (").append(_textValue).append(")\n");
		for (Iterator it=_attributes.keySet().iterator(); it.hasNext();)
		{
			String key = (String)it.next();
			buffer.append("\t").append(key).append(" = ");
			buffer.append(_attributes.getProperty(key)).append("\n");
		}
		if (_children.size() != 0)
		{
			buffer.append("Children:\n");
			for (Iterator it=_children.iterator(); it.hasNext();)
			{
				FieldElement fe = (FieldElement)it.next();
				buffer.append(fe.toString());
			}
		}
		
		return buffer.toString();
	}
}
