/** 
 *  Fichier: AbstractDocumentBean.java
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
package fr.tech.sdx.xtogen.image;

import java.awt.Dimension;
import java.io.File;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

import fr.gouv.culture.sdx.exception.SDXException;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 *
 */
public abstract class AbstractDocumentBean
{
	private static final String SIZE_REGEX	= "([0-9]{2,3})x([0-9]{2,3})";
	private static final Logger LOG = Logger.getLogger(AbstractDocumentBean.class);

	Dimension	_maxDim = null;
	File		_iconDirectory = null;

	abstract String computeThumbnailFileName();
	
	abstract String getMimeType();
	
	Dimension computeSizeFromString(String str, int defaultWidth, int defaultHeight)
	{
		if (str == null)
		{
			LOG.warn("No size attribute");
			return new Dimension(defaultWidth, defaultHeight);
		}

		Pattern p = Pattern.compile(SIZE_REGEX);
		Matcher m = p.matcher(str);
		if (!m.matches())
		{
			LOG.warn("Bad formed size = [" + str + "]");
			return new Dimension(defaultWidth, defaultHeight);
		}
		
		Dimension dim = new Dimension(Integer.parseInt(m.group(1)), Integer.parseInt(m.group(2)));
		LOG.debug("Max size = " + str);
		LOG.debug("Computed max width = " + dim.width);
		LOG.debug("Computed max height = " + dim.height);
		return dim;
	}
	
	/**
	 * @param file File to get extension
	 * @return file extension
	 */
	String getFileExtension(String file)
	{
		int lastDotIndex = file.lastIndexOf('.');
		if (lastDotIndex == -1)
			return "";
		return file.substring(lastDotIndex+1);
	}

	public void createThumbnail()
		throws Exception
	{
		// Download attached file in a temp file
		File tempFile = File.createTempFile("xtg", "thn");
		LOG.debug("Temporary file = [" + tempFile + "]");
		downloadAttachFile(tempFile);

		// Creates the thumbnail
		try
		{
			File thumbFile = new File(computeThumbnailFileName());
			ThumbnailCreator tc = new ThumbnailCreator(tempFile);
			tc.createThumbnail(thumbFile, _maxDim.width, _maxDim.height);
			LOG.debug("Thumbnail created");
		}
		catch (Throwable t)
		{
			LOG.error("Error while creating thumbnail", t);
		}
		
		// Cleaning
		tempFile.delete();
	}

	/**
	 * Sets new icon directory
	 * @param iconDirectory
	 */
	void setIconDirectory(File iconDirectory)
	{
		_iconDirectory = iconDirectory;
	}

	/**
	 * Gets Icon directory (creates it if it doesn't exist
	 * @return Icon directory
	 */
	File getIconDirectory()
	{
		if (!_iconDirectory.exists())
			_iconDirectory.mkdirs();
		return _iconDirectory;
	}

	abstract void downloadAttachFile(File tempFile)
		throws IOException, SDXException;
}
