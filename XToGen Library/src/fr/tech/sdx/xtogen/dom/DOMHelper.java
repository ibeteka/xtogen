/** 
 * Fichier: DOMHelper.java
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
package fr.tech.sdx.xtogen.dom;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.xml.transform.TransformerException;

import org.apache.cocoon.environment.Request;
import org.apache.log4j.Logger;
import org.apache.xerces.dom.DocumentImpl;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import fr.gouv.culture.sdx.documentbase.DefaultIDGenerator;
import fr.gouv.culture.sdx.exception.SDXException;
import fr.gouv.culture.sdx.framework.FrameworkImpl;
import fr.gouv.culture.sdx.search.lucene.query.Results;
import fr.tech.sdx.xtogen.dom.elements.AttachFieldElement;
import fr.tech.sdx.xtogen.dom.elements.GroupFieldElement;
import fr.tech.sdx.xtogen.util.QueryHelper;

/**
 * A class to help in document edition
 * 
 * @author pierre
 */
public class DOMHelper
{
	/** Document id */
	public static final String DOC_ID		= "documentId";
	/** Document lang */
	public static final String DOC_LANG		= "documentLang";
	/** Interface lang */
	public static final String INT_LANG		= "interfaceLang";
	
	private static final String XTOGEN_URL	= "http://xtogen.tech.fr";	
	private static final Logger LOG = Logger.getLogger(DOMHelper.class);

	private static final int HTTP_PORT = 80;
	private static final int BUFF_SIZE = 1024;

	private Map			_elements			= new HashMap();
	private Map			_groups				= new HashMap();
	private String		_docId				= null;
	private String		_docName			= null;
	private boolean		_versioning			= false;
	private List		_mandatoryFields	= new ArrayList();
	private List		_emptyFields		= new ArrayList();
	private List		_uniqueFields		= new ArrayList();
	private File		_uploadDirectory	= null;
	
	/**
	 * Constructor
	 * @param docName Document name
	 */
	public DOMHelper(String docName)
	{
		_docName = docName;
	}
	
	/**
	 * Sets the default field
	 * @param defaultField Default field name
	 */
	public final void setDefaultField(String defaultField)
	{
		_mandatoryFields.add(defaultField);
	}

	/**
	 * Sets a field as unique
	 * @param uniqueField Field name
	 */
	public final void setUniqueField(String uniqueField)
	{
		_uniqueFields.add(uniqueField);
	}

	/**
	 * Sets versioning on
	 */
	public void setVersioning()
	{
		_versioning = true;
	}

	/**
	 * Sets upload dir
	 * @param uploadDir Upload directory
	 */
	public void setUploadDir(File uploadDir)
	{
		// Sets upload directory
		_uploadDirectory = uploadDir;
	}

	/**
	 * Declare a field of the document
	 * @param name Field name
	 * @param path Field path (if different from name), Xpath syntax
	 * @param strType Field type
	 */
	public final void addField(String name, String path, String strType)
	{
		FieldElement fe = createField(name, path, strType);
		_elements.put(name, fe);
	}

	/**
	 * Creates a new field
	 * @param name Field name
	 * @param path Field path
	 * @param strType Field type (as string)
	 * @return The newly created field element
	 */
	private FieldElement createField(String name, String path, String strType)
	{
		FieldType type	= FieldType.getType(strType);
		FieldElement fe	= type.newFieldElement(name,path); 
		if (FieldType.GROUP.equals(type))
			_groups.put(name, fe);
		return fe;
	}

	/**
	 * Declare a field of the document
	 * @param name Field name
	 * @param path Field path (if different from name), Xpath syntax
	 * @param strType Field type
	 * @param group Field belonging group
	 */
	public final void addField(String name, String path, String strType, String group)
	{
		FieldElement fe = createField(name, path, strType);
		GroupFieldElement gfe = (GroupFieldElement)_groups.get(group);
		gfe.addFieldElement(fe);
	}

	/**
	 * Sets a field as an upload field
	 * @param name Field name
	 */
	public void setUploadField(String name)
	{
		FieldElement fe = getElement(name);
		if (fe == null)
		{
			System.err.println("Field element " + name + " not found");
			return;
		}
		if (!(fe instanceof AttachFieldElement))
		{
			System.err.println("Field element is not an attached one");
			return;
		}
		((AttachFieldElement)fe).setUpload(true, _uploadDirectory);
	}

	/**
	 * Sets a field as multilingual
	 * @param name Field name
	 */
	public void setMultilingualField(String name)
	{
		FieldElement fe = getElement(name);
		fe.setMultilingual();
	}

	/**
	 * Sets a field as mandatory
	 * @param name Field name
	 */
	public void addMandatoryField(String name)
	{
		_mandatoryFields.add(name);		
	}

