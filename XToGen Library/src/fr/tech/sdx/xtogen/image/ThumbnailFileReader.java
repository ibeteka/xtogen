/** 
 *  Fichier: ThumbnailSDXReader.java
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

import java.io.File;
import java.io.IOException;

import org.apache.avalon.framework.component.ComponentManager;
import org.apache.avalon.framework.component.Composable;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.log4j.Logger;

import fr.gouv.culture.sdx.exception.SDXException;
import fr.tech.sdx.xtogen.util.FileHelper;

/**
 * @author Pierre Dittgen (pierre.dittgen(at)pass-tech.fr)
 * A class to read thumbnail from image stored in SDX database
 */
public class ThumbnailFileReader extends AbstractThumbnailReader implements Composable
{
	// Logger
	private static final Logger LOG
		= Logger.getLogger(ThumbnailFileReader.class);

	/**
	 * Call to the factory
	 */
	protected AbstractDocumentBean newAttachDocumentBean(Parameters par, ComponentManager manager, String baseDirectory)
	{
		return new AttachDocumentBean(par, baseDirectory, 
			new File(baseDirectory + File.separator + "conf" + File.separator + "athn"));
	}

	/**
	 * Simple class to get information from URL
	 */
	public static class AttachDocumentBean extends AbstractDocumentBean
	{
		private String		_appId				= null;
		private String		_baseId				= null;
		private String		_nameId				= null;
		private File		_attachDirectory	= null; 

		/**
		 * Constructor
		 * @param par Parameters
		 */
		public AttachDocumentBean(Parameters par, String baseDirectory, File iconDirectory)
		{
			_appId = par.getParameter("app", null);
			_baseId = par.getParameter("base", null);
			_nameId = par.getParameter("name", null);
			LOG.debug("Application = " + _appId);
			LOG.debug("Base = " + _baseId);
			LOG.debug("Name = " + _nameId);

			String maxSize = par.getParameter("size", null);
			_maxDim = computeSizeFromString(maxSize, 150, 150);
			setIconDirectory(iconDirectory);
			_attachDirectory = new File(baseDirectory, "documents" + File.separator
				+ _baseId + File.separator + "attach");
		}

		/**
		 * @param tempFile
		 */
		public void downloadAttachFile(File tempFile)
			throws IOException, SDXException
		{
			FileHelper.copy(new File(_attachDirectory, _nameId), tempFile);
		}

		/**
		 * @return Mime type of attached document
		 */
		public String getMimeType()
		{
			String fileExtension = getFileExtension(_nameId); 
			return FileType.getMimeFromExtension(fileExtension);
		}

		/**
		 * @return Thumbnail file name
		 */
		public String computeThumbnailFileName()
		{
			File directory = new File(getIconDirectory().getAbsolutePath()
				+ File.separator + _baseId
				+ File.separator + _maxDim.width + 'x' + _maxDim.height);
			if (!directory.exists())
				directory.mkdirs();
			
			String nameId = _nameId;
			LOG.debug("ATTACH ID BEFORE = " + nameId);
			nameId = nameId.replace('\\', '_');
			nameId = nameId.replace('/', '_');
			nameId = nameId.replace('.', '_');
			LOG.debug("ATTACH ID AFTER = " + nameId);
			
			String thnFileName = directory.getAbsolutePath() + File.separator
				+ nameId + "_thn.png";
			LOG.debug("Thumbnail filename = <" + thnFileName + ">");
			return thnFileName; 
		}
	}
}
