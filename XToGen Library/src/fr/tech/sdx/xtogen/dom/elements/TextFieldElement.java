/** 
 * Fichier: TextFieldElement.java
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

import java.io.ByteArrayInputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.cocoon.environment.Request;
import org.w3c.dom.Document;

import fr.tech.sdx.xtogen.dom.FieldElement;
import fr.tech.sdx.xtogen.dom.FieldValue;

/**
 * @author Pierre Dittgen <a href="mailto:pierre.dittgen@pass-tech.fr"/>
 */
public class TextFieldElement extends FieldElement
{
	private static final String XML_PREFIX	= "<?xml version=\"1.0\" standalone=\"yes\"?><text>";
	private static final String XML_SUFFIX	= "</text>";

	/**
	 * Constructor
	 * @param name Field name
	 * @param path Field path
	 */
	public TextFieldElement(String name, String path)
	{
		super(name, path);
	}

	/**
	 * Extract values
	 * @param name Field name
	 * @param request Servlet request
	 */
	public final void extractValues(String name, Request request)
	{
		String[] textValues = getValues(request, name);
		String[] languages	= getValues(request, name + ".lang");
		DocumentBuilderFactory factory =
			DocumentBuilderFactory.newInstance();
		factory.setValidating(false);
		DocumentBuilder builder = null;
		try
		{
			builder = factory.newDocumentBuilder();
		}
		catch (ParserConfigurationException pce)
		{
			pce.printStackTrace();
			for (int i=0; i<textValues.length; i++)
			{
				if ("".equals(textValues[i]))
					continue;
				addValue(createFieldValue(textValues[i]));
			}
			return;
		}
		
		// For each values
		for (int i=0; i<textValues.length; i++)
		{
			if ("".equals(textValues[i]))
				continue;
			
			FieldValue fv = null;
			try
			{
				String fragment = XML_PREFIX + textValues[i] + XML_SUFFIX;
				Document doc = builder.parse(new ByteArrayInputStream(fragment.getBytes("UTF-8")));
				fv = new FieldValue(doc);
			}
			catch (Exception ex)
			{
				ex.printStackTrace();
				fv = createFieldValue(textValues[i]);
			}
			if (isMultilingual() && i<languages.length)
				fv.addAttribute("xml:lang", languages[i]);
			addValue(fv); 
		}
	}

}