	/**
	 * Indicates if a form is completely filled (ready to be indexed)
	 * @return true if the form is filled, else false
	 */
	public final boolean isMinimumFilled()
	{
		return _emptyFields.isEmpty();
	}

	/**
	 * Gets the list of the mandatory fields that are not filled.
	 * @return Field name list
	 */
	public final String[] emptyFields()
	{
		return (String[])_emptyFields.toArray(new String[0]);
	}

	/**
	 * Gets an element by its name
	 * 
	 * @param fieldName Field name
	 * @return FieldElement The element
	 */
	private FieldElement getElement(String fieldName)
	{
		// If the element is one field on root
		FieldElement simpleFe = (FieldElement)_elements.get(fieldName);
		if (simpleFe != null)
			return simpleFe;
		
		// Else look further
		for (Iterator it=_elements.values().iterator(); it.hasNext();)
		{
			FieldElement currentFe = (FieldElement)it.next();
			FieldElement namedFe = currentFe.getFieldByName(fieldName);
			if (namedFe != null)
				return namedFe;
		}

		return null;		
	}

	/**
	 * Creates and return the DOM document
	 * @param request The valued request used to populate the dom
	 * @return The newly created dom
	 */
	public final Document createDom(Request request)
		throws Exception
	{
		Document dom = new DocumentImpl();
		Element top = dom.createElement(_docName);

		top.setAttribute("id", getDocumentId(request));

		// Language
		String langId = request.getParameter(DOC_LANG);
		if (langId != null && !"".equals(langId))
				top.setAttribute("xml:lang", langId);
		else	top.setAttribute("xml:lang", request.getParameter(INT_LANG));

		dom.appendChild(top);
		
		LOG.debug("--------------------------------");
		for (Iterator it=_elements.keySet().iterator(); it.hasNext();)
		{
			String eltName = (String)it.next();
			FieldElement elt = (FieldElement)_elements.get(eltName);
			elt.buildValuedElement(top, dom, request);
		}

		LOG.debug("Dom = " + domToString(dom));

		manageEmptyness(dom);
		manageVersioning(request, dom);

		return dom;
	}

	/**
	 * @param dom The created dom
	 */
	private void manageEmptyness(Document dom)
	{
		for (Iterator it=_mandatoryFields.iterator(); it.hasNext();)
		{
			String fieldName = (String)it.next();
			FieldElement element = getElement(fieldName);

			String absolutePath = element.getAbsolutePath();
			if (isEmpty(dom, _docName + "/" + absolutePath))
				_emptyFields.add(element.getName());
		}
	}

	/**
	 * Finds the fields that are not unique
	 * @param dom Document
	 * @param sdxFrame SDX Framework
	 * @param appId Application identifier
	 * @return Result array
	 * @throws SDXException If something weird occurs
	 * @throws IOException If something bad occurs
	 */
	public Result[] findNotUniques(Document dom, FrameworkImpl sdxFrame, String appId)
		throws SDXException, IOException
	{
		List notUniqueFields = new ArrayList();
		
		for (Iterator it=_uniqueFields.iterator(); it.hasNext();)
		{
			String fieldName = (String)it.next();
			FieldElement element = getElement(fieldName);

			String absolutePath = element.getAbsolutePath();
			String value = getValue(dom, _docName + "/" + absolutePath);
			if (value == null || "".equals(value))
				continue;
			Results res =
				QueryHelper.fieldQuery(sdxFrame, appId, _docName, fieldName, value);
			if (res.count() != 0)
				notUniqueFields.add(new Result(fieldName, res.count(), value));
		}
		
		return (Result[])notUniqueFields.toArray(new Result[0]);
	}

	static String getValue(Document dom, String path)
	{
		Element currentElement = dom.getDocumentElement();
		StringTokenizer st = new StringTokenizer(path, "/");
		
		// Just to eat the first token (relative to document element name)
		if (!currentElement.getNodeName().equals(st.nextToken()))
			return null;
		
		// Iteration on tokens
		while (st.hasMoreTokens())
		{
			String elementPath = st.nextToken();
			
			// Look for an attribute
			if (elementPath.startsWith("@"))
			{
				String attValue
					= currentElement.getAttribute(elementPath.substring(1)); 
				return (attValue);
			}			

			// Else look for an element
			currentElement = getChildNode(currentElement, elementPath);
			if (currentElement == null)
				return null;
		}
		
		// Test last node
		return getTextValue(currentElement);
	}

	
	/**
	 * Indicates if a path in a dom is empty or not
	 * @param dom Document 
	 * @param path absolute path
	 * @return true or false
	 */
	static boolean isEmpty(Document dom, String path)
	{
		Element currentElement = dom.getDocumentElement();
		StringTokenizer st = new StringTokenizer(path, "/");
		
		// Just to eat the first token (relative to document element name)
		if (!currentElement.getNodeName().equals(st.nextToken()))
			return true;
		
		// Iteration on tokens
		while (st.hasMoreTokens())
		{
			String elementPath = st.nextToken();
			
			// Look for an attribute
			if (elementPath.startsWith("@"))
			{
				String attValue
					= currentElement.getAttribute(elementPath.substring(1)); 
				return (attValue == null || "".equals(attValue));
			}			

			// Else look for an element
			currentElement = getChildNode(currentElement, elementPath);
			if (currentElement == null)
				return true;
		}
		
		// Test last node
		return (!hasTextNode(currentElement));
	}
	
