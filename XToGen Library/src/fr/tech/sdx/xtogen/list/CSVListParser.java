/** 
 *  Fichier: CSVListHelper.java
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

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Iterator;
import java.util.Properties;

import com.Ostermiller.util.CSVParse;

/**
 *
 *  @author Pierre Dittgen (pierre.dittgen@pass-tech.fr)
 */
public class CSVListParser
{
	private static final String DEFAULT_CHARSET = "iso-8859-1";
	private File		_csvFile	= null;
	private CsvType		_type		= null;
	
	// Run time
	private Properties	_prop		= new Properties();
	private String[]	_headers	= null;
	private String[]	_row		= null;
	private CSVParse	_parser		= null;
	private String		_charset	= DEFAULT_CHARSET;
	
	/**
	 * Constructor
	 * @param csvFile CSV file to read
	 * @param type Excel or standard
	 * @param delimiterParam Delimiter
	 * @param quoteParam Quote
	 */
	public CSVListParser(File csvFile, String type, String delimiterParam, String quoteParam)
	{
		if (csvFile == null)
			throw new IllegalArgumentException("csvFile is null");
		if (type == null)
			throw new IllegalArgumentException("csv type is null");
		
		_csvFile	= csvFile;
		_type		= CsvType.getType(type);
		_type.changeDelimiter(delimiterParam);
		_type.changeQuote(quoteParam);
	}

	/**
	 * Changes charset if different from DEFAULT_CHARSET (iso-8859-1)
	 * @param charset
	 */
	public void setCharset(String charset)
	{
		_charset = charset;
	}

	/**
	 * Resets
	 * @throws IOException If something bad occurs
	 */
	public void reset()
		throws IOException
	{
		FileInputStream is = new FileInputStream(_csvFile);
		InputStreamReader isr = new InputStreamReader(is, _charset);
		_parser = _type.newParser(new BufferedReader(isr));
	}
	
	/**
	 * Gets CSV headers
	 * @return String array
	 * @throws Exception If something uncoverable occurs
	 */
	public String[] getHeaders()
		throws Exception
	{
		if (_parser == null)
			reset();
		_headers	= _parser.getLine();
		_row		= _parser.getLine();
		return _headers;
	}
	
	/**
	 * Just to know if we can continue to read
	 * @return true if we can continue, else false
	 */
	public boolean hasRow()
	{
		return (_row != null);
	}
	
	/**
	 * Gets a row as a properties hash
	 * @return Valued properties hash
	 * @throws IOException If a I/O error occurs
	 */
	public Properties getRow()
		throws IOException
	{
		_prop.clear();
		for (int i=0; i<_headers.length; i++)
		{
			if (i >= _row.length)
				break;
			_prop.setProperty(_headers[i], _row[i]);
		}
		_row = _parser.getLine();
		return _prop;
	}

	/**
	 * Says if a properties instance is empty or not. Empty here means that
	 * all values are equals to empty string.
	 * @param prop Properties instance to check
	 * @return true if empty
	 */
	public boolean isEmpty(Properties prop)
	{
		for (Iterator it = prop.keySet().iterator(); it.hasNext();)
		{
			String key = (String)it.next();
			if (prop.getProperty(key) != null && !"".equals(prop.getProperty(key)))
				return false;
		}
		return true;
	}

    /**
     * Closes the CSV file
     * @throws IOException If a I/O error occurred
     */
	public void close() throws IOException
    {
        if (_parser != null)
            _parser.close();
    }
}
