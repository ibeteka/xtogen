/*
 * Created on 17 sept. 2003
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package fr.tech.sdx.xtogen.serializer;

import java.io.FileReader;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 * @author Nader
 *
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CSVSerializerTest extends TestCase
{
	private final static String parserName 
		= "org.apache.xerces.parsers.SAXParser";
	
	/**
	 * @param name Test case name
	 */
	public CSVSerializerTest(String name)
	{
		super(name);
	}
	
	public void testSerializer()
		throws Exception
	{
		XMLReader xr = XMLReaderFactory.createXMLReader(parserName);
		
		CSVSerializer handler = new CSVSerializer();
		handler.setOutputStream(System.err);
		xr.setContentHandler(handler);

		FileReader r = new FileReader("test/fr/tech/sdx/xtogen/serializer/array.xml");
		xr.parse(new InputSource(r));
	}

	/**
	 * Creates the test suite
	 * @return The newly created test suite
	 */
	public static Test suite()
	{
		return new TestSuite(CSVSerializerTest.class);
	}

}