	/**
	 * Find the first node named as given 
	 * @param elt The element to get the children from
	 * @param tagName Tag name
	 * @return First found element
	 */
	private static Element getChildNode(Element elt, String tagName)
	{
		if (!elt.hasChildNodes())
			return null;
			
		NodeList children = elt.getChildNodes();
		for (int i=0; i<children.getLength(); i++)
		{
			Node node = children.item(i);
			if (	(node.getNodeType() == Node.ELEMENT_NODE)
				&&	(node.getNodeName().equals(tagName)))
				return (Element)node;
		}
		return null;
	}

	/**
	 * Returns true if the given element has a text node
	 * @param elt The element to test
	 * @return true if it has a text child node
	 */
	private static boolean hasTextNode(Element elt)
	{
		if (!elt.hasChildNodes())
			return false;
			
		NodeList children = elt.getChildNodes();
		for (int i=0; i<children.getLength(); i++)
		{
			Node node = children.item(i);
			if (node.getNodeType() == Node.TEXT_NODE)
				return true;
		}
		return false;
	}

	/**
	 * Returns the text value of the given element
	 * @param elt The element to test
	 * @return true if it has a text child node
	 */
	private static String getTextValue(Element elt)
	{
		if (!elt.hasChildNodes())
			return null;
			
		NodeList children = elt.getChildNodes();
		for (int i=0; i<children.getLength(); i++)
		{
			Node node = children.item(i);
			if (node.getNodeType() == Node.TEXT_NODE)
				return node.getNodeValue();
		}
		return null;
	}

	/**
	 * For debugging purpose
	 * @param dom Document
	 * @return String version of the document
	 */
	static String domToString(Document dom)
		throws Exception
	{
		java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
		javax.xml.transform.TransformerFactory xsltFactory = javax.xml.transform.TransformerFactory.newInstance();
		javax.xml.transform.Transformer transformer = xsltFactory.newTransformer();
		transformer.transform(new javax.xml.transform.dom.DOMSource(dom), new javax.xml.transform.stream.StreamResult(baos));

		return baos.toString();
	}

	/**
	 * @param dom
	 */
	private void manageVersioning(Request request, Document dom)
	{
		if (!_versioning)
			return;

		Element versionElt = dom.createElementNS(XTOGEN_URL, "xtg:version");
		dom.getDocumentElement().appendChild(versionElt);
		
		// Created
		String[] on = request.getParameterValues(FieldElement.FIELD_PREFIX + "versioning.created.on");
		String[] by = request.getParameterValues(FieldElement.FIELD_PREFIX + "versioning.created.by");
		if (on != null)
		{
			for (int i=0; i<on.length; i++)
			{
				Element createdElt = dom.createElementNS(XTOGEN_URL, "xtg:created");
				createdElt.setAttribute("on", on[i]);
				createdElt.setAttribute("by", by[i]);
				versionElt.appendChild(createdElt);
			}
		}
		
		// Modified
		on = request.getParameterValues(FieldElement.FIELD_PREFIX + "versioning.modified.on");
		by = request.getParameterValues(FieldElement.FIELD_PREFIX + "versioning.modified.by");
		if (on != null)
		{
			for (int i=0; i<on.length; i++)
			{
				Element modifiedElt = dom.createElementNS(XTOGEN_URL, "xtg:modified");
				modifiedElt.setAttribute("on", on[i]);
				modifiedElt.setAttribute("by", by[i]);
				versionElt.appendChild(modifiedElt);
			}
		}
	}

	/**
	 * Is the document a new document?
	 * @return true for yes, else false
	 */
	public boolean isNewDocument(Request request)
	{
		String docId = request.getParameter(DOC_ID);
		return (docId == null || "".equals(docId));
	}

	/**
	 * Gets document id
	 * @param request Cocoon request
	 * @return Inner or generated id
	 */
	public final String getDocumentId(Request request)
	{
		if (_docId == null)
		{
			if (isNewDocument(request))
					_docId = new DefaultIDGenerator().generate(_docName + "_", null);
			else	_docId = request.getParameter(DOC_ID);
		}
		return _docId;
	}

