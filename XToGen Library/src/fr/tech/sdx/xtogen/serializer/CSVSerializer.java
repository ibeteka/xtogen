/*
 * Created on 17 sept. 2003
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package fr.tech.sdx.xtogen.serializer;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.avalon.framework.configuration.Configurable;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.cocoon.serialization.Serializer;
import org.xml.sax.Attributes;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;

import com.Ostermiller.util.CSVPrint;

import fr.tech.sdx.xtogen.list.CsvType;
import fr.tech.sdx.xtogen.list.StringOrderedMap;

/**
 * @author Nader
 *
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CSVSerializer implements Serializer, Configurable
{
	private static final String MIME_TYPE = "text/comma-separated-values";
	private StringBuffer		_buffer 		= new StringBuffer("");
	private Writer				_writer			= null;
	private CSVPrint			_printer		= null;
	private String				_colId			= null;
	private	StringOrderedMap	_values			= new StringOrderedMap();
	private String 				_mvSeparator	= "$";
	private List				_cols			= new ArrayList();
	private CsvType				_csvType		= CsvType.EXCEL;
	private String				_separator		= null;
	private String				_quote			= null;
	private String 				_encoding		= "iso-8859-1";
	
	/**
	 * Constructor 
	 */
	public CSVSerializer()
	{
		super();
	}

	/**
	 * Set the configurations for this serializer.
	 */
	public void configure(Configuration conf)
	  throws ConfigurationException
	{
		Configuration encoding = conf.getChild("encoding");
		if (!encoding.getLocation().equals("-"))
			_encoding = encoding.getValue();
	}
	
	/**
	 * Sets output stream
	 */
	public void setOutputStream(OutputStream out) throws IOException
	{
		_writer = new BufferedWriter(new OutputStreamWriter(out,_encoding));
	}

	/**
	 * Returns text/plain
	 */
	public String getMimeType()
	{
		return MIME_TYPE;
	}

	/**
	 * Sets no content-length
	 */
	public boolean shouldSetContentLength()
	{
		return false;
	}

	/**
	 * Sets document locator
	 */
	public void setDocumentLocator(Locator arg0)
	{
		return;	
	}

	/**
	 * Beginning of the document
	 */
	public void startDocument() throws SAXException
	{
	}

	/**
	 * End of the document
	 */
	public void endDocument() throws SAXException
	{
		return;
	}

	/**
	 * Manages prefix mapping
	 */
	public void startPrefixMapping(String arg0, String arg1)
		throws SAXException
	{
		return;
	}

	/**
	 * Manages prefix mapping
	 */
	public void endPrefixMapping(String arg0)
		throws SAXException
	{
		return;
	}

	/**
	 * Manages start element
	 */
	public void startElement(String uri, String localName, String qName, Attributes atts)
		throws SAXException
	{
		resetBuffer();

		// Value
		if ("value".equals(qName))
			_colId = atts.getValue("col");
		// Row
		else if ("row".equals(qName))
			initValues();
	}

	/**
	 * Inits values
	 */
	private void initValues()
	{
		_values.reset();
		for (Iterator it=_cols.iterator(); it.hasNext();)
		{
			String colName = (String)it.next();
			_values.put(colName,"");
		}
	}

	/**
	 * Resets the character buffer
	 */
	private void resetBuffer()
	{
		_buffer.setLength(0);
	}

	/**
	 * Manages endElement
	 */
	public void endElement(String uri, String localName, String qName)
		throws SAXException
	{
		String text = _buffer.toString();
		
		if ("format".equals(qName))
		{
			_csvType = CsvType.getType(text);
		}
		else if ("separator".equals(qName))
		{
			_separator = text;
		}
		else if ("quote".equals(qName))
		{
			_quote = text;
		}
		else if ("mvseparator".equals(qName))
		{
			_mvSeparator = text;
		}
		else if ("col".equals(qName))
		{
			getPrinter().print(text);
			addColName(text);
		}
		else if ("header".equals(qName))
		{
			getPrinter().println();
		}
		else if ("value".equals(qName))
		{
			String oldValue = _values.get(_colId);
			if ("".equals(oldValue))
					_values.put(_colId, text);
			else	_values.put(_colId, oldValue + _mvSeparator + text);
		}
		else if ("row".equals(qName))
		{
			String[] keys = _values.keys();
			for (int i=0; i<keys.length; i++)
				getPrinter().print(_values.get(keys[i]));
			getPrinter().println();
		}
	}

	/**
	 * @param colName
	 */
	private void addColName(String colName)
	{
		_cols.add(colName);
	}

	/**
	 * Manage characters
	 */
	public void characters(char[] ch, int start, int length)
		throws SAXException
	{
		char[] output = new char[ length ];
		System.arraycopy(ch, start, output, 0, length);
		
		_buffer.append(output);
	}

	/**
	 * Manages ignorable whitespace
	 */
	public void ignorableWhitespace(char[] arg0, int arg1, int arg2)
		throws SAXException
	{
		return;
	}

	/**
	 * Manages processing instruction
	 */
	public void processingInstruction(String arg0, String arg1)
		throws SAXException
	{
		return;
	}

	/**
	 * Manages entity
	 */
	public void skippedEntity(String arg0) throws SAXException
	{
		return;
	}

	/**
	 * Manages DTD
	 */
	public void startDTD(String arg0, String arg1, String arg2)
		throws SAXException
	{
		return;
	}

	/**
	 * Manages DTD
	 */
	public void endDTD() throws SAXException
	{
		return;
	}

	/**
	 * Manages entity
	 */
	public void startEntity(String arg0) throws SAXException
	{
		return;
	}

	/**
	 * Manages entity
	 */
	public void endEntity(String arg0) throws SAXException
	{
		return;
	}

	/**
	 * Manages CDATA
	 */
	public void startCDATA() throws SAXException
	{
		return;
	}

	/**
	 * Manages CDATA
	 */
	public void endCDATA() throws SAXException
	{
		return;
	}

	/** 
	 * Manages comment
	 */
	public void comment(char[] arg0, int arg1, int arg2) throws SAXException
	{
		return;
	}

	private CSVPrint getPrinter()
	{
		if (_printer != null)
			return _printer;
		
		// Creates printer
		_csvType.changeDelimiter(_separator);
		_csvType.changeQuote(_quote);
		_printer = _csvType.newPrinter(_writer);

		return _printer;
	}
}
