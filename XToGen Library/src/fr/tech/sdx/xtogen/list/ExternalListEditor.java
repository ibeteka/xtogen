/** 
 *  Fichier: ExternalListEditor.java
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

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 *
 *  @author Pierre Dittgen (pierre.dittgen@pass-tech.fr)
 */
public class ExternalListEditor
{
	// Logger
	private static final Logger LOG
		= Logger.getLogger(ExternalListEditor.class);
	
	private static final int TAB_WIDTH = 4;
	private Document		_doc;
	private File			_listFile;
	private DocumentBuilder	_builder = null;
	
	/**
	 * Constructor
	 * @param listFile List file
	 * @throws ParserConfigurationException If no parser can't be found
	 * @throws SAXException If the XML file is not well-formed
	 * @throws IOException If the file can't be read
	 */
	public ExternalListEditor(File listFile)
		throws ParserConfigurationException,  SAXException, IOException
	{
		if (listFile == null)
			throw new IllegalArgumentException("List file is null");
		
		_listFile = listFile;
		try
		{
			FileInputStream fis = new FileInputStream(listFile);
			_doc = getBuilder().parse(fis);
			fis.close();
		}
		catch (FileNotFoundException fnfe)
		{
			LOG.debug("List file <" + listFile + "> not found");
			initDoc();
		}
	}


	private void initDoc()
	{
		_doc = getBuilder().newDocument();
		_doc.appendChild(_doc.createElement("list"));
	}


	/**
	 * Gets values for the vile
	 * @return A nice valued StringOrderedMap
	 */
	public StringOrderedMap getValues()
	{
		StringOrderedMap map = new StringOrderedMap();

		Element listElt = _doc.getDocumentElement();
		int itemCount = 0;
		NodeList nl = listElt.getChildNodes();
		for (int i=0; i<nl.getLength(); i++)
		{
			Node current = nl.item(i);
			if (current == null)
				continue;
			if (!"item".equals(current.getNodeName()))
				continue;
			if (current.getAttributes().getNamedItem("id") == null)
				continue;
			String id = current.getAttributes().getNamedItem("id").getNodeValue();
			if (current.getFirstChild() == null)
				continue;
			String value = current.getFirstChild().getNodeValue();
			map.put(id, value);			
		}
		return map;
	}

	/**
	 * Changes the value of the node identified by its id
	 * @param id Element id
	 * @param newValue The value to put
	 */
	public final void changeValue(String id, String newValue)
	{
		Node node = getNode(id);
		if (node == null)
		{
			addNodeValue(id, newValue);
			return;
		}
		node.setNodeValue(newValue);
	}

	/**
	 * Creates a new Id for the XML file
	 * @return The newly created id
	 */
	public final String newId()
	{
		while (true)
		{
			String id = "xtg" + Long.toHexString(new Date().getTime());
			if (getNode(id) == null)
				return id;
		}
	}
	
	/**
	 * Verifies if an id is already used or not
	 * @param id to test 
	 * @return true or false
	 */
	public final boolean containsId(String id)
	{
		return (getNode(id) != null);
	}
	
	/**
	 * Gets the number of items in the XML list file
	 * @return Item count
	 */
	public final int getItemCount()
	{
		Element listElt = _doc.getDocumentElement();
		int itemCount = 0;
		NodeList nl = listElt.getChildNodes();
		for (int i=0; i<nl.getLength(); i++)
		{
			Node current = nl.item(i);
			if ("item".equals(current.getNodeName()))
				itemCount++;
		}
		return itemCount;		
	}

	/**
	 * Adds a new value in the file
	 * @param id The element id
	 * @param newValue The new value to put
	 * @return true it was added, false if an element with the same "id"
	 * already exists
	 */
	public boolean addValue(String id, String newValue)
	{
		if (getNode(id) != null)
			return false;
			
		addNodeValue(id, newValue);
		return true;	
	}

	/**
	 * Adds a node value
	 * @param id The element id
	 * @param newValue The element value
	 */
	private void addNodeValue(String id, String newValue)
	{
		Element newElement = _doc.createElement("item");
		newElement.setAttribute("id", id);
		newElement.appendChild(_doc.createTextNode(newValue));
		_doc.getDocumentElement().appendChild(newElement);
	}

	/**
	 * Gets a node identified by its id
	 * @param id Node identifier
	 * @return The right node
	 */
	private Node getNode(String id)
	{
		if (id == null)
			throw new IllegalArgumentException("Id is null");
		
		Element listElt = _doc.getDocumentElement();
		NodeList nl = listElt.getChildNodes();
		for (int i=0; i<nl.getLength(); i++)
		{
			Node current = nl.item(i);
			if (!"item".equals(current.getNodeName()))
				continue;
			String currentId = current.getAttributes().getNamedItem("id").getNodeValue();
			if (!id.equals(currentId))
				continue;
			if (current.getFirstChild() == null)
				current.appendChild(_doc.createTextNode(""));
			
			return current.getFirstChild();
		}
		
		return null;
	}

	/**
	 * Deletes a value identified by its id
	 * @param id The id of the value to delete
	 */
	public final void deleteValue(String id)
	{
		if (id == null)
			throw new IllegalArgumentException("Id is null");

		Element listElt = _doc.getDocumentElement();
		NodeList nl = listElt.getChildNodes();
		for (int i=0; i<nl.getLength(); i++)
		{
			Node current = nl.item(i);
			if (!"item".equals(current.getNodeName()))
				continue;
			String currentId = current.getAttributes().getNamedItem("id").getNodeValue();
			if (!id.equals(currentId))
				continue;
			listElt.removeChild(current);
		}
	}

	/**
	 * Flushes content of the file
	 */
	public final void flush()
	{
		initDoc();
	}

	/**
	 * For debugging purpose
	 * @return The serialized dom
	 */
	public final String toString()
	{
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try
		{
			serialize(baos);
		}
		catch (TransformerException te)
		{
			return "ERREUR";
		}
		return baos.toString();		
	}
	
	/**
	 * Save the file
	 * @throws IOException If something bad occurs
	 */
	public final void save()
		throws IOException
	{
		// Creates the directory if it doesn't exist
		_listFile.getParentFile().mkdirs();

		FileOutputStream fos = new FileOutputStream(_listFile);
		try
		{
			serialize(fos);
			fos.flush();
			fos.close();
		}
		catch (TransformerException e)
		{
			e.printStackTrace();
		}
	}

	/**
	 * Serialize the inner dom
	 * @param os the output to use
	 * @throws TransformerException If something weird occurs
	 */
	private void serialize(OutputStream os)
		throws TransformerException
	{
		TransformerFactory xsltFactory = TransformerFactory.newInstance();
		Transformer transformer = xsltFactory.newTransformer();
		transformer.transform(new DOMSource(_doc), new StreamResult(os));
	}

	/**
	 * Access to builder
	 * @return
	 * @throws ParserConfigurationException
	 */
	private DocumentBuilder getBuilder()
	{
		if (_builder != null)
			return _builder;

		DocumentBuilderFactory factory =
			DocumentBuilderFactory.newInstance();
		factory.setValidating(false);
		try
		{
			_builder = factory.newDocumentBuilder();
		}
		catch (ParserConfigurationException pce)
		{
			pce.printStackTrace();
		}
		return _builder;
	}
}