	private List getAttachedFileNames()
	{
		List attachedFileNames = new ArrayList();
		for (Iterator it=_elements.values().iterator(); it.hasNext();)
		{
			FieldElement fe = (FieldElement)it.next();
			attachedFileNames.addAll(fe.getAttachedFiles());
		}
		return attachedFileNames;
	}

	/**
	 * Download the attached files associated to a document (if needed)
	 * @param appId Application id
	 * @param baseDir Base directory
	 * @param request Cocoon request
	 * @return A collection of downloaded files
	 */
	public final Collection downloadAttachedFiles(String appId, String baseDir, Request request)
		throws UnsupportedEncodingException
	{
		if (appId == null)
			throw new IllegalArgumentException("Application id is null");
		if (baseDir == null)
			throw new IllegalArgumentException("Base directory is null");
		if (request == null)
			throw new IllegalArgumentException("Request is null");
		
		if (isNewDocument(request))
		{
			LOG.debug("Nouveau document, rien a sauvegarder...");
			return Collections.EMPTY_LIST;
		}
		
		// Document base
		String base		= _docName;
		
		// Attach directory
		File documentDir	= new File(baseDir + File.separator + "documents"
			+ File.separator + base);
		
		// Api urls
		String apiUrl	= request.getScheme() + "://" + request.getServerName();
		if (request.getServerPort() != HTTP_PORT)
			apiUrl += ":" + request.getServerPort();
		apiUrl += request.getContextPath() + "/sdx/api-url";
		
		// For all the attached files
		List files = new ArrayList();
		List attachedFileNames = getAttachedFileNames();
		for (Iterator it=attachedFileNames.iterator(); it.hasNext();)
		{
			String fileId = (String)it.next();
			if (fileId == null)
				continue;
			String completeUrl = apiUrl + "/getatt?app=" + appId + "&base="
				+ base + "&id=" + fileId + "&doc="
				+ URLEncoder.encode(getDocumentId(request), "UTF-8");
			
			File file = saveUrl(completeUrl, new File(documentDir,fileId));
			if (file != null)
				files.add(file);
		}
		return files;
	}

	/**
	 * Saves an URL into a file
	 * @param urlStr Url to get content from
	 * @param file File to save into
	 */
	public static File saveUrl(String urlStr, File file)
	{
		try
		{
			// Nothing to do
			if (file.exists())
				return null;

			LOG.debug("Fichier attache " + file + " introuvable");
			LOG.debug("Sauvegarde a partir de " + urlStr);
			URL url = new URL(urlStr);
			HttpURLConnection urlConnection
				= (HttpURLConnection)url.openConnection();
			BufferedInputStream bis
				= new BufferedInputStream(urlConnection.getInputStream());
			FileOutputStream fos = new FileOutputStream(file);
			byte[] buff = new byte[BUFF_SIZE];
			while (true)
			{
				int len = bis.read(buff);
				if (len == -1)
					break;
				fos.write(buff, 0, len);
			}
			fos.flush();
			fos.close();
			LOG.debug("Sauvegarde ok");
			return file;
		}
		catch (IOException ioe)
		{
			LOG.warn("Erreur lors de la sauvegarde", ioe);
			return null;
		}
	}

	/**
	 * Serializes a document to a file
	 * @param doc DOM document
	 * @param file The file to serialize in
	 * @throws IOException I/O exception
	 * @throws TransformerException If something weird occurs
	 */
	public static void serializeToFile(Document doc, File file)
		throws IOException, TransformerException
	{
		// DOM serialization
		java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
		javax.xml.transform.TransformerFactory xsltFactory = javax.xml.transform.TransformerFactory.newInstance();
		javax.xml.transform.Transformer transformer = xsltFactory.newTransformer();
		transformer.transform(new javax.xml.transform.dom.DOMSource(doc), new javax.xml.transform.stream.StreamResult(baos));

		String domContent = baos.toString();

		FileOutputStream fos = new FileOutputStream(file);
		fos.write(baos.toByteArray());
		fos.flush();
		fos.close();
	}

	/**
	 * Result object
	 */
	public static class Result
	{
		private String	_fieldName;
		private int		_occurrence;
		private String	_value;
		
		/**
		 * Constructor
		 * @param fieldName Field name
		 * @param occurrence Occurrence number
		 * @param value Field value
		 */
		public Result(String fieldName, int occurrence, String value)
		{
			_fieldName = fieldName;
			_occurrence = occurrence;
			_value = value;
		}
		
		/**
		 * Gets field name
		 * @return field name
		 */
		public String getFieldName()
		{
			return _fieldName;
		}
		
		/**
		 * Gets occurrence number
		 * @return Occurrence number
		 */
		public int getOccurrence()
		{
			return _occurrence;
		}

		/**
		 * Gets value
		 * @return Value
		 */
		public String getValue()
		{
			return _value;
		}
	} 
}
