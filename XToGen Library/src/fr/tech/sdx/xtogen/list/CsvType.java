/** 
 *  Fichier: CsvType.java
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

import java.io.Reader;
import java.io.Writer;

import com.Ostermiller.util.BadDelimeterException;
import com.Ostermiller.util.BadQuoteException;
import com.Ostermiller.util.CSVParse;
import com.Ostermiller.util.CSVParser;
import com.Ostermiller.util.CSVPrint;
import com.Ostermiller.util.CSVPrinter;
import com.Ostermiller.util.ExcelCSVParser;
import com.Ostermiller.util.ExcelCSVPrinter;

/**
 *
 *  @author Pierre Dittgen (pierre.dittgen@pass-tech.fr)
 */
public abstract class CsvType
{
	/**
	 * Standard type
	 */
	public static final CsvType STANDARD = new CsvType("standard")
	{
		String _delim = null;
		String _quote = null;
		
		public void changeDelimiter(String delimiterParam)
		{	_delim = delimiterParam;	}
		
		public void changeQuote(String quoteParam)
		{	_quote = quoteParam;	}
	
		public CSVParse newParser(Reader reader)
		{	
			CSVParse parser = new CSVParser(reader);
			try
			{
				if (_delim != null)
					parser.changeDelimiter(getDelimiter(_delim));
			}
			catch (BadDelimeterException bde)
			{ bde.printStackTrace(); }
			try
			{
				if (_quote != null)
					parser.changeQuote(getQuote(_quote));
			}
			catch (BadQuoteException bqe)
			{ bqe.printStackTrace(); }
			return parser;	
		}

		public CSVPrint newPrinter(Writer writer)
		{	return new CSVPrinter(writer);	}
	};
	
	/**
	 * Excel type
	 */
	public static final CsvType EXCEL = new CsvType("excel")
	{
		public CSVParse newParser(Reader reader)
		{	
			CSVParse parser = new ExcelCSVParser(reader);	
			try
			{
				parser.changeDelimiter(';');
			}
			catch (BadDelimeterException bde)
			{
				bde.printStackTrace();
			}
			return parser;	
		}

		public CSVPrint newPrinter(Writer writer)
		{	
			CSVPrint printer = new ExcelCSVPrinter(writer);
			try
			{
				printer.changeDelimiter(';');
			}
			catch (BadDelimeterException bde)
			{
				bde.printStackTrace();
			}
			return printer;
		}
	};

	private String _type = null;
	
	CsvType(String type)
	{
		_type = type;
	}

	/**
	 * Tests the equality with a string
	 * @param type String type
	 * @return true if they match, else false
	 */
	public boolean equals(String type)
	{
		return _type.equals(type);
	}

	/**
	 * Computes type hashcode
	 * @return Hash code
	 */
	public int hashCode()
	{
		return _type.hashCode();
	}

	/**
	 * @param reader Reader
	 * @return The newly created parser
	 */
	public abstract CSVParse newParser(Reader reader);

	/**
	 * @param writer Output writer
	 * @return The newly created printer
	 */
	public abstract CSVPrint newPrinter(Writer writer);

	public void changeDelimiter(String delimiterParam) {}
	public void changeQuote(String quoteParam) {}

	/**
	 * @param type The type to discover
	 * @return The right CSVType or an exception
	 */
	public static CsvType getType(String type)
	{
		if (STANDARD.equals(type))
			return STANDARD;
		if (EXCEL.equals(type))
			return EXCEL;
		throw new IllegalArgumentException("Type <" + type + " is unknown");
	}

	/**
	 * Gets quote from its symbolic name
	 * @param quoteParam Quote parameter
	 * @return The right char or throws an exception
	 */
	public static char getQuote(String quoteParam)
	{
		if ("guillemet".equals(quoteParam))
			return '"';
		if ("apostrophe".equals(quoteParam))
			return '\'';
		throw new IllegalArgumentException("Quote <" + quoteParam
			+ "> is not valid");
	}

	/**
	 * Gets delimiter char from its symbolic name
	 * @param delimParam Delimiter parameter
	 * @return Delimiter char
	 */
	public static char getDelimiter(String delimParam)
	{
		if ("virgule".equals(delimParam))
			return ',';
		if ("pointvirgule".equals(delimParam))
			return ';';
		if ("tabulation".equals(delimParam))
			return '\t';
		throw new IllegalArgumentException("Delimiter <" + delimParam
			 + "> is not valid");
	}
}
