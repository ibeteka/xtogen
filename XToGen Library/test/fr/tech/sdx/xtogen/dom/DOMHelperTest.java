/*
 * Created on 30 sept. 03
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package fr.tech.sdx.xtogen.dom;

import java.io.ByteArrayInputStream;

import org.apache.xerces.parsers.DOMParser;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * @author Nader
 *
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DOMHelperTest extends TestCase
{
	private static final String TEST_XML_STRING =
"<?xml version=\"1.0\" standalone=\"yes\"?>\n" +"<europe>" +
"<france>" +"<paris>Delanoe</paris>" +"<toulouse/>" +"</france>" +"<allemagne>" +"<badewurtemberg>Frenz</badewurtemberg>" +"<bayern>" +"<erlangen/>" +"</bayern>" +"</allemagne>" +"</europe>";
	
	/**
	 * Constructor
	 * @param name Test case name
	 */
	public DOMHelperTest(String name)
	{
		super(name);
	}

	public void testDom()
		throws Exception
	{
		DOMParser parser = new DOMParser();
		parser.parse(new InputSource(new ByteArrayInputStream(TEST_XML_STRING.getBytes())));
		Document dom = parser.getDocument();
		System.err.println(DOMHelper.domToString(dom));
		
		assertTrue("Test avec europe/france/paris", !DOMHelper.isEmpty(dom, "europe/france/paris"));
		assertTrue("Test avec europe/france/toulouse", DOMHelper.isEmpty(dom, "europe/france/toulouse"));
		assertTrue("Test avec europe/pologne", DOMHelper.isEmpty(dom, "europe/pologne"));
	}

	/**
	 * Creates the test suite
	 * @return Newly created test suite
	 */
	public static Test suite()
	{
		return new TestSuite(DOMHelperTest.class);
	}
	
	public static void main(String args[])
	{
		new DOMHelperTest("testDom").run();
	}
}