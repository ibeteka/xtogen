/** 
 *  Fichier: DOMBuilder.java
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
package fr.tech.sdx.xtogen.dom;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.StringTokenizer;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.xerces.dom.DocumentImpl;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

/**
 *
 *  @author Pierre Dittgen (pierre.dittgen@pass-tech.fr)
 */
public class DOMBuilder
{
	private Document _dom = null;
	
	/**
	 * Constructor
	 * @param rootElementName Document element name
	 * @param id Document id
	 */
	public DOMBuilder(String rootElementName, String id, String lang)
	{
		if (rootElementName == null)
			throw new IllegalArgumentException("Root element name is null");
		if (id == null)
			throw new IllegalArgumentException("Id is null");
		if (lang == null)
			throw new IllegalArgumentException("Lang is null");
	
		_dom = new DocumentImpl();
		Element top = _dom.createElement(rootElementName);
		top.setAttribute("id", id);
		top.setAttribute("xml:lang", lang);
		_dom.appendChild(top);
	}

	/**
	 * Adds a new field
	 * @param fieldName Field name
	 * @param fieldPath Field path
	 * @param value Field value
	 */
	public void populateField(String fieldName, String fieldPath, String value)
	{
		if (fieldName == null)
			throw new IllegalArgumentException("Field name is null");
		if (fieldPath == null)
			throw new IllegalArgumentException("Field path is null");
		if (value == null)
			return;
		
		// No field path or field path = field name
		if ("".equals(fieldPath) || fieldPath.equals(fieldName))
		{
			Element newElement = _dom.createElement(fieldName);
			_dom.getDocumentElement().appendChild(newElement);
			
			addText(newElement, value);
			return;
		}
		
		// Path is cut into little pieces
		StringTokenizer st = new StringTokenizer(fieldPath, "/");
		Element parent = _dom.getDocumentElement();
		while (st.hasMoreTokens())
		{
			String eltName = st.nextToken();
			
			// Attribute
			if (eltName.startsWith("@"))
			{
				parent.setAttribute(eltName.substring(1), value);
				return;
			}
			
			// Normal element
			Element newElt = _dom.createElement(eltName);
			parent.appendChild(newElt);
			if (!st.hasMoreTokens())
			{
				addText(newElt, value);
				return;
			}

			parent = newElt;
		}
	}
	
	/**
	 * Adds a valued text element to the given element
	 * @param currentElt The element to append to
	 * @param value The value to use
	 */
	private void addText(Element currentElt, String value)
	{
		// No dollar, no problem
		if (value.indexOf("$") == -1)
		{
			currentElt.appendChild(_dom.createTextNode(value));
			return;
		}
		
		// Splits around dollars
		String tagName = currentElt.getNodeName();
		Node parent = currentElt.getParentNode();
		parent.removeChild(currentElt);
		Element childElt = null;
		StringTokenizer st = new StringTokenizer(value, "$");
		while (st.hasMoreTokens())
		{
			String valueStr = st.nextToken();
			childElt = _dom.createElement(tagName);
			parent.appendChild(childElt);
			childElt.appendChild(_dom.createTextNode(valueStr));
		}
	}
	
	/**
	 * Saves the dom into a file
	 * @param f The file to save the DOM into
	 */
	public void saveDom(File f)
		throws IOException, TransformerException
	{
		DOMHelper.serializeToFile(_dom, f);
	}

	public String toString()
	{
		// DOM serialization
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		TransformerFactory xsltFactory = TransformerFactory.newInstance();
		Transformer transformer;
		try
		{
			transformer = xsltFactory.newTransformer();
			transformer.transform(new DOMSource(_dom), new StreamResult(baos));
		}
		catch (TransformerException te)
		{
			return "ERROR !!!";
		}

		return baos.toString();
	}
}
