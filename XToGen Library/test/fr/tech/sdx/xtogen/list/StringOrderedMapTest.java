/*
 * Created on 17 sept. 2003
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package fr.tech.sdx.xtogen.list;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * @author Nader
 *
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class StringOrderedMapTest extends TestCase {

	/**
	 * Constructor
	 * @param name Test case name
	 */
	public StringOrderedMapTest(String name)
	{
		super(name);
	}

	public void testNull()
	{
		StringOrderedMap som = new StringOrderedMap();
		try
		{
			som.put(null,null);
			fail("put(null,null) didn't throw any exception");
		}
		catch (IllegalArgumentException iae)
		{}
		try
		{
			som.get(null);
			fail("get(null) didn't throw any exception");
		}
		catch (IllegalArgumentException iae)
		{}
	}

	public void testUnique()
	{
		StringOrderedMap som = new StringOrderedMap();
		som.put("k","v1");
		assertEquals("som size", 1, som.keys().length);
		assertEquals("k value", "v1", som.get("k"));
		som.put("k", "v2");
		assertEquals("som size", 1, som.keys().length);
		assertEquals("k value", "v2", som.get("k"));
	}

	public static Test suite()
	{
		return new TestSuite(StringOrderedMapTest.class);
	}
}
